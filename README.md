# Tour Radar

An early-warning monitor for venues that book political and civic creators. It watches what creators say and publish themselves for signs that they are heading into a promo cycle — a book deal, a documentary, a campaign, a tour — and tells you when and how to pitch them.

## What it reads

| Source | What it looks for |
|---|---|
| YouTube transcripts | Passages in a creator's recent videos where they talk about their book, tour, tickets or an announcement |
| YouTube titles and descriptions | Announcement titles, and pre-order or ticket links in the description |
| The creator's own website | Ticket and bookseller links, announcement headings, their feed, and booking or press contacts |
| Press-release wires | PR Newswire's dated archive (books back about a year, music and tours about nine months), an archive search for each tracked creator, and the newest releases on every scan; plus PRWeb's daily feed |
| Bookstore listings | Apple Books listings under the creator's name, including pre-orders with their on-sale dates, from every publisher |
| Book catalog and trade press | Open Library listings and Publishers Weekly |
| Google News | Press coverage. Google refuses requests from Cloudflare, so this only runs when the app is run elsewhere, such as on your own computer |

Each tracked creator sits in one of five stages, earliest first: **Whisper → Deal announced → Dated / pre-order → Tour announced → On the road**. Open a creator to see the source headlines, what to do at that stage, contact-finder searches and a pitch email drafted from your venue's details.

It runs on Cloudflare's free plan: one Worker, one D1 database, one scheduled trigger.

## Get your own copy

Your own copy keeps your own watchlist, notes and venue details. Pick one of the two routes. Both need a free [Cloudflare account](https://dash.cloudflare.com/sign-up).

### Option 1 — One-click deploy

[![Deploy to Cloudflare](https://deploy.workers.cloudflare.com/button)](https://deploy.workers.cloudflare.com/?url=https://github.com/Brittybrit/tour-radar)

Cloudflare copies this repository into your GitHub account, creates the database, asks for the settings below and deploys. When it finishes you get an address ending in `workers.dev`.

### Option 2 — Ask Claude to set it up

Open [Claude Code](https://claude.com/claude-code) (desktop app or terminal) and paste this:

```text
Set up my own copy of Tour Radar from https://github.com/Brittybrit/tour-radar.

1. Clone the repository and read README.md, wrangler.jsonc and src/worker.js.
2. Run it locally first so I can see it working: npm install, copy .dev.vars.example to
   .dev.vars and generate a RADAR_PASSWORD for local use, then npm run dev.
3. Then help me put it online on Cloudflare with wrangler. Tell me each step I have to do
   myself (creating the account, signing in, choosing the password) and wait for me.
   Set RADAR_PASSWORD as a secret; never ask me to paste secrets in chat.
4. Ask whether I want the optional AI headline check. If I do, tell me how to create an
   Anthropic API key and have me add it myself as the ANTHROPIC_API_KEY secret.
5. When it is live, have me open "Club details" and enter my venue's name and city.
```

## Settings

| Setting | Required | What it does |
|---|---|---|
| `RADAR_PASSWORD` | Yes | The shared sign-in password. Until it is set, the site shows a locked setup page. |
| `ANTHROPIC_API_KEY` | No | Turns on the AI check: Claude reads each new headline and rejects ones that are about someone else. Billed to your own Anthropic account by usage. |
| `RADAR_MODEL` | No | Model for the AI check. Defaults to `claude-haiku-5-5`, which costs pennies per scan; `claude-opus-5-5` is more careful and costs more. |

To change one later: Cloudflare dashboard → your Worker → **Settings → Variables and Secrets**.

## Run it on your own computer

```bash
npm install
cp .dev.vars.example .dev.vars   # then put a password after RADAR_PASSWORD=
npm run dev
```

Then open http://localhost:8787.

## Deploy from the command line

```bash
npx wrangler login
npx wrangler deploy
npx wrangler secret put RADAR_PASSWORD
```

## First steps once it is running

1. Open **Club details** and enter the venue's name, city and capacity. Pitch drafts use these, and headlines mentioning your city get flagged.
2. Edit the watchlist: **+ Track a creator** to add, or open a creator and choose **Stop tracking**. Give each creator a YouTube handle and website so there is something to read.
3. Open **Appearance**, enter the club's website and press **Match colors** to restyle the dashboard in the club's own colors, in a light or dark version.
4. Press **Scan now**. Check **Needs your eyes** for headlines the scanner was unsure about, and the **Discovery** tab for people not yet on your list.

## How scanning works

A scan checks one creator at a time, because Cloudflare's free plan allows only a little work per request. While the dashboard is open, the page drives the scan and shows progress. When it is closed, a trigger runs every 2 minutes: it starts a fresh scan once the last one is 12 hours old and does one step each time. A step is one creator, one website or one video transcript, so a background scan of 30 creators takes a few hours.

## Limits

- Matching is by keyword, so some signals are wrong, and transcript passages in particular need a second look. Dismiss them, or turn on the AI check, which reads each one.
- Transcripts come from an unofficial YouTube route that could stop working. Only each creator's three newest videos from the last three weeks are read.
- Press wires are read back through PR Newswire's archive once, then kept current. Few political creators are announced on wires, so expect this source to be quiet most of the time.
- Some websites refuse automated visits; those show as source errors in the header.
- The earliest signals (agency signings, deal announcements) depend on trade press picking them up. Paid deal trackers such as Publishers Marketplace are not connected.
- It does not read actual tour routing, so it cannot tell you a tour passes near your city.

An earlier Python version, for hosts that keep a server running, is the first commit in this repository's history.
