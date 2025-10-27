---
layout: post
title: "[Unity] 새로운 Input System을 위한 커스텀 GetAxis 구현"
date: 2025-10-27
categories: [Unity, GameDev]
tags: [Unity, csharp, "Input System"]
---

## 개요
Unity의 새로운 Input System은 강력하고 유연한 기능을 제공하지만, 기존 Input Manager의 `Input.GetAxis()`처럼 부드러운 float 값을 반환하는 간단한 기능이 없는게 아쉬웠다. 그래서 키보드 입력을 받아 -1과 1 사이의 값을 부드럽게 보간하는 커스텀 `Axis` 클래스를 구현해 보았다.

- **주요 특징:** 기존 `Input.GetAxis()`와 유사한 동작을 구현하여 키 입력에 따라 점진적으로 값이 증감한다.
- **사용 목적:** 새로운 Input System 환경에서 디지털 입력(키보드)을 아날로그 스틱처럼 부드러운 값으로 변환하여 사용하고 싶을 때 유용하다.

## 핵심 기능
`Axis` 클래스는 다음과 같은 핵심 기능들을 가진다.

1.  **부드러운 값의 보간**
    - 키를 누르면 `digitalReturnSpeed`에 따라 값이 점진적으로 증가하거나 감소하며, 키에서 손을 떼면 `autoReturnSpeed`에 따라 서서히 0으로 복귀한다.
2.  **즉각적인 방향 전환**
    - 반대 방향의 키가 입력되면 현재 값을 즉시 0으로 초기화하여 빠른 반응성을 보인다.
3.  **Dead Zone 처리**
    - 입력이 없고 축의 절대값이 `Dead` 값보다 작아지면 값을 0으로 처리하여 미세한 잔류 값을 제거한다.
4.  **Raw 값 반환**
    - `GetValueRaw()` 메서드를 통해 `Input.GetAxisRaw()`처럼 보간 없이 -1, 0, 1 값을 즉시 반환하는 기능도 제공한다.

## 주요 API 및 사용법
전체 코드는 다음과 같다. 이 클래스를 사용하여 커스텀 축을 정의하고 업데이트할 수 있다.

