---
layout: post
title: "[Unity] 래그돌 슬로우 모션 물리 버그 해결기"
date: 2025-08-20
categories: [Unity, GameDev]
tags: [Unity, Ragdoll, Physics, Bug, Slow Motion]
---

## 개요
래그돌(Ragdoll)에 슬로우 모션을 적용할 때 발생하는 물리 버그와 그 해결 과정을 다룬다.<br/>
`Time.timeScale`과 `Time.fixedDeltaTime`을 이용한 초기 접근 방식의 문제점과, `Rigidbody`의 보간(Interpolate) 설정을 통해 문제를 해결한 경험을 공유한다.

## 문제 상황과 초기 접근

### 1. 슬로우 모션 구현 목표
게임에서 특정 상황에 래그돌이 더욱 극적으로 보이도록, 부드러운 슬로우 모션을 구현하는 것이 목표였다.

### 2. 초기 접근 방식
처음에는 유니티의 시간 흐름을 제어하는 `Time.timeScale`과 물리 업데이트 주기를 결정하는 `Time.fixedDeltaTime` 값을 함께 낮추는 방법을 사용했다. 슬로우 모션 비율만큼 `fixedDeltaTime`을 줄이면, 물리 연산이 더 자주 일어나므로 더 부드러운 슬로우 모션을 구현할 수 있을 것이라 예상했다.

### 3. 문제 발생
하지만 이 방식에는 심각한 버그가 있었다. 평상시 속도(`Time.timeScale = 1`)에서 래그돌이 다른 오브젝트와 충돌한 직후, 슬로우 모션을 위해 `Time.timeScale`과 `Time.fixedDeltaTime` 값을 갑자기 낮추면 래그돌을 구성하는 `Rigidbody`들의 속도(velocity)가 비정상적으로 치솟았다. 그 결과, 래그돌이 천장이나 바닥을 뚫고 날아가는 현상이 발생했다.

## 해결 과정

### `Time.fixedDeltaTime` 직접 수정의 문제점
문제의 원인은 `Time.fixedDeltaTime`을 직접 수정한 것에 있었다. 이 값을 동적으로 변경하면 물리 엔진의 계산 스텝이 불안정해져 예기치 않은 결과를 초래할 수 있다. 특히, 충돌 직후처럼 `Rigidbody`의 속도 변화가 큰 상태에서 이 값을 바꾸면, 물리 계산이 증폭되는 현상이 나타난 것으로 추측된다.

### `Rigidbody.Interpolate`의 발견
여러 해결책을 찾던 중, `Time.fixedDeltaTime`은 유니티의 기본값(보통 0.02초)으로 그대로 두고, `Time.timeScale`만 조절하는 방법을 시도했다. 이 방법만으로는 슬로우 모션 시 래그돌이 다소 끊겨 보이는 문제가 있었는데, `Rigidbody` 컴포넌트의 `Interpolate` 설정을 켜자 문제가 해결되었다.

### `Interpolate`의 역할
`Interpolate` 설정은 `FixedUpdate` 사이의 실제 렌더링 프레임에서 `Rigidbody`의 움직임을 부드럽게 보간(Interpolation)하여 시각적으로 끊김 없는 움직임을 만들어준다. 슬로우 모션처럼 `Time.timeScale`이 낮아져 프레임 속도와 물리 업데이트 속도의 차이가 벌어질 때 특히 효과적이다.

### 예제 코드

```csharp
// 슬로우 모션을 적용하거나 해제하는 코드 예시
public void SetSlowMotion(bool isSlow, float slowMotionScale = 0.5f)
{
    if (isSlow)
    {
        Time.timeScale = slowMotionScale;
    }
    else
    {
        Time.timeScale = 1.0f;
    }

    // Time.fixedDeltaTime = 0.02f * Time.timeScale; 
    // 위 코드는 물리 버그를 유발하므로 절대 사용하지 않는다.
}
```

**중요:** 위 코드와 함께, 래그돌을 구성하는 모든 `Rigidbody`에 대해 `Interpolate` 설정을 `Interpolate` 또는 `Extrapolate`로 변경해야 한다. 이 작업은 유니티 에디터에서 직접 할 수 있다.

## 핵심 결론

- **`Time.fixedDeltaTime` 직접 조작은 피하자**: 유니티 물리 엔진의 안정성을 위해 `Time.fixedDeltaTime`을 런타임에 직접 수정하는 것은 가급적 피하는 것이 좋다.
- **`Time.timeScale`과 `Interpolate`의 조합**: `Time.timeScale`로 시간의 흐름 속도를 제어하고, `Rigidbody.Interpolate`로 물리 움직임의 시각적 부드러움을 확보하는 것이 안정적인 슬로우 모션 구현의 핵심이다.

## 마치며
단순히 시간만 느리게 하면 될 것이라는 생각으로 시작했지만, 결국 물리 엔진의 동작 방식에 대한 깊은 이해가 필요한 문제였다. 이번 경험을 통해 `Time.fixedDeltaTime`의 동적 조작이 야기하는 위험성과 `Rigidbody`의 `Interpolate` 설정의 중요성을 명확히 깨닫는 계기가 되었다.

---

*작성일: 2025.08.20*<br/>
*작성자: Cho Donghyun*
