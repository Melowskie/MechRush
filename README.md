# MechRush

A Subway Surfer style quiz runner with an online leaderboard (Supabase) that you can host free on GitHub Pages.

## Files

```
index.html     the page
style.css      the look
script.js      the game, the questions and the leaderboard code
supabase.sql   the database setup (run once in Supabase)
README.md      this file
```

## Setup

### 1. Create the Supabase project (free)

1. Go to supabase.com, sign in, and choose New project. Pick any name and region and set a database password.
2. Wait for the project to finish setting up.

### 2. Create the leaderboard table

1. In Supabase, open SQL Editor, then New query.
2. Paste the whole content of `supabase.sql` and press Run.
3. Open Table Editor and check that a `leaderboard` table exists.

### 3. Add your keys to the game

1. In Supabase, open Project Settings, then API.
2. Copy the Project URL and the `anon` `public` key.
3. Open `script.js` and edit the two lines at the very top:

```js
const SUPABASE_URL="https://YOUR-PROJECT-ID.supabase.co";
const SUPABASE_ANON_KEY="YOUR-ANON-KEY";
```

Until you replace both values, the game still works and simply hides the leaderboard and nickname box.

### 4. Publish on GitHub Pages

1. On github.com, create a new public repository (for example `mechrush`).
2. Upload `index.html`, `style.css`, `script.js` and `README.md` (you do not need to upload `supabase.sql`).
3. Open Settings, then Pages. Under Build and deployment choose Deploy from a branch, select `main` and `/ (root)`, and save.
4. After a minute your game is live at `https://YOUR-USERNAME.github.io/mechrush/`.

### 5. Test it

1. Open the link, enter a nickname on the menu, and play a run to the end.
2. You should see "Score saved to the leaderboard." on the end screen.
3. Press Leaderboard on the menu to see the top 10.

## How it behaves

- **Nickname:** 2 to 20 characters, saved in your browser (`localStorage`). It is required to start a scored run.
- **One score per finished run:** the score is sent once when a run ends. Pressing Play again starts a new run, and only that run's score is sent. If sending fails, a Retry button resends the same score without creating duplicates.
- **Not saved:** Study mode runs and runs with a score of 0.
- **States:** the leaderboard shows Loading, an error message with a Refresh button, or "No scores yet" when empty.
- **Double tap a lane** (or press Enter) to lock in your answer right away.

## Editing questions

In `script.js`, edit `SEC` (section names) and `D` (the questions). Each question looks like this:

```js
{"t":"PIPE","s":"Set 3","q":"Question","o":["A text","B text","C text","D text"],"a":1,"e":"Explanation"}
```

`t` is the section, `s` is the set, and `a` is the right choice (0 = A, 1 = B, 2 = C, 3 = D). A new `s` value creates a new set button on the menu.

## Security notes

- The anon key is meant to be public. Row Level Security only allows people to read scores and add valid scores. Nobody can edit or delete rows from the website.
- A determined person can still send a fake score straight to your database, because the game runs in their browser. The score limit (0 to 25000) and name checks reduce abuse but cannot stop it. Remove bad rows in Supabase, Table Editor.
- Supabase free projects pause after about a week without activity. Open the dashboard and press Restore if the leaderboard stops loading.

## Troubleshooting

- "Could not load the leaderboard": check the URL and anon key in `script.js`, and that you ran `supabase.sql`.
- Scores do not save: the name must be 2 to 20 characters with no `<` or `>`, and the score must be between 0 and 25000.
- Changes do not show on GitHub Pages: wait a minute and hard refresh the page.
