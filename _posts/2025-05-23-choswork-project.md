---
layout: post
title: "Unity 3D 공포 게임 프로젝트 - choswork"
date: 2025-05-23
categories: [Unity, GameDev, Portfolio]
tags: [Unity, C#, FSM, GameDevelopment, AI, 3D]
---

# choswork: 투약 시간(가제)

## 프로젝트 요약
- Unity 기반 3D 공포 게임 (개인 제작)
- FSM 기반 AI 추적 시스템, 카메라/사운드 연출 포함
- 데모 영상: [YouTube 링크](https://youtu.be/3l61qr2uoDs?si=6gp0NSIAj7bBtbh3)
- 깃허브 링크: [깃허브 링크](https://github.com/vlaud/choswork)

## 프로젝트 개요

### 기본 정보
- **프로젝트 이름**: `choswork` (가제)
- **개발 유형**: 개인 프로젝트
- **개발 기간**: 2022.12.06 ~ (진행 중)
- **개발 도구**: Unity 6000.0.28f1

### 핵심 목표
1. Unity 엔진 기반 실제 플레이 가능한 공포 게임 제작
2. 몰입감 있는 공포 연출과 AI 추적 시스템 구현
3. Git 브랜치 전략, 코드 리팩토링, 이슈 관리 워크플로우 실습

## 주요 기능

### 1. AI 추적 시스템 (FSM)
- 플레이어 시야 감지 및 추적
- 소리 기반 탐색 시스템
- Switch 기반 FSM 구조
- Scriptable FSM 구조로의 확장 가능성 고려

### 2. 몰입형 연출 기능
- 1인칭/3인칭 카메라 전환
- 피격 시 카메라 흔들림 효과
- 사망 시 페이드아웃 연출

### 3. 사운드 연출 시스템
- 상황 기반 BGM 자동 전환
- Singleton 기반 Audio Manager
- BGM 및 SFX 통합 관리

## 기술 스택

### 핵심 기술
- **엔진**: Unity 6000.0.28f1
- **언어**: C#
- **버전 관리**: Git / GitHub

### 디자인 패턴
- FSM (Finite State Machine)
- 싱글톤
- 옵저버
- 이벤트 버스
- 커맨드 패턴
- 오브젝트 풀

## 주요 개발 전략

### 1. 경량 FSM 설계
- AI 상태 전이 구현
- Unity Animator 활용
- Coroutines를 통한 효과 제어

### 2. 모듈화된 구조
- GameManager
- UIManager
- AudioManager
- 명확한 책임 분리

## 학습 및 성장 포인트

### 1. 상태 전이 충돌 해결
- 커맨드 패턴 도입
- 단일 책임 원칙 준수
- 유연한 상태 관리

### 2. UI 연동 카메라 제어
- 이벤트 버스 활용
- 커맨드 패턴 조합
- 이벤트 드리븐 구조

### 3. 다중 시스템 반응 처리
- 이벤트 버스 패턴
- 느슨한 결합 설계
- 시스템 확장성 확보

## 향후 계획

### 단기 목표 (1~2주)
- FSM 구조 ScriptableObject 기반 리팩토링
- WebGL 빌드 테스트 및 최적화

### 중기 목표 (1개월)
- Unity Timeline 활용 컷씬 연출
- 유닛 테스트 및 로깅 체계화
- 비트마스크 상태 관리 개선

### 장기 목표 (2~3개월)
- UI/UX 전반 개선
- 제너릭 옵저버 패턴 적용
- 외부 배포 및 피드백 수집

## 프로젝트 구조
```plaintext
📁 Choswork/
├─ Assets/
│  ├─ Scripts/
│  │  ├─ Base/
│  │  ├─ Camera/
│  │  ├─ Commands/
│  │  ├─ EventBus/
│  │  └─ UI/
│  ├─ Scenes/
│  ├─ Resources/
│  └─ AudioClips/
└─ README.md
```

---

*작성일: 2025.05.23*
*작성자: Cho Donghyun (Unity 클라이언트 개발자 지망생)* 