# Integration Guide — pointing the existing UI at the clean database

If you keep the existing front-end and connect it to this clean database (instead of the old one), this is the complete list of changes. The data-access layer (`src/lib/`) is already written for you — most of the work is wiring the UI to it.

## 1. Environment variable

| Old | New |
|---|---|
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` |

The new project uses Supabase's current key format (`sb_publishable_…`). Update `.env` and any references. The service-role and Anthropic keys are unchanged.

## 2. Use the provided data layer

Replace the old `lib/queries.js` and `lib/supabase.js` with `src/lib/queries.ts` and `src/lib/supabase.ts`. The function names are preserved, so call sites mostly stay the same:

`getBanks`, `getSectorRankings`, `getLatestRates`, `getHomeLoanComparison`, `getAnnouncements`, `getLatestFinancials`, `getYoYGrowth`, `getTariffs`

New functions are also available for data the old UI didn't surface:

`getBank`, `getFinancialsForBank`, `getProducts`, `getBoardMembers`, `getExecutives`, `getOwnership`, `getRealEstate`, `getStockData`

## 3. banks primary key: `id` → `bank_id`

The `banks` table is keyed on **`bank_id`**, not `id`. Anywhere the UI reads a bank's identifier from the registry, use `bank_id`. The `/bank/[id]` route segment can stay as-is — just treat its value as a `bank_id` when querying. (Child tables already used `bank_id`, so those are unchanged.)

## 4. One view was renamed

| Old view | New view |
|---|---|
| `v_latest_financials` | `v_bank_latest_financials` |

All other view names are unchanged: `v_sector_rankings`, `v_latest_rates`, `v_home_loan_comparison`, `v_announcements_feed`, `v_yoy_growth`. (The provided `getLatestFinancials()` already points at the new name.)

## 5. Currency — use the `_jod` columns, remove the in-code conversion

This is the most important change. The old app converted Arab Bank's USD figures to JOD **in application code** (× ~0.71). **Stop doing that.** The views now expose canonical, already-converted columns:

`total_assets_jod`, `customer_deposits_jod`, `net_loans_jod`, `net_profit_jod`

Use these for any cross-bank ranking, chart, or aggregate. Keep the native columns (`total_assets`, etc.) only where you intentionally want a bank's figure in its own reported currency. **Double-converting will produce wrong numbers** — so remove the old conversion logic entirely.

## 6. New data you can now surface

The clean database carries data the old UI didn't show — query functions are ready in `src/lib/queries.ts`:

| Data | Rows | Function |
|---|---|---|
| Products | 550 | `getProducts()` |
| Board members | 164 | `getBoardMembers(bankId)` |
| Executives | 201 | `getExecutives(bankId)` |
| Ownership | 97 | `getOwnership(bankId)` |
| Real estate | 1,061 | `getRealEstate(bankId?)` |
| Stock data | 13 | `getStockData()` |

## 7. Verification checklist

After wiring up:

- [ ] Rankings page: **Arab Bank ranks #1 by assets** (its USD correctly converted to JOD). If not, the `_jod` columns aren't being used.
- [ ] Bank links resolve correctly (using `bank_id`).
- [ ] News, rates, tariffs, and financials pages render with data.
- [ ] `npm run build` passes (final integration check on your platform).

---

That's the full delta. The complete column lists are in [`SCHEMA.md`](./SCHEMA.md); the single integration point is `src/lib/queries.ts`.
