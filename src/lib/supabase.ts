import { createClient } from '@supabase/supabase-js';
import type { Database } from '../types/database';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabasePublishableKey = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!;

/**
 * Browser-safe client. Uses the publishable key, which only has read access
 * (Row Level Security permits SELECT, denies writes).
 */
export const supabase = createClient<Database>(supabaseUrl, supabasePublishableKey);

/**
 * Server-only admin client. Uses the service-role key, which bypasses RLS.
 * NEVER import this into client components — it must only run in API routes,
 * server actions, or cron jobs.
 */
export const supabaseAdmin = () =>
  createClient<Database>(supabaseUrl, process.env.SUPABASE_SERVICE_ROLE_KEY!);
