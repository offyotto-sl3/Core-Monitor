import SwiftUI
import Combine
import Darwin

struct ContentView: View {

    @State private var pCoreUsage = 0
    @State private var eCoreUsage = 0
    @State private var previousTicks: [[UInt32]] = []

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 8) {
            Text("Performance cores: \(pCoreUsage)%")
            Text("Efficiency cores: \(eCoreUsage)%")
        }
        .padding()
        .onReceive(timer) { _ in
            updateCPU()
        }
    }

    func updateCPU() {

        var numCPUs: natural_t = 0
        var cpuInfo: processor_info_array_t?
        var numCPUInfo: mach_msg_type_number_t = 0

        let result = host_processor_info(
            mach_host_self(),
            PROCESSOR_CPU_LOAD_INFO,
            &numCPUs,
            &cpuInfo,
            &numCPUInfo
        )

        guard result == KERN_SUCCESS, let cpuInfo = cpuInfo else {
            return
        }

        let cpuLoadInfo = cpuInfo.withMemoryRebound(
            to: processor_cpu_load_info.self,
            capacity: Int(numCPUs)
        ) { $0 }

        var currentTicks: [[UInt32]] = []

        for i in 0..<Int(numCPUs) {
            let ticks = cpuLoadInfo[i].cpu_ticks
            currentTicks.append([ticks.0, ticks.1, ticks.2, ticks.3])
        }

        if previousTicks.isEmpty {
            previousTicks = currentTicks
            return
        }

        var pTotal: Float = 0
        var eTotal: Float = 0

        for i in 0..<Int(numCPUs) {

            let prev = previousTicks[i]
            let curr = currentTicks[i]

            let user = curr[0] - prev[0]
            let sys = curr[1] - prev[1]
            let idle = curr[2] - prev[2]
            let nice = curr[3] - prev[3]

            let total = Float(user + sys + idle + nice)

            if total == 0 { continue }

            let usage = Float(user + sys + nice) / total * 100

            // Apple Silicon typical layout (4P + 4E etc.)
            if i < Int(numCPUs) / 2 {
                pTotal += usage
            } else {
                eTotal += usage
            }
        }

        previousTicks = currentTicks

        let pAvg = pTotal / Float(numCPUs / 2)
        let eAvg = eTotal / Float(numCPUs / 2)

        pCoreUsage = Int(pAvg)
        eCoreUsage = Int(eAvg)
    }
}

#Preview {
    ContentView()
}
