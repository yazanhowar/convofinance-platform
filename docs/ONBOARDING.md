# Onboarding

How to stand up convofinance-platform from scratch on your own infrastructure.

## Prerequisites

- Node.js 18+ and npm
- A Supabase project (or any PostgreSQL 15+ instance)
- An Anthropic API key

## 1. Database

In your Supabase project's SQL editor, run the files **in order**:

1. `db/01_schema.sql` — creates the 14 tables, keys, foreign keys, and indexes.
2. `db/02_policies.sql` — enables Row Level Security and the public-read policies.
3. `db/03_views.sql` — creates the 6 reporting views.
4. `db/04_seed.sql` — loads all 2,261 rows.

`01` will prompt about creating tables without RLS — that's expected; `02` enables it explicitly straight after. The seed inserts `banks` with original IDs preserved (so every foreign key resolves) and resets the identity sequence.

After loading, sanity-check:

```sql
select count(*) from banks;               -- 15
select * from v_sector_rankings limit 5;  -- Arab Bank ranked #1 (USD to JOD applied)
```

## 2. Environment

```bash
cp .env.example .env.local
```

Fill in the Supabase URL + publishable key (Project Settings → API Keys), the service-role key (server-side only), and your Anthropic key.

## 3. Types (recommended)

```bash
export SUPABASE_PROJECT_REF=<your-project-ref>
npm run types
```

## 4. Run

```bash
npm install
npm run dev
```

## 5. Deploy

Standard Next.js app — deploy to your platform of choice with the same four environment variables. The publishable key is safe in the browser bundle; the service-role and Anthropic keys must stay server-side.

## Notes for the team

- **Currency:** stored figures are faithful to each bank's published statements (Arab Bank in USD, others in JOD). Use the `*_jod` columns from the views for any cross-bank comparison. To change the peg, edit the constant in `db/03_views.sql`.
- **Partial coverage by design:** `bank_real_estate` covers 5 banks (only some publish listings); `bank_stock_data` covers 13 (two banks are unlisted). `cbj_policy_rates` ships empty to populate.
- **Writes** use the service-role key server-side; RLS denies writes via the publishable key.
