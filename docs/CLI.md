# The `roommac` command line

Room for Mac is one program with two faces. The app you click and the `roommac` command share every
scanner and every action, so a script and the window can never disagree about what would move.
Nothing is deleted outright: everything goes to the Trash, every action writes a receipt, and
`roommac restore` puts things back while they're still in the Trash.

## Install

`./build-app.sh --install` puts a `roommac` symlink in the first writable bin folder on the usual
PATH (`/usr/local/bin`, then Homebrew's `/opt/homebrew/bin`, then `~/.local/bin`) and installs the man
page beside it. If none is writable it prints the one `sudo ln -sf …` line to run. `which roommac`
shows where it landed. The command is just the app's own binary, so it works whenever the app is
installed:

```
/Applications/Room for Mac.app/Contents/MacOS/RoomMac
```

## Commands

### `roommac scan`

Shows what could be cleaned, card by card. Changes nothing.

```bash
roommac scan                          # every card
roommac scan --card caches --card logs
roommac scan --json | jq '.checkedBytes'
```

Cards: `caches` `logs` `installers` `dev` `claude` `duplicates` `leftovers` `unused` `backups` `big`.

Each item shows `[x]` when it is pre-checked (safe to move), `[ ]` when it's for you to decide,
and `🛡` when it's on the protected list and will never move.

### `roommac up`

Moves the pre-checked items of the chosen cards to the Trash and saves a receipt. You must say
which cards; there is no default.

```bash
roommac up --safe                     # caches, logs, installers, developer caches: the weekly-clean set
roommac up --safe --dry-run           # show the plan, move nothing
roommac up --card duplicates --yes    # a specific card, no question asked
roommac up --all-checked              # every pre-checked item in every card
```

In a terminal it lists the plan and asks `Continue? [y/N]`. From a script (no terminal) it refuses
with exit code 3 unless you pass `--yes`, so a cron job can't clean by accident. Items that are
not pre-checked in the app are never moved by `roommac up`, whatever flags you give it.

### `roommac speed`

The health verdict and the Speed cards. The exit code is the verdict: `0` green, `1` yellow,
`2` red, which makes it usable from monitoring.

```bash
roommac speed                         # verdict plus every quick card
roommac speed --card safety --card power
roommac speed --all                   # also the startup card, which asks System Events for login items
roommac speed --updates --app-updates --bench   # the slow ones: Apple, vendor feeds, disk test
roommac speed --json | jq '.findings'
```

Cards: `health` `now` `startup` `browsers` `wifi` `sync` `timemachine` `rosetta` `menubar`
`printers` `power` `sleep` `safety` `batteries` `defaults`, plus the slow `updates`
`app-updates` `bench`, which only run when asked.

### `roommac receipts` and `roommac restore`

```bash
roommac receipts                      # every session, newest first, with an id
roommac restore last                  # put the newest session back
roommac restore 3f9a                  # by id prefix
```

Restore works only while the items are still in the Trash. A session whose items are gone
reports them as "no longer in the Trash".

### `roommac trash`

```bash
roommac trash                         # size and count
roommac trash --empty --yes           # asks Finder to empty it; needs the Automation permission once
```

### `roommac disk`

The boot-volume map: physical disk, partition, APFS container, volumes, the sealed snapshot macOS
booted from. `--json` gives the tree with bytes and mount points.

### `roommac money`

The Money tab as text: the "is this Mac done" verdict, the battery decision, subscription apps
with their last-opened date, cloud-drive overlap, what a clean would free, and built-in
alternatives to paid apps.

```bash
roommac money
roommac money --speedtest --plan 300      # download test, compared with the speed on your bill
roommac money --json | jq '.subscriptions[] | select(.daysIdle > 60) | .vendor'
```

Room can't see what you pay. Every saving is phrased as "if you're paying for this".

### `roommac sort`

Files loose Desktop and Downloads files into typed folders (Screenshots, Images, Documents,
Installers, Archives, Videos, Music, Other) inside a `Sorted` folder in the same place. Files are
moved, not trashed, and the receipt puts them back exactly.

```bash
roommac sort --dry-run                    # both folders, files untouched for 7+ days
roommac sort --downloads --older-than 30 --yes
roommac restore last                      # undo
```

### `roommac report`

The monthly checkup as one page: health verdict, safety, what a clean would free, money findings,
and what was done in the last 30 days.

```bash
roommac report --open                     # ~/Desktop/Mac checkup <date>.html, opened in the browser
roommac report --md --out -               # Markdown to stdout
roommac report --out ~/Documents/checkup.html
```

### `roommac screenshots <dir>`

Renders every window with made-up sample data into PNGs. This is how the README images are made.

## JSON

`--json` works on every command. Sizes are always bytes, dates are ISO 8601, and booleans are
real booleans. Field names are stable within a major version.

```bash
roommac scan --json | jq '[.categories[] | {title, checkedBytes}]'
roommac speed --json --card safety | jq '.cards.safety[] | select(.ok == false) | .name'
roommac receipts --json | jq '.[0].id'
```

## Exit codes

| Code | Meaning |
|---|---|
| 0 | Success; for `speed`, a green verdict |
| 1 | `speed`: yellow verdict, a few things worth a look |
| 2 | `speed`: red verdict, something needs attention |
| 3 | Needs confirmation: run again with `--yes` |
| 64 | Usage error: unknown command, card, or missing argument |
| 70 | The command ran but failed (nothing could be moved, session not found, tool missing) |

## Permissions

The command runs as you, with the permissions of the terminal that launched it. macOS asks the
usual questions the first time: Downloads for the installers card, System Events for
`speed --card startup`, Finder for `trash --empty`. It never asks for an administrator password.
Where a task needs one (rebuilding the Spotlight index, thinning Time Machine snapshots) it
prints the command for you to run instead.

## Examples

Monthly report to share with whoever helps with the Mac:

```bash
0 9 1 * * "/Applications/Room for Mac.app/Contents/MacOS/RoomMac" report --out "$HOME/Desktop/Mac checkup.html"
```

Weekly cron that cleans the safe cards and logs what it did:

```bash
0 9 * * 1 "/Applications/Room for Mac.app/Contents/MacOS/RoomMac" up --safe --yes --json >> ~/clean.log 2>&1
```

Nagios-style check that fails when the Mac needs attention:

```bash
roommac speed --card health --card safety --json > /tmp/speed.json; code=$?
[ $code -eq 2 ] && mail -s "Mac needs attention" you@example.com < /tmp/speed.json
```

Find the biggest pre-checked item before cleaning:

```bash
roommac scan --json | jq -r '.categories[].items[] | select(.checked) | "\(.bytes) \(.name)"' | sort -rn | head -5
```
