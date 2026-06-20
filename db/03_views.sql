-- 03_views.sql : reporting views (security_invoker; JOD normalization in-view)
-- FX peg: 1 USD = 0.709 JOD. USD-reported rows = Arab Bank only.
create or replace view v_bank_latest_financials with (security_invoker=true) as
select distinct on (f.bank_id)
  f.bank_id, b.name_en, b.name_ar, b.short_name, b.bank_type,
  f.fiscal_year, f.currency,
  f.total_assets, f.customer_deposits, f.net_loans, f.total_equity, f.net_profit,
  f.net_interest_income, f.roe, f.roa, f.car, f.npl_ratio,
  (f.total_assets      * case when f.currency='USD' then 0.709 else 1 end)::bigint as total_assets_jod,
  (f.customer_deposits * case when f.currency='USD' then 0.709 else 1 end)::bigint as customer_deposits_jod,
  (f.net_loans         * case when f.currency='USD' then 0.709 else 1 end)::bigint as net_loans_jod,
  (f.net_profit        * case when f.currency='USD' then 0.709 else 1 end)::bigint as net_profit_jod
from bank_financials f join banks b on b.bank_id=f.bank_id
where b.is_active order by f.bank_id, f.fiscal_year desc;

create or replace view v_sector_rankings with (security_invoker=true) as
select bank_id, name_en, short_name, bank_type, fiscal_year,
  total_assets_jod, customer_deposits_jod, net_profit_jod, roe, roa,
  rank() over (order by total_assets_jod      desc nulls last) as rank_assets,
  rank() over (order by customer_deposits_jod desc nulls last) as rank_deposits,
  rank() over (order by net_profit_jod        desc nulls last) as rank_profit
from v_bank_latest_financials;

create or replace view v_latest_rates with (security_invoker=true) as
select distinct on (r.bank_id)
  r.bank_id, b.name_en, b.short_name, b.bank_type,
  r.home_loan_min, r.home_loan_max, r.personal_loan_min, r.personal_loan_max,
  r.saving_rate, r.effective_date
from bank_rates r join banks b on b.bank_id=r.bank_id
where b.is_active order by r.bank_id, r.effective_date desc;

create or replace view v_home_loan_comparison with (security_invoker=true) as
select bank_id, name_en, short_name, home_loan_min, home_loan_max, effective_date
from v_latest_rates where home_loan_min is not null order by home_loan_min asc;

create or replace view v_announcements_feed with (security_invoker=true) as
select a.id as announcement_id, a.bank_id, b.name_en, b.short_name,
  a.category, a.headline_en, a.headline_ar, a.summary_en, a.announcement_date, a.source_url, a.is_verified
from bank_announcements a left join banks b on b.bank_id=a.bank_id
order by a.announcement_date desc nulls last;

create or replace view v_yoy_growth with (security_invoker=true) as
with f as (
  select fin.bank_id, b.name_en, fin.fiscal_year,
    (fin.total_assets      * case when fin.currency='USD' then 0.709 else 1 end)::bigint as total_assets_jod,
    (fin.customer_deposits * case when fin.currency='USD' then 0.709 else 1 end)::bigint as customer_deposits_jod,
    (fin.net_profit        * case when fin.currency='USD' then 0.709 else 1 end)::bigint as net_profit_jod
  from bank_financials fin join banks b on b.bank_id=fin.bank_id where b.is_active
)
select bank_id, name_en, fiscal_year, total_assets_jod,
  lag(total_assets_jod) over w as total_assets_jod_prev,
  round((total_assets_jod - lag(total_assets_jod) over w)::numeric / nullif(lag(total_assets_jod) over w,0)*100,2) as assets_growth_pct,
  customer_deposits_jod,
  round((customer_deposits_jod - lag(customer_deposits_jod) over w)::numeric / nullif(lag(customer_deposits_jod) over w,0)*100,2) as deposits_growth_pct,
  net_profit_jod,
  round((net_profit_jod - lag(net_profit_jod) over w)::numeric / nullif(lag(net_profit_jod) over w,0)*100,2) as profit_growth_pct
from f window w as (partition by bank_id order by fiscal_year)
order by bank_id, fiscal_year desc;

grant select on v_bank_latest_financials, v_sector_rankings, v_latest_rates,
  v_home_loan_comparison, v_announcements_feed, v_yoy_growth to anon, authenticated;