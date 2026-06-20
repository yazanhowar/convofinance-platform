# Database Schema Reference

14 tables, 2,261 rows, covering all 15 licensed Jordanian commercial banks. `banks` is the single source of truth; every other table references it via `bank_id` (foreign key, `ON DELETE CASCADE`). The authoritative, complete column list for each table is in [`db/01_schema.sql`](../db/01_schema.sql) — this document explains purpose, keys, and the columns that matter most.

## Conventions

- **Identity:** every table has an auto-generated primary key. `banks` is keyed on `bank_id`; all child tables use `id` plus a `bank_id` foreign key.
- **Money:** all monetary values are in **thousands** of the reporting currency, except `bank_real_estate.price_jod`, which is absolute JOD.
- **Currency:** `bank_financials.currency` is `'JOD'` for every bank except Arab Bank (`'USD'`). JOD normalization is applied in the reporting views, not in stored data. Peg: 1 USD = 0.709 JOD.
- **Timestamps:** `created_at` / `updated_at` on every table.
- **Security:** RLS enabled on all tables, public-read policy each; writes require the service-role key.

---

## Tables

### `banks` — registry (15 rows, all banks)
Key columns: `bank_id` (PK), `name_en`, `name_ar`, `short_name`, `short_name_ar`, `slug`, `bank_type`, `website_url`, `ir_url`, `established_year`, `listed_on_ase`, `ticker`, `swift_code`, `headquarters`, `is_active`.

### `bank_financials` — annual statements (45 rows, all 15 banks, FY2023–2025)
One row per bank per fiscal year. Balance sheet & P&L in thousands: `total_assets`, `net_loans`, `customer_deposits`, `shareholders_equity`, `total_equity`, `paid_up_capital`, `net_interest_income`, `net_fee_income`, `total_income`, `operating_expenses`, `provision_expense`, `net_profit`. Per-share & ratios: `eps_fils`, `book_value_per_share`, `dividends_cash_pct`, `dividends_bonus_pct`, `roe`, `roa`, `car`, `npl_ratio`, `npl_coverage`, `loan_to_deposit`, `cost_to_income`, `net_interest_margin`. Operations: `employee_count`, `branch_count`. Provenance: `report_url`, `source_type`, `currency`.

### `bank_rates` — published rates (15 rows, all banks)
Lending: `home_loan_min/max`, `personal_loan_min/max`, `car_loan_min/max`, `corporate_loan_min/max`, `sme_loan_min/max`, `credit_card_rate`, `overdraft_rate`. Deposits: `saving_rate`, `current_rate`, term deposits `td_1m … td_36m` and `td_usd_3m/6m/12m`. Islamic: `murabaha_rate_min/max`, `wakala_rate`, `mudaraba_rate`.

### `bank_tariffs` — fees & charges (15 rows, all banks)
Transfer fees, account fees, and card fees by tier, dated by `effective_date`. See `01_schema.sql` for the full fee list (~30 columns).

### `bank_announcements` — news feed (44 rows, all banks)
`announcement_date`, `category`, `headline_en`, `headline_ar`, `summary_en`, `summary_ar`, `tags` (text[]), `is_verified`, `source_url`.

### `bank_products` — product catalog (550 rows, all banks)
`category`, `sub_category`, `product_name_en`, `product_name_ar`, `min_amount`, `max_amount`, `min_tenor_months`, `max_tenor_months`, `currency`, `is_islamic`, `sharia_structure`, `target_segment`, `is_active`.

### `bank_board_members` (164 rows) · `bank_executives` (201 rows) · `bank_ownership` (97 rows) — governance, all banks
Board/executive identity (`full_name_en/ar`, `role`/`title_en/ar`, `committee`, `department`) and ownership (`shareholder_name_en/ar`, `shareholder_type`, `ownership_pct`, `country`).

### `bank_real_estate` — property listings (1,061 rows, 5 banks)
Bank-owned / repossessed real estate; only some banks publish these. `property_type`, `location`, `price_jod` (absolute JOD), `area_sqm`, `description_en/ar`, `listing_url`.

### `bank_stock_data` — market data (13 rows, 13 banks)
ASE figures. Two banks have no row by design — IIAB (wholly-owned Arab Bank subsidiary, unlisted) and Invest Bank (no share price post Etihad merger). `ticker`, `price`, `day_high`, `day_low`, `change_pct`, `volume`, `market_cap`, `price_date`.

### `annual_reports` (16 rows) · `data_sources` (25 rows) — all banks
Report links (`pdf_url`, `auditor`, `published_date`) and per-bank data provenance (`source_type`, `url`, `last_verified`).

### `cbj_policy_rates` — central bank rates (0 rows)
Central Bank of Jordan policy rates. **Not bank-specific** (no `bank_id`). Ships empty for the team to populate.

---

## Reporting views

All views are `security_invoker` and granted to `anon` / `authenticated`. Currency normalization lives here.

| View | Purpose |
|---|---|
| `v_bank_latest_financials` | Latest fiscal year per bank, native + JOD-normalized figures |
| `v_sector_rankings` | League table ranked on JOD-normalized assets / deposits / profit |
| `v_latest_rates` | Latest rate row per bank |
| `v_home_loan_comparison` | Banks ordered by cheapest home-loan minimum rate |
| `v_announcements_feed` | Announcements newest-first with bank identity |
| `v_yoy_growth` | Year-over-year growth per bank (JOD-normalized) |

The `*_jod` columns are `value * (case when currency='USD' then 0.709 else 1 end)`, giving a single comparison-safe figure across all banks.
