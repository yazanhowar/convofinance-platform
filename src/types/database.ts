/**
 * Database types for convofinance-platform.
 * Hand-written to fully cover all 14 tables and 6 reporting views. To keep
 * this perfectly in sync with the live schema you can also regenerate it:
 *
 *     npm run types
 *     # supabase gen types typescript --project-id <project-ref>
 *
 * Money columns are BIGINT in thousands of the reporting currency (number).
 * Ratios/percentages are NUMERIC (number). Dates/timestamps are ISO strings.
 */

type Ts = { created_at: string | null; updated_at: string | null };

export interface Banks extends Ts {
  bank_id: number; slug: string | null; name_en: string | null; name_ar: string | null;
  short_name: string | null; short_name_ar: string | null; bank_type: string | null;
  website_url: string | null; ir_url: string | null; established_year: number | null;
  listed_on_ase: boolean | null; ticker: string | null; swift_code: string | null;
  headquarters: string | null; is_active: boolean | null; notes: string | null;
}

export interface BankFinancials extends Ts {
  id: number; bank_id: number; fiscal_year: number | null; currency: string | null;
  total_assets: number | null; net_loans: number | null; customer_deposits: number | null;
  shareholders_equity: number | null; total_equity: number | null; paid_up_capital: number | null;
  net_interest_income: number | null; net_fee_income: number | null; total_income: number | null;
  operating_expenses: number | null; provision_expense: number | null; net_profit: number | null;
  eps_fils: number | null; book_value_per_share: number | null; dividends_cash_pct: number | null;
  dividends_bonus_pct: number | null; roe: number | null; roa: number | null; car: number | null;
  npl_ratio: number | null; npl_coverage: number | null; loan_to_deposit: number | null;
  cost_to_income: number | null; net_interest_margin: number | null; employee_count: number | null;
  branch_count: number | null; report_url: string | null; source_type: string | null; notes: string | null;
}

export interface BankRates extends Ts {
  id: number; bank_id: number; effective_date: string | null;
  home_loan_min: number | null; home_loan_max: number | null; personal_loan_min: number | null;
  personal_loan_max: number | null; car_loan_min: number | null; car_loan_max: number | null;
  credit_card_rate: number | null; corporate_loan_min: number | null; corporate_loan_max: number | null;
  sme_loan_min: number | null; sme_loan_max: number | null; overdraft_rate: number | null;
  saving_rate: number | null; current_rate: number | null; td_1m: number | null; td_3m: number | null;
  td_6m: number | null; td_12m: number | null; td_24m: number | null; td_36m: number | null;
  td_usd_3m: number | null; td_usd_6m: number | null; td_usd_12m: number | null;
  murabaha_rate_min: number | null; murabaha_rate_max: number | null; wakala_rate: number | null;
  mudaraba_rate: number | null; currency: string | null; rate_type: string | null;
  source_url: string | null; raw_notes: string | null;
}

export interface BankTariffs extends Ts {
  id: number; bank_id: number; effective_date: string | null;
  local_transfer_fee: number | null; local_transfer_fee_type: string | null;
  swift_transfer_fee_jod: number | null; swift_transfer_fee_pct: number | null;
  swift_transfer_min: number | null; swift_transfer_max: number | null;
  account_maintenance_fee: number | null; statement_fee: number | null; cheque_book_fee: number | null;
  stop_payment_fee: number | null; dormant_account_fee: number | null; debit_card_annual_fee: number | null;
  credit_card_annual_fee_classic: number | null; credit_card_annual_fee_gold: number | null;
  credit_card_annual_fee_platinum: number | null; cash_advance_fee_pct: number | null;
  late_payment_fee: number | null; loan_origination_fee_pct: number | null; early_settlement_fee_pct: number | null;
  safe_box_small_annual: number | null; safe_box_medium_annual: number | null; safe_box_large_annual: number | null;
  atm_withdrawal_own_free: boolean | null; atm_withdrawal_other_fee: number | null;
  internet_banking_fee: number | null; currency: string | null; source_url: string | null; raw_notes: string | null;
}

export interface BankAnnouncements extends Ts {
  id: number; bank_id: number; announcement_date: string | null; category: string | null;
  headline_en: string | null; headline_ar: string | null; summary_en: string | null; summary_ar: string | null;
  source_url: string | null; source_type: string | null; fiscal_year: number | null;
  is_verified: boolean | null; tags: string[] | null; notes: string | null;
}

export interface BankProducts extends Ts {
  id: number; bank_id: number; category: string | null; sub_category: string | null;
  product_name_en: string | null; product_name_ar: string | null; description_en: string | null;
  description_ar: string | null; min_amount: number | null; max_amount: number | null;
  min_tenor_months: number | null; max_tenor_months: number | null; currency: string | null;
  is_islamic: boolean | null; sharia_structure: string | null; target_segment: string | null;
  is_active: boolean | null; source_url: string | null; notes: string | null;
}

export interface BankBoardMembers extends Ts {
  id: number; bank_id: number; fiscal_year: number | null; full_name_en: string | null;
  full_name_ar: string | null; role: string | null; is_independent: boolean | null;
  committee: string | null; nationality: string | null; notes: string | null; source_url: string | null;
}

export interface BankExecutives extends Ts {
  id: number; bank_id: number; fiscal_year: number | null; full_name_en: string | null;
  full_name_ar: string | null; title_en: string | null; title_ar: string | null;
  department: string | null; source_url: string | null; notes: string | null;
}

export interface BankOwnership extends Ts {
  id: number; bank_id: number; fiscal_year: number | null; shareholder_name_en: string | null;
  shareholder_name_ar: string | null; shareholder_type: string | null; ownership_pct: number | null;
  country: string | null; source_url: string | null; notes: string | null;
}

