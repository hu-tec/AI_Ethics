# AI Ethics Center — 프로젝트 패키지

Claude Code로 개발·수정하기 위한 전체 패키지입니다.

---

## 📁 파일 구조

```
AI-Ethics-Center/
├── AI Ethics Center.dc.html       ← 메인 홈페이지 (전체 섹션)
├── AI윤리플랫폼.dc.html             ← 진단 플랫폼 (무료진단 모달 포함)
├── AI윤리플랫폼_standalone.html     ← 진단 플랫폼 독립 실행 버전
├── support.js                      ← DC 런타임 (필수 — 삭제 금지)
├── README.md                       ← 이 파일
└── uploads/                        ← 업로드 이미지
```

---

## 🚀 로컬 실행 방법

### VS Code Live Server (권장)
```bash
# 1. VS Code에서 폴더 열기
# 2. Live Server 확장 설치
# 3. AI Ethics Center.dc.html 우클릭 → "Open with Live Server"
```

### Python 간단 서버
```bash
cd "프로젝트 폴더"
python -m http.server 8080
# 브라우저에서 http://localhost:8080 접속
```

### Node.js
```bash
npx serve .
```

---

## 📄 파일별 역할

### 1. `AI Ethics Center.dc.html` — 메인 홈페이지
전체 홈페이지. 다음 섹션 포함:
- 네비게이션 (고정 상단)
- 히어로 섹션
- 그룹소개
- AI 윤리 소개 + 8대 핵심 원칙
- AI 윤리 발전 과정 (4단계 타임라인)
- 적용 분야 (탭 4개 × 카드 6개 인터랙션)
- 업무 프로세스 (4단계 + 3가지 분기 경로)
- 국가별 현황 (국제기구 4개 + ESG 배너 + 국가별 + 한국 강조)
- 전문가 교감 (분야별/업무별 + 지원서 폼)
- 커뮤니티 (뉴스 + 자료실 + 토론 광장)
- 푸터

**"무료 윤리 진단 시작하기" 버튼 연결:**
```html
<!-- AI Ethics Center.dc.html 히어로 섹션에서 -->
<a href="AI윤리플랫폼.dc.html">무료 윤리 진단 시작하기 →</a>
```

---

### 2. `AI윤리플랫폼.dc.html` — 진단 플랫폼
AI 윤리 진단 전체 플랫폼. 다음 기능 포함:
- 무료 진단 모달 (5단계: 유형선택→정보입력→결제→분야선택→문항→결과)
- 진단 문항: Free(24문항) / L2(15문항) / L3(15문항) / L4(10문항) / B2B
- 결과 화면: 점수(0~100) + 등급(A+~D) + 레이더차트 + 취약영역/강점
- 단계별 가격: 무료 / 3,000원 / 7,000원 / 12,000원
- 자격 등급 테이블 (유치원~최고전문가 심사관)
- 기업 인증 프로세스 7단계
- 전문가 등록 폼
- 문의 폼

---

## 🔧 주요 수정 포인트

### 홈페이지 색상 변경
```html
<!-- 주요 색상 변수 (inline style로 관리) -->
메인 틸: #1a6b5c
다크 배경: #0c1b19
강조 초록: #4ade80
파랑: #2563eb
보라: #7c3aed
```

### 진단 문항 추가/수정
```javascript
// AI윤리플랫폼.dc.html → Component 클래스 → static QS
static QS = {
  free: [...],  // 무료 24문항
  l2: [...],    // L2 전문 15문항
  l3: [...],    // L3 고급 15문항
  l4: [...],    // L4 심사관 10문항
  b2b: [...],   // B2B 기업 문항
}
```

### 탭 콘텐츠 수정 (적용 분야)
```javascript
// AI Ethics Center.dc.html → Component 클래스 → renderVals()
const allCards = [
  // 0: 산업별 (6개 카드)
  // 1: 관문별 (6개 카드)
  // 2: 기능별 (6개 카드)
  // 3: 한텍스트 (6개 카드)
]
```

---

## 🔗 두 파일 연결하기

### 방법 A: 링크 연결 (간단)
```html
<!-- AI Ethics Center.dc.html 히어로 버튼 수정 -->
<a href="AI윤리플랫폼.dc.html" style="...">무료 윤리 진단 시작하기 →</a>
```

### 방법 B: iframe 임베드
```html
<iframe src="AI윤리플랫폼.dc.html" width="100%" height="100vh" frameborder="0"></iframe>
```

### 방법 C: 진단 모달 통합 (고급)
AI윤리플랫폼.dc.html의 DIAGNOSIS MODAL 섹션과 Component 클래스의
진단 관련 메서드들을 AI Ethics Center.dc.html에 병합.

---

## 📋 Claude Code 지시 예시

```
"AI Ethics Center.dc.html에서 히어로 섹션의 
'무료 윤리 진단 시작하기' 버튼을 클릭하면 
AI윤리플랫폼.dc.html로 이동하도록 링크를 연결해줘"

"AI윤리플랫폼.dc.html의 무료 진단 24문항에 
'AI 채용 시스템' 관련 문항 2개를 추가해줘"

"AI Ethics Center.dc.html의 전문가 교감 섹션 
지원서 폼에 파일 첨부 기능을 추가해줘"
```

---

## ⚠️ 주의사항

1. **support.js 필수** — DC 런타임. 삭제하면 페이지가 작동 안 함
2. **같은 폴더 유지** — 두 .dc.html 파일은 반드시 같은 폴더에 있어야 함
3. **한글 파일명** — 일부 환경에서 한글 파일명 문제 발생 시 영문으로 변경 가능
   - `AI윤리플랫폼.dc.html` → `ethics-platform.dc.html`

---

## 📞 문의
expert@aiethics.or.kr
