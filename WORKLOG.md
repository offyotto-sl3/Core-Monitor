# WORKLOG

## 2026-04-15

### Reviewed
- Repository structure, app bootstrap, menu bar controller, dashboard window flow, `SystemMonitor`, fan control, helper/XPC path, and current docs.
- Current build and test health with `xcodebuild` on macOS.
- Runtime behavior far enough to confirm the app launches as menu bar items and relies on menu bar access by default.

### Baseline
- `xcodebuild -project Core-Monitor.xcodeproj -scheme Core-Monitor -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO build` succeeded.
- `xcodebuild -project Core-Monitor.xcodeproj -scheme Core-Monitor -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO test` succeeded.
- The worktree already contained significant local changes, so all edits in this session are layered on top without reverting in-progress work.

### Prioritized action list
- Improve menu bar configuration UX and reduce menu bar clutter friction with presets and clearer live-item controls.
- Keep chipping away at the oversized SwiftUI surfaces, starting with `ContentView.swift`.
- Continue runtime/menu bar polish, then convert competitor findings into product and documentation improvements.

### In progress
- Extracted the menu bar configuration card into its own SwiftUI file.
- Added menu bar presets and live preview values to make density choices faster and more obvious.

### Completed batch
- Verified the menu bar settings refactor and preset flow with a fresh macOS build and test pass.
- Confirmed the debug app still launches and publishes the expected live menu bar item titles after the change.

### Next batch
- Added a sourced competitor matrix covering Stats, iStat Menus 7, TG Pro, and Macs Fan Control.
- Captured the product and trust implications so roadmap and README changes can point to concrete public evidence instead of vague claims.

### Completed batch
- Refined the first-launch welcome guide into smaller SwiftUI subviews and turned the final step into a live readiness checklist for menu bar reachability, launch-at-login, and helper state.
- Verified the onboarding refactor with a fresh macOS build and test pass.

### Completed batch
- Traced an actual startup UX regression: the default Touch Bar weather path was prompting for location on launch before the dashboard flow was even reachable.
- Changed weather to stay dormant until the user explicitly opts in, added a dedicated location-access control in Touch Bar settings, and updated weather widgets to explain the dormant state instead of showing a vague failure.
- Rebuilt, reran the macOS test suite, and confirmed at runtime that launch now lands in the menu bar popover without the location permission modal hijacking first use.
