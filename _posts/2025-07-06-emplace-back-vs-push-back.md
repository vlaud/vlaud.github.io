---
layout: post
title: "emplace_back vs push_back - 개념과 예시"
date: 2025-07-06
categories: [STL]
tags: [cplusplus, cplusplus11, emplace_back, push_back, vector, performance]
---

## 개념
C++11부터 `std::vector` 같은 컨테이너에 원소를 추가하는 새로운 방법으로 `emplace_back`이 도입되었다. `push_back`과 `emplace_back`은 모두 컨테이너의 끝에 원소를 추가하는 역할을 하지만, **원소를 생성하고 추가하는 방식**에서 결정적인 차이가 있다.

- **`push_back`:** **이미 생성된 객체**를 컨테이너에 **복사 또는 이동**하여 추가한다.
- **`emplace_back`:** 컨테이너 내부의 메모리 공간에 **객체를 직접 생성**한다. 따라서 임시 객체의 생성 및 복사/이동 과정이 생략될 수 있다.
- **대표적인 예:** 복잡한 생성자를 가진 객체나, 복사 비용이 큰 객체를 `std::vector`에 추가할 때 성능 차이가 발생한다.

## 주요 원리: Perfect Forwarding
`emplace_back`의 핵심 기술은 **Perfect Forwarding (완벽 전달)**이다.

1.  **가변 인자 템플릿(Variadic Templates):** `emplace_back`은 임의의 개수와 타입의 인자를 받을 수 있다.
2.  **`std::forward`:** 이 인자들을 객체의 생성자로 **완벽하게 전달**한다. 인자가 l-value이면 l-value로, r-value이면 r-value로 정확하게 전달하여 가장 적절한 생성자가 호출되도록 보장한다.
3.  **In-place 생성:** 전달받은 인자들을 사용하여 컨테이너가 할당한 메모리 위치에서 바로 객체를 생성한다.

## 예시: `push_back`의 동작
`push_back`은 항상 이미 존재하는 객체를 인자로 받는다.

- **상황:** `MyObject obj(1, 2); vec.push_back(obj);`
- **동작:**
    1. `obj` 객체가 미리 생성된다.
    2. `push_back` 호출 시, `obj`의 복사 생성자가 호출되어 컨테이너 내부에 사본이 생성된다.

- **상황:** `vec.push_back(MyObject(1, 2));` (임시 객체 전달)
- **동작:**
    1. `MyObject(1, 2)` 임시 객체가 생성된다.
    2. `push_back` 호출 시, 임시 객체의 **이동 생성자(Move Constructor)**가 호출되어 컨테이너 내부로 리소스가 이동한다. (복사보다 효율적이지만, 임시 객체 생성 비용은 여전히 존재)

### 코드 예시: `push_back`
```cpp
#include <iostream>
#include <vector>

struct MyObject {
    MyObject(int a, int b) { std::cout << "  일반 생성자 호출\n"; }
    MyObject(const MyObject& other) { std::cout << "  복사 생성자 호출\n"; }
    MyObject(MyObject&& other) noexcept { std::cout << "  이동 생성자 호출\n"; }
};

int main() {
    std::cout << "push_back (이미 생성된 객체):\n";
    MyObject obj(3, 4);
    vec.push_back(obj); // 일반 생성자 -> 복사 생성자

    std::vector<MyObject> vec;
    std::cout << "\npush_back (임시 객체):\n";
    vec.push_back(MyObject(1, 2)); // 일반 생성자 -> 이동 생성자
    return 0;
}
```

## 예시: `emplace_back`의 동작
`emplace_back`은 객체를 만드는 데 필요한 '재료'(생성자 인자)를 직접 전달받는다.

- **상황:** `vec.emplace_back(1, 2);`
- **동작:**
    1. `emplace_back`은 인자 `1, 2`를 내부로 전달받는다.
    2. 컨테이너 안에서 `MyObject`의 생성자 `MyObject(1, 2)`를 직접 호출하여 객체를 제자리(in-place)에 생성한다.
    3. **임시 객체 생성, 복사, 이동 과정이 모두 생략된다.**

### 코드 예시: `emplace_back`
```cpp
#include <iostream>
#include <vector>

// (MyObject 구조체는 위와 동일)

int main() {
    std::vector<MyObject> vec;
    std::cout << "emplace_back:\n";
    vec.emplace_back(1, 2); // 일반 생성자만 호출됨
    return 0;
}
```

## 실전 예시: 언제 `emplace_back`이 유리한가?
- **복잡하고 무거운 객체:** 생성 및 복사 비용이 큰 사용자 정의 클래스, 스마트 포인터 등을 담을 때 `emplace_back`의 성능 향상이 두드러진다.
- **명시적(explicit) 생성자:** `explicit`으로 선언된 생성자를 가진 객체는 `push_back({arg1, arg2})` 형태의 암시적 변환이 불가능하지만, `emplace_back(arg1, arg2)`로는 직접 생성이 가능하다.

## 마치며
`emplace_back`은 불필요한 임시 객체의 생성과 복사/이동을 줄여주는 강력한 도구이다. 대부분의 경우 `push_back`보다 효율적이거나 최소한 동일한 성능을 보인다. 따라서 Modern C++ 환경에서는 특별한 이유가 없다면 `push_back` 대신 `emplace_back`을 우선적으로 사용하는 것이 좋다.

---

*작성일: 2025.07.06*<br/>
*작성자: Cho Donghyun*
