import { supabase } from './supabase';

/**
 * Read layer. Each function returns rows from a table or reporting view.
 * Business logic (currency normalization, rankings, latest-row selection)
 * lives in the SQL views, not here — see db/03_views.sql.
 */

// ---- Core registry -------------------------------------------------------

export async function getBanks() {
  const { data, error } = await supabase
    .from('banks').select('*').eq('is_active', true).order('name_en');
  if (error) throw error;
  return data;
}

export async function getBank(bankId: number) {
  const { data, error } = await supabase
    .from('banks').select('*').eq('bank_id', bankId).single();
  if (error) throw error;
  return data;
}

// ---- Financials ----------------------------------------------------------

export async function getLatestFinancials() {
  const { data, error } = await supabase
    .from('v_bank_latest_financials').select('*')
    .order('total_assets_jod', { ascending: false, nullsFirst: false });
  if (error) throw error;
  return data;
}

export async function getSectorRankings() {
  const { data, error } = await supabase
    .from('v_sector_rankings').select('*').order('rank_assets');
  if (error) throw error;
  return data;
}

export async function getYoYGrowth() {
  const { data, error } = await supabase
    .from('v_yoy_growth').select('*').order('fiscal_year', { ascending: false });
  if (error) throw error;
  return data;
}

export async function getFinancialsForBank(bankId: number) {
  const { data, error } = await supabase
    .from('bank_financials').select('*').eq('bank_id', bankId)
    .order('fiscal_year', { ascending: false });
  if (error) throw error;
  return data;
}

// ---- Rates & tariffs -----------------------------------------------------

export async function getLatestRates() {
  const { data, error } = await supabase
    .from('v_latest_rates').select('*').order('name_en');
  if (error) throw error;
  return data;
}

export async function getHomeLoanComparison() {
  const { data, error } = await supabase
    .from('v_home_loan_comparison').select('*').order('home_loan_min');
  if (error) throw error;
  return data;
}

export async function getTariffs() {
  const { data, error } = await supabase
    .from('bank_tariffs').select('*, banks(name_en, short_name, bank_type)')
    .order('effective_date', { ascending: false });
  if (error) throw error;
  return data;
}

// ---- Announcements -------------------------------------------------------

export async function getAnnouncements(limit = 20) {
  const { data, error } = await supabase
    .from('v_announcements_feed').select('*')
    .order('announcement_date', { ascending: false }).limit(limit);
  if (error) throw error;
  return data;
}

// ---- Products ------------------------------------------------------------

export async function getProducts(bankId?: number) {
  let q = supabase.from('bank_products').select('*').eq('is_active', true);
  if (bankId) q = q.eq('bank_id', bankId);
  const { data, error } = await q.order('category');
  if (error) throw error;
  return data;
}

// ---- Governance ----------------------------------------------------------

export async function getBoardMembers(bankId: number) {
  const { data, error } = await supabase
    .from('bank_board_members').select('*').eq('bank_id', bankId);
  if (error) throw error;
  return data;
}

export async function getExecutives(bankId: number) {
  const { data, error } = await supabase
    .from('bank_executives').select('*').eq('bank_id', bankId);
  if (error) throw error;
  return data;
}

export async function getOwnership(bankId: number) {
  const { data, error } = await supabase
    .from('bank_ownership').select('*').eq('bank_id', bankId);
  if (error) throw error;
  return data;
}

// ---- Real estate & market data ------------------------------------------

export async function getRealEstate(bankId?: number) {
  let q = supabase.from('bank_real_estate').select('*');
  if (bankId) q = q.eq('bank_id', bankId);
  const { data, error } = await q.order('price_jod', { ascending: false, nullsFirst: false });
  if (error) throw error;
  return data;
}

export async function getStockData() {
  const { data, error } = await supabase
    .from('bank_stock_data').select('*, banks(name_en, short_name, ticker)');
  if (error) throw error;
  return data;
}
