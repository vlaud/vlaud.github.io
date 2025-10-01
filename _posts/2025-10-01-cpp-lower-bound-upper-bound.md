---
layout: post
title: "C++ 이진 탐색: lower_bound와 upper_bound 정복하기"
date: 2025-10-01
categories: [Algorithm, STL]
tags: [cplusplus, Algorithm, "binary-search", "lower-bound", "upper-bound"]
---

C++의 `<algorithm>` 헤더에는 정렬된 시퀀스를 효율적으로 다룰 수 있는 강력한 도구들이 포함되어 있다. 그중 `std::lower_bound`와 `std::upper_bound`는 이진 탐색(Binary Search)을 기반으로 동작하는 핵심 함수다. 이 두 함수를 사용하면 `O(log n)`의 시간 복잡도로 원하는 데이터의 위치를 빠르고 정확하게 찾을 수 있다.

이 포스트에서는 `lower_bound`와 `upper_bound`의 개념과 차이점, 그리고 실전 활용법을 알아본다.

## 전제 조건: 정렬

`lower_bound`와 `upper_bound`를 사용하기 위한 **가장 중요한 전제 조건은 탐색 대상 범위가 반드시 정렬되어 있어야 한다는 것**이다. 만약 데이터가 정렬되어 있지 않다면, 함수의 동작을 보장할 수 없으며 완전히 잘못된 결과를 반환한다.

## `std::lower_bound`

`lower_bound`는 정렬된 범위 `[first, last)`에서 주어진 `value` **이상이 되는 첫 번째 원소**의 반복자(iterator)를 반환한다.

-   **정의**: `value`보다 작지 않은(not less than) 첫 번째 원소를 찾는다. 즉, `value <= element`를 만족하는 첫 번째 `element`를 찾는다.
-   **결과**:
    1.  범위 내에 `value`와 일치하는 원소가 있다면, 그중 **가장 첫 번째 원소**를 가리킨다.
    2.  `value`와 일치하는 원소가 없다면, `value`보다 **큰 첫 번째 원소**를 가리킨다. (정렬 순서상 `value`가 삽입될 수 있는 위치)
    3.  범위 내의 모든 원소가 `value`보다 작다면, 범위의 끝(last)을 가리키는 반복자를 반환한다.

### 코드 예시

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <iterator>

int main() {
    std::vector<int> v = {10, 20, 30, 30, 30, 40, 50};

    // 1. 값 30을 찾는다.
    auto it_lower = std::lower_bound(v.begin(), v.end(), 30);
    // it_lower는 첫 번째 30을 가리킨다 (인덱스 2).
    size_t index = std::distance(v.begin(), it_lower);
    std::cout << "30의 lower_bound 위치: " << index << std::endl; // 출력: 2

    // 2. 값 35를 찾는다.
    auto it_lower2 = std::lower_bound(v.begin(), v.end(), 35);
    // 35는 없으므로, 35 이상인 첫 원소 40을 가리킨다 (인덱스 5).
    size_t index2 = std::distance(v.begin(), it_lower2);
    std::cout << "35의 lower_bound 위치: " << index2 << std::endl; // 출력: 5

    return 0;
}
```

## `std::upper_bound`

`upper_bound`는 정렬된 범위 `[first, last)`에서 주어진 `value`**를 초과하는 첫 번째 원소**의 반복자를 반환한다.

-   **정의**: `value`보다 큰(greater than) 첫 번째 원소를 찾는다. 즉, `value < element`를 만족하는 첫 번째 `element`를 찾는다.
-   **결과**: `value`와 같은 값이 있든 없든 상관없이, `value`보다 큰 첫 번째 원소의 위치를 가리킨다.

### 코드 예시

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <iterator>

int main() {
    std::vector<int> v = {10, 20, 30, 30, 30, 40, 50};

    // 1. 값 30을 찾는다.
    auto it_upper = std::upper_bound(v.begin(), v.end(), 30);
    // it_upper는 30을 초과하는 첫 원소인 40을 가리킨다 (인덱스 5).
    size_t index = std::distance(v.begin(), it_upper);
    std::cout << "30의 upper_bound 위치: " << index << std::endl; // 출력: 5

    // 2. 값 35를 찾는다.
    auto it_upper2 = std::upper_bound(v.begin(), v.end(), 35);
    // 35를 초과하는 첫 원소인 40을 가리킨다 (인덱스 5).
    size_t index2 = std::distance(v.begin(), it_upper2);
    std::cout << "35의 upper_bound 위치: " << index2 << std::endl; // 출력: 5
}
```

## 실전 활용: 특정 값의 개수 세기

`lower_bound`와 `upper_bound`를 함께 사용하면 정렬된 범위에서 특정 값의 개수를 매우 효율적으로 계산할 수 있다.

-   `lower_bound(value)`: `value`가 시작되는 위치
-   `upper_bound(value)`: `value`가 끝나는 위치의 바로 다음 위치

따라서 두 반복자 간의 거리가 바로 `value`의 개수가 된다.

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <iterator>

int main() {
    std::vector<int> v = {10, 20, 30, 30, 30, 40, 50};

    auto it_lower = std::lower_bound(v.begin(), v.end(), 30);
    auto it_upper = std::upper_bound(v.begin(), v.end(), 30);

    // 두 반복자 사이의 거리를 계산하여 30의 개수를 구한다.
    auto count = std::distance(it_lower, it_upper);

    std::cout << "벡터에 포함된 30의 개수: " << count << std::endl; // 출력: 3

    return 0;
}
```

참고로, 이 두 작업을 한 번에 수행하는 `std::equal_range` 함수도 있다. 이 함수는 `lower_bound`와 `upper_bound` 결과를 `std::pair`로 묶어 반환한다.

## 마치며

`std::lower_bound`와 `std::upper_bound`는 정렬된 데이터를 다룰 때 필수적인 함수다. 두 함수의 미묘한 차이점(`>=` vs `>`)을 정확히 이해하면, 이진 탐색을 직접 구현할 필요 없이 간결하고 효율적인 코드를 작성할 수 있다. 특히 특정 원소의 존재 여부 확인, 삽입 위치 결정, 값의 개수 파악 등 다양한 상황에서 유용하게 활용할 수 있으므로 반드시 숙지해두는 것이 좋다.

---

*작성일: 2025.10.01*<br/>
*작성자: Cho Donghyun*