export interface BankRealEstate extends Ts {
  id: number; bank_id: number; property_type: string | null; location: string | null;
  price_jod: number | null; area_sqm: number | null; description_en: string | null;
  description_ar: string | null; listing_url: string | null; source_url: string | null;
}

export interface BankStockData {
  id: number; bank_id: number; ticker: string | null; price: number | null; day_high: number | null;
  day_low: number | null; change_pct: number | null; volume: number | null; market_cap: number | null;
  price_date: string | null; updated_at: string | null;
}

export interface AnnualReports extends Ts {
  id: number; bank_id: number; fiscal_year: number | null; language: string | null;
  pdf_url: string | null; pdf_url_ar: string | null; page_count: number | null; file_size_kb: number | null;
  is_audited: boolean | null; auditor: string | null; published_date: string | null; notes: string | null;
}

export interface DataSources extends Ts {
  id: number; bank_id: number; source_type: string | null; url: string | null; label: string | null;
  language: string | null; is_active: boolean | null; last_verified: string | null; notes: string | null;
}

export interface CbjPolicyRates extends Ts {
  id: number; effective_date: string | null; overnight_deposit_rate: number | null;
  overnight_lending_rate: number | null; repo_rate: number | null; reserve_requirement_pct: number | null;
  source_url: string | null; notes: string | null;
}

// ---- Views ----------------------------------------------------------------

export interface VBankLatestFinancials {
  bank_id: number; name_en: string | null; name_ar: string | null; short_name: string | null;
  bank_type: string | null; fiscal_year: number | null; currency: string | null;
  total_assets: number | null; customer_deposits: number | null; net_loans: number | null;
  total_equity: number | null; net_profit: number | null; net_interest_income: number | null;
  roe: number | null; roa: number | null; car: number | null; npl_ratio: number | null;
  total_assets_jod: number | null; customer_deposits_jod: number | null;
  net_loans_jod: number | null; net_profit_jod: number | null;
}

export interface VSectorRankings {
  bank_id: number; name_en: string | null; short_name: string | null; bank_type: string | null;
  fiscal_year: number | null; total_assets_jod: number | null; customer_deposits_jod: number | null;
  net_profit_jod: number | null; roe: number | null; roa: number | null;
  rank_assets: number; rank_deposits: number; rank_profit: number;
}

export interface VLatestRates {
  bank_id: number; name_en: string | null; short_name: string | null; bank_type: string | null;
  home_loan_min: number | null; home_loan_max: number | null; personal_loan_min: number | null;
  personal_loan_max: number | null; saving_rate: number | null; effective_date: string | null;
}

export interface VHomeLoanComparison {
  bank_id: number; name_en: string | null; short_name: string | null;
  home_loan_min: number | null; home_loan_max: number | null; effective_date: string | null;
}

export interface VAnnouncementsFeed {
  announcement_id: number; bank_id: number | null; name_en: string | null; short_name: string | null;
  category: string | null; headline_en: string | null; headline_ar: string | null;
  summary_en: string | null; announcement_date: string | null; source_url: string | null; is_verified: boolean | null;
}

export interface VYoyGrowth {
  bank_id: number; name_en: string | null; fiscal_year: number | null;
  total_assets_jod: number | null; total_assets_jod_prev: number | null; assets_growth_pct: number | null;
  customer_deposits_jod: number | null; deposits_growth_pct: number | null;
  net_profit_jod: number | null; profit_growth_pct: number | null;
}

export interface Database {
  public: {
    Tables: {
      banks: { Row: Banks; Insert: Partial<Banks>; Update: Partial<Banks> };
      bank_financials: { Row: BankFinancials; Insert: Partial<BankFinancials>; Update: Partial<BankFinancials> };
      bank_rates: { Row: BankRates; Insert: Partial<BankRates>; Update: Partial<BankRates> };
      bank_tariffs: { Row: BankTariffs; Insert: Partial<BankTariffs>; Update: Partial<BankTariffs> };
      bank_announcements: { Row: BankAnnouncements; Insert: Partial<BankAnnouncements>; Update: Partial<BankAnnouncements> };
      bank_products: { Row: BankProducts; Insert: Partial<BankProducts>; Update: Partial<BankProducts> };
      bank_board_members: { Row: BankBoardMembers; Insert: Partial<BankBoardMembers>; Update: Partial<BankBoardMembers> };
      bank_executives: { Row: BankExecutives; Insert: Partial<BankExecutives>; Update: Partial<BankExecutives> };
      bank_ownership: { Row: BankOwnership; Insert: Partial<BankOwnership>; Update: Partial<BankOwnership> };
      bank_real_estate: { Row: BankRealEstate; Insert: Partial<BankRealEstate>; Update: Partial<BankRealEstate> };
      bank_stock_data: { Row: BankStockData; Insert: Partial<BankStockData>; Update: Partial<BankStockData> };
      annual_reports: { Row: AnnualReports; Insert: Partial<AnnualReports>; Update: Partial<AnnualReports> };
      data_sources: { Row: DataSources; Insert: Partial<DataSources>; Update: Partial<DataSources> };
      cbj_policy_rates: { Row: CbjPolicyRates; Insert: Partial<CbjPolicyRates>; Update: Partial<CbjPolicyRates> };
    };
    Views: {
      v_bank_latest_financials: { Row: VBankLatestFinancials };
      v_sector_rankings: { Row: VSectorRankings };
      v_latest_rates: { Row: VLatestRates };
      v_home_loan_comparison: { Row: VHomeLoanComparison };
      v_announcements_feed: { Row: VAnnouncementsFeed };
      v_yoy_growth: { Row: VYoyGrowth };
    };
    Functions: Record<string, never>;
    Enums: Record<string, never>;
  };
}
