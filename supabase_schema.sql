-- ============================================================
--  AI Ethics 윤리 진단 — Supabase DB 스키마
--  사용법: Supabase 대시보드 → SQL Editor → New query →
--          이 파일 전체 붙여넣기 → Run
-- ============================================================

-- ------------------------------------------------------------
-- 1) 진단 세션 (진단 1회 = 1행) : ae_sessions 대체
--    answers / axis_scores / fields 는 JSON으로 통째 저장
-- ------------------------------------------------------------
create table if not exists public.diagnoses (
  id           bigint generated always as identity primary key,
  created_at   timestamptz not null default now(),
  diag_type    text    not null,          -- free / l2 / l3 / l4 / b2b / kids
  diag_label   text,                       -- '무료 인식진단' 등
  name         text,
  phone        text,
  email        text,
  target       text,                       -- 부모/직원/임원 등 역할
  fields       jsonb   default '[]'::jsonb,-- 선택한 분야 배열
  answers      jsonb   default '{}'::jsonb,-- { "0":4, "1":2, ... }
  axis_scores  jsonb   default '[]'::jsonb,-- [{axis, score}, ...]
  total_score  int,
  grade        text,                       -- A+ / A / B / C / D
  reco_course  text,
  is_paid      boolean default false
);

-- ------------------------------------------------------------
-- 2) 상담 신청(리드) : ae_leads 대체
-- ------------------------------------------------------------
create table if not exists public.leads (
  id           bigint generated always as identity primary key,
  created_at   timestamptz not null default now(),
  diag_type    text,
  name         text,
  phone        text,
  email        text
);

-- ------------------------------------------------------------
-- 3) 결제 내역 : ae_payments 대체
-- ------------------------------------------------------------
create table if not exists public.payments (
  id           bigint generated always as identity primary key,
  created_at   timestamptz not null default now(),
  diag_type    text,
  amount       text,                       -- '7,000원' 또는 숫자 문자열
  name         text,
  email        text,
  pay_method   text,                       -- card / kakao / naver
  status       text default '완료'         -- 완료 / 취소 / 대기
);

-- ============================================================
--  보안(RLS) 설정 — GitHub Pages 배포용 (공개 키 전제)
--  ▸ 비로그인(anon): '저장(insert)'만 허용 (진단 응시자)
--  ▸ 조회(select): '로그인한 관리자(authenticated)'만 허용
--    → 공개된 anon 키로는 개인정보를 읽을 수 없음 (안전)
-- ============================================================
alter table public.diagnoses enable row level security;
alter table public.leads     enable row level security;
alter table public.payments  enable row level security;

-- (재실행 대비) 기존 정책 정리
drop policy if exists "anon insert diagnoses" on public.diagnoses;
drop policy if exists "anon insert leads"     on public.leads;
drop policy if exists "anon insert payments"  on public.payments;
drop policy if exists "read diagnoses" on public.diagnoses;
drop policy if exists "read leads"     on public.leads;
drop policy if exists "read payments"  on public.payments;
drop policy if exists "auth read diagnoses" on public.diagnoses;
drop policy if exists "auth read leads"     on public.leads;
drop policy if exists "auth read payments"  on public.payments;

-- 저장(insert) — 누구나 허용 (응시자는 비로그인 상태)
create policy "anon insert diagnoses" on public.diagnoses for insert to anon with check (true);
create policy "anon insert leads"     on public.leads     for insert to anon with check (true);
create policy "anon insert payments"  on public.payments  for insert to anon with check (true);

-- 조회(select) — 로그인한 사용자(관리자)만 허용
create policy "auth read diagnoses" on public.diagnoses for select to authenticated using (true);
create policy "auth read leads"     on public.leads     for select to authenticated using (true);
create policy "auth read payments"  on public.payments  for select to authenticated using (true);

-- ※ 관리자 계정 만들기:
--   Supabase 대시보드 → Authentication → Users → Add user
--   (이메일/비밀번호로 관리자 1명 생성 → 관리자 페이지에서 로그인)

-- 최신순 조회 빠르게
create index if not exists idx_diag_created on public.diagnoses (created_at desc);
create index if not exists idx_leads_created on public.leads (created_at desc);
create index if not exists idx_pay_created on public.payments (created_at desc);
