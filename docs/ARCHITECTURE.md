# Architecture

## Overview

convofinance-platform is a Next.js application backed by a PostgreSQL (Supabase) database and the Anthropic API. It serves a conversational analysis experience over a curated dataset of Jordanian banking information.

## Request flows

**Read paths (dashboards, rankings, rates, news, products, real estate):**
The browser-side code reads through the typed query layer (`src/lib/queries.ts`) using the Supabase **publishable** key. Most reads go through the reporting **views**, which already join bank identity and apply JOD normalization, so the UI never has to compute currency conversion or rankings itself.

**Conversational analysis (`/api/chat`):**
The chat route runs server-side. It composes a system prompt scoped to Jordanian banking, queries the database for the relevant context using the **service-role** key, and calls the Anthropic API. Responses stream back to the client and may include chart/table directives that the UI renders with Recharts.

**Scheduled ingestion (`/api/cron/...`):**
A cron route refreshes the announcements feed on a schedule. It writes with the service-role key.

## Data layer

- `src/lib/supabase.ts` — two clients: a public client (publishable key, browser-safe) and a server-only admin client (service-role key).
- `src/lib/queries.ts` — a thin, typed function per read. Each returns rows from a table or view; business logic lives in the SQL views, not here.
- `src/types/database.ts` — TypeScript types describing every table and view.

## Security model

Row Level Security is enabled on all 14 tables. Each table has a single public-read policy (`using (true)`), so the publishable key can read but cannot write. All writes — seeding, the cron ingestion, any admin mutation — use the service-role key on the server and bypass RLS. The reporting views are defined `security_invoker`, so they respect the underlying table policies and pass Supabase's security advisor.

## Currency handling

The Jordanian dinar is pegged to the US dollar at 1 USD = 0.709 JOD. Arab Bank publishes its statements in USD; all other banks publish in JOD. Rather than scatter conversion logic through the application, the figures are stored exactly as each bank reports them (with `bank_financials.currency` flagging the unit), and the reporting views expose canonical `*_jod` columns. This keeps the stored data faithful to published statements (important for auditors and regulators) while every cross-bank ranking and aggregate is correct by default.

## Deployment

The application is a standard Next.js app and runs on any Node host. The team supplies its own environment (database URL, publishable key, service-role key, Anthropic API key) and deploys to its chosen platform. See `docs/ONBOARDING.md`.
