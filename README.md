# convofinance-platform

AI-powered competitive banking intelligence for the Jordanian banking sector — conversational analysis over verified data covering all 15 licensed commercial banks.

This repository is a clean, self-contained handover package for the Data & AI team. It contains the full database schema, the migrated data, the application code, and the documentation needed to stand the product up from scratch and deploy it.

---

## What this product does

A conversational interface ("like talking to an analyst, strictly about Jordanian banking") backed by a verified database. Users — bank leadership, regulators, advisory firms — can ask questions and get answers grounded in real financial statements, rates, tariffs, products, governance, and real-estate data, rendered as text, tables, and charts.

## Stack

| Layer | Technology |
|---|---|
| Framework | Next.js (App Router, TypeScript) |
| Database | PostgreSQL (Supabase) |
| AI | Anthropic API (Claude) |
| Charts | Recharts |
| Hosting | Any Node host / Vercel |

## Repository layout

```
convofinance-platform/
├── README.md
├── docs/
│   ├── ARCHITECTURE.md     ← system overview + data flow
│   ├── SCHEMA.md           ← full database reference
│   └── ONBOARDING.md       ← stand-it-up-from-zero guide
├── db/
│   ├── 01_schema.sql       ← 14 tables, keys, foreign keys, types
│   ├── 02_policies.sql     ← Row Level Security + public-read policies
│   ├── 03_views.sql        ← 6 reporting views (incl. JOD normalization)
│   └── 04_seed.sql         ← all 2,261 rows
├── src/
│   ├── app/                ← pages + API routes
│   ├── components/         ← UI components
│   ├── lib/                ← typed Supabase client + query layer
│   └── types/              ← database types
└── .env.example
```

## Quick start

1. Create a Supabase project and run the SQL files in order: `01_schema` → `02_policies` → `03_views` → `04_seed`.
2. Copy `.env.example` to `.env.local` and fill in the keys.
3. `npm install && npm run dev`.

Full setup is in `docs/ONBOARDING.md`.

## Database at a glance

14 tables, 2,261 rows, all 15 banks. Financials, rates, tariffs, announcements, products, governance (board, executives, ownership), real estate, stock data, annual reports, and data-source provenance. See `docs/SCHEMA.md`.

## Conventions

- Monetary figures are stored in **thousands** of their reporting currency, except `bank_real_estate.price_jod` (absolute JOD).
- Arab Bank reports in **USD**; every other bank reports in **JOD** (`bank_financials.currency`). Currency normalization to JOD lives in the reporting views, not in application code.
- Reads are public (publishable key); writes require the service-role key.
