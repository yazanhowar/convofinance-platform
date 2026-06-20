-- =====================================================================
-- convofinance-platform  ·  01_schema.sql
-- Clean base schema: 14 tables for Jordanian banking intelligence.
-- banks is keyed on bank_id; every child table references it via bank_id
-- (foreign key, ON DELETE CASCADE). Monetary values are in THOUSANDS of the
-- reporting currency, except bank_real_estate.price_jod (absolute JOD).
-- Run order: 01_schema.sql -> 02_policies.sql -> 03_views.sql -> 04_seed.sql
-- =====================================================================

CREATE TABLE banks (
  bank_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  slug TEXT,
  name_en TEXT,
  name_ar TEXT,
  short_name TEXT,
  bank_type TEXT,
  website_url TEXT,
  ir_url TEXT,
  established_year INTEGER,
  listed_on_ase BOOLEAN,
  ticker TEXT,
  swift_code TEXT,
  headquarters TEXT,
  is_active BOOLEAN,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  short_name_ar TEXT
);

CREATE TABLE annual_reports (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  bank_id INTEGER NOT NULL REFERENCES banks(bank_id) ON DELETE CASCADE,
  fiscal_year INTEGER,
  language TEXT,
  pdf_url TEXT,
  pdf_url_ar TEXT,
  page_count INTEGER,
  file_size_kb INTEGER,
  is_audited BOOLEAN,
  auditor TEXT,
  published_date DATE,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE bank_announcements (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  bank_id INTEGER NOT NULL REFERENCES banks(bank_id) ON DELETE CASCADE,
  announcement_date DATE,
  category TEXT,
  headline_en TEXT,
  headline_ar TEXT,
  summary_en TEXT,
  source_url TEXT,
  source_type TEXT,
  fiscal_year INTEGER,
  is_verified BOOLEAN,
  tags TEXT[],
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  summary_ar TEXT
);

CREATE TABLE bank_board_members (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  bank_id INTEGER NOT NULL REFERENCES banks(bank_id) ON DELETE CASCADE,
  fiscal_year INTEGER,
  full_name_en TEXT,
  full_name_ar TEXT,
  role TEXT,
  is_independent BOOLEAN,
  committee TEXT,
  nationality TEXT,
  notes TEXT,
  source_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE bank_executives (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  bank_id INTEGER NOT NULL REFERENCES banks(bank_id) ON DELETE CASCADE,
  fiscal_year INTEGER,
  full_name_en TEXT,
  full_name_ar TEXT,
  title_en TEXT,
  title_ar TEXT,
  department TEXT,
  source_url TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE bank_financials (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  bank_id INTEGER NOT NULL REFERENCES banks(bank_id) ON DELETE CASCADE,
  fiscal_year INTEGER,
  total_assets BIGINT,
  net_loans BIGINT,
  customer_deposits BIGINT,
  shareholders_equity BIGINT,
  total_equity BIGINT,
  paid_up_capital BIGINT,
  net_interest_income BIGINT,
  net_fee_income BIGINT,
  total_income BIGINT,
  operating_expenses BIGINT,
  provision_expense BIGINT,
  net_profit BIGINT,
  eps_fils NUMERIC,
  book_value_per_share NUMERIC,
  dividends_cash_pct NUMERIC,
  dividends_bonus_pct NUMERIC,
  roe NUMERIC,
  roa NUMERIC,
  car NUMERIC,
  npl_ratio NUMERIC,
  npl_coverage NUMERIC,
  loan_to_deposit NUMERIC,
  cost_to_income NUMERIC,
  net_interest_margin NUMERIC,
  employee_count INTEGER,
  branch_count INTEGER,
  report_url TEXT,
  source_type TEXT,
  currency TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE bank_ownership (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  bank_id INTEGER NOT NULL REFERENCES banks(bank_id) ON DELETE CASCADE,
  fiscal_year INTEGER,
  shareholder_name_en TEXT,
  shareholder_name_ar TEXT,
  shareholder_type TEXT,
  ownership_pct NUMERIC,
  country TEXT,
  source_url TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE bank_products (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  bank_id INTEGER NOT NULL REFERENCES banks(bank_id) ON DELETE CASCADE,
  category TEXT,
  sub_category TEXT,
  product_name_en TEXT,
  product_name_ar TEXT,
  description_en TEXT,
  min_amount NUMERIC,
  max_amount NUMERIC,
  min_tenor_months INTEGER,
  max_tenor_months INTEGER,
  currency TEXT,
  is_islamic BOOLEAN,
  sharia_structure TEXT,
  target_segment TEXT,
  is_active BOOLEAN,
  source_url TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  description_ar TEXT
);

CREATE TABLE bank_rates (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  bank_id INTEGER NOT NULL REFERENCES banks(bank_id) ON DELETE CASCADE,
  effective_date DATE,
  home_loan_min NUMERIC,
  home_loan_max NUMERIC,
  personal_loan_min NUMERIC,
  personal_loan_max NUMERIC,
  car_loan_min NUMERIC,
  car_loan_max NUMERIC,
  credit_card_rate NUMERIC,
  corporate_loan_min NUMERIC,
  corporate_loan_max NUMERIC,
  sme_loan_min NUMERIC,
  sme_loan_max NUMERIC,
  overdraft_rate NUMERIC,
  saving_rate NUMERIC,
  current_rate NUMERIC,
  td_1m NUMERIC,
  td_3m NUMERIC,
  td_6m NUMERIC,
  td_12m NUMERIC,
  td_24m NUMERIC,
  td_36m NUMERIC,
  td_usd_3m NUMERIC,
  td_usd_6m NUMERIC,
  td_usd_12m NUMERIC,
  murabaha_rate_min NUMERIC,
  murabaha_rate_max NUMERIC,
  wakala_rate NUMERIC,
  mudaraba_rate NUMERIC,
  currency TEXT,
  rate_type TEXT,
  source_url TEXT,
  raw_notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE bank_real_estate (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  bank_id INTEGER NOT NULL REFERENCES banks(bank_id) ON DELETE CASCADE,
  property_type TEXT,
  location TEXT,
  price_jod BIGINT,
  area_sqm NUMERIC,
  description_en TEXT,
  description_ar TEXT,
  listing_url TEXT,
  source_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE bank_stock_data (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  bank_id INTEGER NOT NULL REFERENCES banks(bank_id) ON DELETE CASCADE,
  ticker TEXT,
  price NUMERIC,
  day_high NUMERIC,
  day_low NUMERIC,
  change_pct NUMERIC,
  volume BIGINT,
  market_cap NUMERIC,
  price_date DATE,
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE bank_tariffs (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  bank_id INTEGER NOT NULL REFERENCES banks(bank_id) ON DELETE CASCADE,
  effective_date DATE,
  local_transfer_fee NUMERIC,
  local_transfer_fee_type TEXT,
  swift_transfer_fee_jod NUMERIC,
  swift_transfer_fee_pct NUMERIC,
  swift_transfer_min NUMERIC,
  swift_transfer_max NUMERIC,
  account_maintenance_fee NUMERIC,
  statement_fee NUMERIC,
  cheque_book_fee NUMERIC,
  stop_payment_fee NUMERIC,
  dormant_account_fee NUMERIC,
  debit_card_annual_fee NUMERIC,
  credit_card_annual_fee_classic NUMERIC,
  credit_card_annual_fee_gold NUMERIC,
  credit_card_annual_fee_platinum NUMERIC,
  cash_advance_fee_pct NUMERIC,
  late_payment_fee NUMERIC,
  loan_origination_fee_pct NUMERIC,
  early_settlement_fee_pct NUMERIC,
  safe_box_small_annual NUMERIC,
  safe_box_medium_annual NUMERIC,
  safe_box_large_annual NUMERIC,
  atm_withdrawal_own_free BOOLEAN,
  atm_withdrawal_other_fee NUMERIC,
  internet_banking_fee NUMERIC,
  currency TEXT,
  source_url TEXT,
  raw_notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE cbj_policy_rates (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  effective_date DATE,
  overnight_deposit_rate NUMERIC,
  overnight_lending_rate NUMERIC,
  repo_rate NUMERIC,
  reserve_requirement_pct NUMERIC,
  source_url TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE data_sources (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  bank_id INTEGER NOT NULL REFERENCES banks(bank_id) ON DELETE CASCADE,
  source_type TEXT,
  url TEXT,
  label TEXT,
  language TEXT,
  is_active BOOLEAN,
  last_verified DATE,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ---------------------------------------------------------------------
-- Recommended indexes (foreign keys + common query columns)
-- ---------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_financials_bank   ON bank_financials    (bank_id);
CREATE INDEX IF NOT EXISTS idx_financials_year   ON bank_financials    (fiscal_year);
CREATE INDEX IF NOT EXISTS idx_rates_bank        ON bank_rates         (bank_id);
CREATE INDEX IF NOT EXISTS idx_rates_effective   ON bank_rates         (effective_date);
CREATE INDEX IF NOT EXISTS idx_tariffs_bank      ON bank_tariffs       (bank_id);
CREATE INDEX IF NOT EXISTS idx_announce_bank     ON bank_announcements (bank_id);
CREATE INDEX IF NOT EXISTS idx_announce_date     ON bank_announcements (announcement_date DESC);
CREATE INDEX IF NOT EXISTS idx_board_bank        ON bank_board_members (bank_id);
CREATE INDEX IF NOT EXISTS idx_exec_bank         ON bank_executives    (bank_id);
CREATE INDEX IF NOT EXISTS idx_ownership_bank    ON bank_ownership     (bank_id);
CREATE INDEX IF NOT EXISTS idx_products_bank     ON bank_products      (bank_id);
CREATE INDEX IF NOT EXISTS idx_realestate_bank   ON bank_real_estate   (bank_id);
CREATE INDEX IF NOT EXISTS idx_stock_bank        ON bank_stock_data    (bank_id);
CREATE INDEX IF NOT EXISTS idx_reports_bank      ON annual_reports     (bank_id);
CREATE INDEX IF NOT EXISTS idx_sources_bank      ON data_sources       (bank_id);
