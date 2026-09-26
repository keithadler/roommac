# Changelog

## 1.0.1 - 2026-09-25

Built and tested on macOS 27.

- Drive health: macOS 27's `system_profiler SPNVMeDataType` reports `smart_status` instead of the
  older prefixed key, so the Speed tab showed the drive as "Not reported". Both forms are read now.
- Display sleep: `pmset -g` appends a note such as "(display sleep prevented by caffeinate)" when
  something holds the screen awake, which made the minutes unreadable. The number at the start is
  read now.
- The "is this Mac done" verdict: Intel Macs are told macOS 26 was their last version and macOS 27
  needs Apple silicon; Apple silicon Macs are no longer all called "current-generation".
- Setting a default app: the NSWorkspace completion handler is `@Sendable` and hops to the main
  actor, which clears the five Swift 6.4 data-race warnings. Nothing changes in how it behaves.
- American spelling in a few user-facing strings ("Optimize Mac Storage", "analyzing", "organizing").

## 1.0.0 - 2026-09-21

First release as Room for Mac (formerly Tidy for Mac).
