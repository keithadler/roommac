**[Download Room for Mac 1.0.1 (DMG)](https://github.com/keithadler/roommac/releases/download/v1.0.1/Room-for-Mac-1.0.1.dmg)**

Cleanup and speed for the whole family. It finds what is taking up space and what is slowing the Mac
down, explains every item in plain language, and only ever moves things to the Trash, with a receipt
that puts them back. It never asks for your password and nothing ever leaves the Mac.

### Installing it

1. Click the bold link above. **Room-for-Mac-1.0.1.dmg** saves to your Downloads folder.
2. Double-click it and drag the **Room for Mac** icon onto the **Applications** folder beside it.
3. Open it from Launchpad or Applications. macOS says it **can't check the app for malicious
   software**: click **Done**. Then Apple menu > **System Settings** > **Privacy & Security**,
   scroll to the bottom, and click **Open Anyway** next to "Room for Mac".

That warning is normal for any app not sold through Apple. Apple charges $99 a year for the
certificate that removes it; this is a free, open-source project without one, and all of the code is
in this repository.

### New in 1.0.1

Built and tested on macOS 27.

- The Speed tab reads the drive's health again. On macOS 27 it said "Not reported" because the system
  report names that field differently now.
- The display sleep setting is read correctly when something is keeping the screen awake; it used to
  come back empty.
- The "is this Mac done" verdict says plainly that macOS 26 was the last version for Intel Macs and
  macOS 27 needs Apple silicon, and no longer calls every Apple chip "current-generation".
- American spelling for "Optimize Mac Storage" and the Photos background-activity notes.

Works on any Mac running macOS 14 Sonoma or newer. MIT licensed. Nothing phones home.
