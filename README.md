# gta6-clipper-01

[![make.fun · gta6-clipper-01](https://make.fun/badge/gta6-clipper-01.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![rank](https://make.fun/badge/gta6-clipper-01/Agusgarut/gta6-clipper-01/rank.svg)](https://make.fun/bounty/gta6-clipper-01/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![reward](https://make.fun/badge/gta6-clipper-01/Agusgarut/gta6-clipper-01/reward.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)

**IShowSpeed Found a RED HULK in GTA 6 😱 (Secret Side Mission)** — a 30-second
vertical clip for the make.fun bounty
[gta6-clipper-01](https://make.fun/bounty/gta6-clipper-01), ranked purely by
its YouTube views (top 20 share $500).

📺 **Watch it:** https://www.youtube.com/shorts/MbPaHHbkrK8

## The clip

The moment is the "RED HULK" side-mission encounter from IShowSpeed's GTA 6
launch stream (19 Nov 2026, the day the game released) — the moment Kotaku's
launch liveblog singled out. A giant red-skinned brute is found slumped at a
rural shed; Jason talks him down, gets pulled into a bear hug, and then the
brute stands to his full height, leaps off the shed wall and launches Jason
ragdolling through the air. One continuous moment, no montage: sympathy
flipped into shock inside 24 seconds.

The uploaded cut (v2) stacks Speed's facecam in a panel on top with the
gameplay below, opens on the moment itself with the hook text
"HE FOUND A RED HULK IN GTA 6?!", beats "HE JUST WANTED A HUG" and
"THEN HE STOOD UP..." over the hug and the stand-up, leaves the launch
payoff text-free, and closes with a 6.5-second end-card carrying make.fun's
pitch ("MAKE CLIPS LIKE THIS WITH AI AND EARN MONEY ON MAKE.FUN" +
make.fun/bounty/gta6-clipper-01). The video's description carries the
bounty's line word for word and the account's play code
(`makefun-buckle-daisy-valley`). Title and tags are in `title.txt`, the
exact description in `description.txt`.

## How it was made

An AI agent made the whole clip inside its recorded sessions: it fetched
the play code, chose the moment from the launch-stream footage and said
why it would hold a viewer, wrote the creative (hook, beat text, pitch
wording) before cutting, then trimmed, cropped and rendered the file with
ffmpeg — and, after Agus asked for the streamer's facecam, re-rendered it
in the stacked layout. Agus uploaded the finished file to his own YouTube
channel as a public Short. The exact ffmpeg commands are in `build.sh`
(v1) and `build_v2.sh` (the facecam version that was uploaded).

## Run it

```sh
mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts
```

`main.ts` (Node 22, standard library only) copies `VIDEO.json` to the
output directory, where the grader reads the video's address. That is
all the program has to do — the house reads the video itself through the
YouTube Data API.

---

<sub>Entered on [make.fun](https://make.fun/?ref=ctn5sjdw&utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01) · AI agents build software for cash rewards</sub>
