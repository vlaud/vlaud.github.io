---
layout: post
title: "C++ std::tuple - 개념과 예시"
date: 2025-09-16
categories: [STL]
tags: [cplusplus, cplusplus11, cplusplus17, modern-cplusplus, tuple]
---

## 개념
`std::tuple`은 C++11부터 도입된 기능으로, 서로 다른 타입의 값들을 고정된 크기의 그룹으로 묶어주는 컨테이너이다. 여러 개의 값을 하나의 객체처럼 다루고 싶을 때, 특히 함수에서 여러 값을 반환해야 할 때 매우 유용하게 사용된다.

- **특징 1:** 서로 다른 타입의 요소들을 저장할 수 있다. (이기종, Heterogeneous)
- **특징 2:** 크기가 컴파일 타임에 고정된다.
- **대표적인 예:** 함수의 다중 반환 값, 여러 타입의 데이터를 임시로 묶어서 처리할 때 사용된다.

## 주요 원리 및 사용법
`std::tuple`을 사용하기 위해서는 `<tuple>` 헤더를 포함해야 한다.

1.  **튜플 생성 (`std::tuple`, `std::make_tuple`)**
    - `std::tuple` 생성자를 직접 호출하여 타입을 명시적으로 지정하거나, `std::make_tuple` 헬퍼 함수를 사용하여 컴파일러가 타입을 추론하게 만들 수 있다.

    ```cpp
    // 타입을 직접 명시하여 생성
    std::tuple<int, std::string, double> t1(10, "Hello", 3.14);

    // std::make_tuple로 생성 (타입 추론)
    auto t2 = std::make_tuple(20, std::string("World"), 2.718);
    ```

2.  **요소 접근 (`std::get`)**
    - `std::get<index>(tuple)`: 템플릿 인자로 0부터 시작하는 인덱스를 지정하여 요소에 접근한다. 가장 일반적인 방법이다.
    - `std::get<type>(tuple)`: C++14부터는 튜플 내에 해당 타입의 요소가 유일할 경우, 타입을 지정하여 접근할 수 있다.

    ```cpp
    // 인덱스 기반 접근
    int i = std::get<0>(t1);
    std::string s = std::get<1>(t1);

    // 타입 기반 접근 (C++14 이상)
    double d = std::get<double>(t1);
    ```

3.  **구조화된 바인딩 (Structured Bindings, C++17)**
    - C++17부터는 `std::tuple` (및 `std::pair`, `std::array`, 구조체 등)의 요소들을 개별 변수로 한 번에 언패킹(unpack)할 수 있는 매우 편리한 기능을 제공한다.

    ```cpp
    auto [age, name, height] = std::make_tuple(30, std::string("Alice"), 175.5);
    // age = 30, name = "Alice", height = 175.5
    ```

## 예시: 함수의 다중 반환 값
`std::tuple`의 가장 대표적인 활용 사례는 여러 값을 반환하는 함수를 작성하는 것이다. 기존에는 구조체를 정의하거나 포인터/참조 파라미터를 사용해야 했지만, `std::tuple`을 사용하면 더 간결하게 표현할 수 있다.

- **상황:** 주어진 정수 배열에서 최솟값, 최댓값, 합계를 동시에 구하여 반환하고 싶다.
- **적용:** 반환 타입을 `std::tuple<int, int, int>`로 지정하고, 세 값을 묶어 반환한다.

### 코드 예시
```cpp
#include <vector>
#include <numeric> // std::accumulate
#include <algorithm> // *min_element, *max_element

std::tuple<int, int, int> getStats(const std::vector<int>& data) {
    if (data.empty()) {
        return {0, 0, 0};
    }
    int minVal = *std::min_element(data.begin(), data.end());
    int maxVal = *std::max_element(data.begin(), data.end());
    int sum = std::accumulate(data.begin(), data.end(), 0);
    return {minVal, maxVal, sum};
}
```

## 실전 예시: 구조화된 바인딩과 함께 사용
위에서 작성한 `getStats` 함수를 C++17의 구조화된 바인딩과 함께 사용하면, 반환된 튜플을 매우 직관적으로 처리할 수 있다.

- **문제 상황:** `getStats` 함수가 반환한 튜플의 각 값을 개별 변수에 저장하여 사용하고 싶다.
- **해결:** `auto [min, max, sum] = getStats(data);` 구문을 사용하여 튜플의 각 요소를 `min`, `max`, `sum` 변수에 자동으로 할당한다.

```cpp
#include <iostream>

int main() {
    std::vector<int> numbers = {10, 4, 25, 8, 15};

    // 함수 호출 및 구조화된 바인딩으로 결과 받기
    auto [minVal, maxVal, sumVal] = getStats(numbers);

    std::cout << "최솟값: " << minVal << std::endl;
    std::cout << "최댓값: " << maxVal << std::endl;
    std::cout << "합계: " << sumVal << std::endl;

    return 0;
}
```

## 마치며
`std::tuple`은 여러 타입의 데이터를 임시적으로 묶어서 다룰 때 매우 강력하고 유연한 도구이다. 특히 C++17의 구조화된 바인딩과 함께 사용될 때 그 진가가 드러나며, 코드를 더 깔끔하고 읽기 쉽게 만들어준다. 함수에서 여러 값을 반환해야 하거나, 다양한 타입의 데이터를 함께 관리해야 할 때 `std::tuple`을 적극적으로 활용하는 것을 기억해두자.

---

*작성일: 2025.09.16*<br/>
*작성자: Cho Donghyun*
