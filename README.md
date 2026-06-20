# convofinance-platform

AI-powered competitive banking intelligence for the Jordanian banking sector — conversational analysis over verified data covering all 15 licensed commercial banks.

This repository is the handover package for the Data & AI team. It contains two things: the **working application** (copied verbatim from the live product) and a **clean, fully-seeded database with a typed data layer and full documentation** to deploy it on properly. `docs/INTEGRATION.md` is the bridge between the two.

---

## What this product does

A conversational interface ("like talking to an analyst, strictly about Jordanian banking") backed by a verified database. Users — bank leadership, regulators, advisory firms — ask questions and get answers grounded in real financial statements, rates, tariffs, products, governance, and real-estate data, rendered as text, tables, and charts.

## Stack

| Layer | Technology |
|---|---|
| Framework | Next.js (App Router, TypeScript) |
| Database | PostgreSQL (Supabase) |
| AI | Anthropic API (Claude) |
| Charts | Recharts |

## Repository map

```
convofinance-platform/
│
│  ── WORKING APPLICATION (live product, verbatim) ──
├── app/                Pages + API routes, incl. api/chat (AI engine), api/chart, api/cron
├── components/         UI components (theme, language, password gate, settings)
├── lib/                App libraries currently used by the app:
│                         queries.js, supabase.js, banks-config.ts, i18n.ts,
│                         LangContext.tsx, scrapers/
├── public/             Static assets — icons, wordmarks, SVGs, favicon
│
│  ── CLEAN FOUNDATION (deploy target) ──
├── db/                 Database as SQL — run in order:
│                         01_schema · 02_policies · 03_views · 04_seed (2,261 rows)
├── src/lib/            Clean, typed data layer (supabase.ts, queries.ts) — migration target
├── src/types/          Database types (database.ts)
├── docs/               ARCHITECTURE · SCHEMA · ONBOARDING · INTEGRATION
│
│  ── CONFIG ──
├── package.json, package-lock.json, tsconfig.json, next.config.ts,
│   eslint.config.mjs, postcss.config.mjs, .nvmrc
└── .env.example
```

## How to use this repo

1. **Stand up the database** — run the four files in `db/` in order against a Supabase project. See `docs/ONBOARDING.md`.
2. **Point the app at it** — the app currently targets the previous database's conventions. `docs/INTEGRATION.md` lists every change needed to wire it to the clean database (env key, `bank_id`, one renamed view, the currency fix, and swapping to `src/lib`).
3. **Run** — `npm install && npm run dev`, then `npm run build` to verify.

## Documentation

| Doc | Purpose |
|---|---|
| `docs/ARCHITECTURE.md` | System overview, data flow, security model, currency handling |
| `docs/SCHEMA.md` | Every table, column, and view |
| `docs/ONBOARDING.md` | Stand the database up from zero |
| `docs/INTEGRATION.md` | Wire the existing app to the clean database |

## Conventions

- Monetary figures are in **thousands** of their reporting currency, except `bank_real_estate.price_jod` (absolute JOD).
- Arab Bank reports in **USD**; all others in **JOD** (`bank_financials.currency`). JOD normalization lives in the reporting views (the `_jod` columns), not in application code.
- Reads use the publishable key (read-only under RLS); writes require the service-role key.

## Note on the two layers

The application files are the verbatim live product and were not modified for this package; they run against the old database as-is. The `db/`, `src/`, and `docs/` directories are the clean, verified deploy target. `INTEGRATION.md` connects them. Once the team completes that wiring, the old `lib/queries.js` and `lib/supabase.js` can be removed in favor of `src/lib/`.