```csharp
using UnityEngine;
using System;

namespace WindowsInput
{
    [Serializable]
    /// <summary>
    /// InputSystem에서 Input.GetAxis() 함수를 대체하는 클래스
    /// </summary>
    public class Axis
    {
        // 기존 Input Manager를 커스터마이징하기 위한 변수들
        [Header("Old Input System (Optional)")]
        /// <summary>
        /// 음수의 값을 출력하는 방향키
        /// </summary>
        public KeyCode negative;

        /// <summary>
        /// 양수의 값을 출력하는 방향키
        /// </summary>
        public KeyCode positive;

        [Header("Axis Settings")]
        /// <summary>
        /// 키를 누르지 않을 때 0으로 돌아가는 속도
        /// </summary>
        public float autoReturnSpeed = 3f;

        /// <summary>
        /// 키를 누를 때 움직이는 속도
        /// </summary>
        public float digitalReturnSpeed = 3f;

        /// <summary>
        /// 키를 누르지 않을 때 val이 이 값 이하면 0f로 초기화
        /// </summary>
        public float Dead = 0.001f;

        [SerializeField]
        /// <summary>
        /// Input Manager에서 커스텀 Axis의 움직임 값
        /// </summary>
        private float value;

        public Axis() { }

        public Axis(KeyCode negative, KeyCode positive, float dead, float autoReturnSpeed, float digitalReturnSpeed)
        {
            this.negative = negative;
            this.positive = positive;
            this.Dead = dead;
            this.autoReturnSpeed = autoReturnSpeed;
            this.digitalReturnSpeed = digitalReturnSpeed;
            this.value = 0f;
        }

        /// <summary>
        /// 값이 들어올 때, 움직임을 업데이트하는 함수
        /// </summary>
        /// <param name="input">입력 값</param>
        /// <param name="val">움직임 반환 값</param>
        public void UpdateAxis(float input, ref float val)
        {
            // 반대 방향 입력 감지: 현재 움직임(value)과 새 입력(input)의 방향이 반대일 경우
            if ((input > 0 && val < 0) || (input < 0 && val > 0))
            {
                val = 0f; // 값을 0으로 초기화하여 즉시 방향을 전환하도록 함
            }

            // 입력이 양수 방향이면, 움직임 값 상승
            if (input > Mathf.Epsilon)
            {
                val += digitalReturnSpeed * Time.deltaTime;
            }
            // 입력이 음수 방향이면, 움직임 값 하강
            else if (input < -Mathf.Epsilon)
            {
                val -= digitalReturnSpeed * Time.deltaTime;
            }
            // 아무런 입력이 없으면
            else
            {
                // 움직임이 양수 방향이면
                if (val > 0)
                {
                    // 움직임 값 자동 하강
                    val -= autoReturnSpeed * Time.deltaTime;
                    if (val < 0) val = 0;
                }
                // 움직임이 음수 방향이면
                else if (val < 0)
                {
                    // 움직임 값 자동 상승
                    val += autoReturnSpeed * Time.deltaTime;
                    if (val > 0) val = 0;
                }
            }

            // 입력이 없으면서 움직임 절대값이 Dead보다 작으면 0으로 초기화
            if (input == 0 && Mathf.Abs(val) < Dead)
            {
                val = 0f;
            }

            // 움직임의 값은 -1 ~ 1 사이로 제한
            val = Mathf.Clamp(val, -1f, 1f);
        }

        /// <summary>
        /// Input Manager에서 Axis를 커스텀할 때 사용하는 함수
        /// </summary>
        /// <returns></returns>
        public float UpdateAxisFromLegacyInput()
        {
            float input = 0;
            if (Input.GetKey(positive))
            {
                input = 1;
            }
            else if (Input.GetKey(negative))
            {
                input = -1;
            }
            UpdateAxis(input, ref value);
            return value;
        }

        /// <summary>
        /// Input Manager에서 커스텀 Axis의 움직임 값 반환 함수
        /// </summary>
        /// <returns></returns>
        public float GetValue()
        {
            return value;
        }

        /// <summary>
        /// GetAxisRaw 커스텀 함수
        /// </summary>
        /// <returns></returns>
        public float GetValueRaw()
        {
            bool negativeHeld = Input.GetKey(negative);
            bool positiveHeld = Input.GetKey(positive);

            if (negativeHeld && positiveHeld)
            {
                return 0f;
            }
            if (negativeHeld)
            {
                return -1f;
            }
            if (positiveHeld)
            {
                return 1f;
            }
            return 0f;
        }
    }
}
```

### 예제 코드
`MonoBehaviour`를 상속받는 클래스에서 다음과 같이 `Axis`를 사용할 수 있다.

```csharp
using UnityEngine;
using WindowsInput; // Axis 클래스의 네임스페이스

public class PlayerController : MonoBehaviour
{
    public Axis horizontalAxis = new Axis(); // 새 Axis 클래스 추가
    public Vector2 moveVec; // 입력키 입력 여부 확인 변수
    public Vector2 curVec; // 실제 움직임에 사용될 값

    // Input System의 함수를 통해 방향키 입력 값 받아옴
    void OnMove(InputValue value)
    {
        moveVec = value.Get<Vector2>();
    }

    void Update()
    {
        // 매 프레임마다 움직임 값을 업데이트
        move.UpdateAxis(moveVec.x, ref curVec.x);
        move.UpdateAxis(moveVec.y, ref curVec.y);
    }
}
```

## 장단점

### 장점
- 기존 `Input.GetAxis()`의 동작 방식을 그대로 재현할 수 있어 익숙하다.
- 키보드 입력만으로도 부드러운 아날로그 움직임을 쉽게 구현할 수 있다.
- 감도(`digitalReturnSpeed`)와 복귀 속도(`autoReturnSpeed`)를 자유롭게 조절할 수 있다.

### 단점
- Unity의 새로운 Input System의 핵심 기능(Action, Binding 등)을 직접 활용하는 방식은 아니다.
- `Update()` 함수 내에서 매 프레임 수동으로 값을 갱신해주어야 한다.

## 마치며
Unity의 새로운 Input System은 강력하지만, 때로는 기존 방식의 단순함이 필요할 때가 있다. 이 커스텀 `Axis` 클래스는 새로운 시스템 환경에서도 `Input.GetAxis()`와 같은 부드러운 입력 처리를 가능하게 해주는 유용한 대안이 될 수 있다. 특히 키보드를 주된 입력으로 사용하는 게임에서 플레이어에게 더 나은 조작감을 제공하는 데 도움이 될 것이다.

---

*작성일: 2025.10.27*<br/>
*작성자: Cho Donghyun*
