---
layout: post
title: "C++23 views::chunk_by - 개념과 예시"
date: 2025-07-19
categories: [STL]
tags: [cplusplus, cplusplus23, ranges, views, chunk_by]
---

## 개념
`std::views::chunk_by`는 C++23 레인지(range) 라이브러리에 추가된 기능으로, 특정 조건을 만족하는 연속된 요소들을 하나의 그룹(chunk)으로 묶어주는 뷰(view)를 생성한다.

- **주요 특징:** 이항 조건자(binary predicate)를 사용하여 인접한 두 요소가 특정 관계를 만족하는 동안 하나의 청크로 묶는다. 조건자가 `false`를 반환하면 새로운 청크가 시작된다.
- **다른 개념과의 차이점:** `views::chunk`가 고정된 크기로 레인지를 나누는 반면, `views::chunk_by`는 데이터 자체의 속성에 따라 동적으로 청크의 크기를 결정한다.
- **대표적인 예:** 로그 파일에서 동일한 타입의 로그 메시지를 그룹화하거나, 정렬된 데이터에서 같은 값을 갖는 요소들을 묶는 데 사용될 수 있다.

## 주요 원리
`chunk_by`는 두 개의 인자를 받는다.
1.  **원본 데이터 레인지(range):** 그룹으로 묶을 요소들이 담긴 레인지.
2.  **이항 조건자(binary predicate):** 인접한 두 요소를 인자로 받아 `true` 또는 `false`를 반환하는 함수.

`chunk_by`는 이 조건자를 인접한 모든 요소 쌍에 대해 순서대로 적용한다. 만약 조건자가 `false`를 반환하면, 해당 위치에서 그룹을 나눈다.

## 예시: 홀/짝으로 숫자 그룹화
주어진 정수 벡터에서 각 요소의 '홀/짝' 여부가 같은 경우에만 같은 그룹으로 묶는 예시를 통해 `chunk_by`의 동작을 살펴보자.

- **예시 상황:** `{1, 3, 2, 4, 6, 5, 7, 9, 8}`와 같이 정수가 섞여 있는 벡터가 있다.
- **적용 개념:** `chunk_by`와 홀/짝 여부를 비교하는 조건자를 사용하여, 연속된 홀수 그룹과 연속된 짝수 그룹으로 나눈다.

### 코드 예시
```cpp
#include <iostream>
#include <vector>
#include <ranges>

// 출력용 헬퍼 함수
void print_chunk(const auto& chunk) {
    std::cout << "[ ";
    for (const auto& elem : chunk) {
        std::cout << elem << " ";
    }
    std::cout << "] ";
}

int main() {
    std::vector<int> numbers = {1, 3, 2, 4, 6, 5, 7, 9, 8};

    // 두 숫자의 홀/짝 여부가 같은지 확인하는 람다 함수
    auto same_parity = [](int a, int b) {
        return (a % 2) == (b % 2);
    };

    // chunk_by를 사용하여 '홀/짝'이 같은 연속된 숫자들을 그룹으로 묶는다.
    auto chunks = numbers | std::views::chunk_by(same_parity);

    std::cout << "원본 벡터: ";
    for (int n : numbers) {
        std::cout << n << " ";
    }
    std::cout << std::endl;

    std::cout << "chunk_by 결과: ";
    for (const auto& chunk : chunks) {
        print_chunk(chunk);
    }
    std::cout << std::endl;

    return 0;
}
```

### 코드 설명
1.  `numbers` 벡터: `{1, 3, 2, 4, 6, 5, 7, 9, 8}`
2.  `same_parity` 람다 함수: 두 정수를 받아 두 수의 홀/짝 여부가 같으면 `true`, 다르면 `false`를 반환한다.
3.  `numbers | std::views::chunk_by(same_parity)`: `chunk_by`가 `numbers` 벡터의 인접한 요소들을 `same_parity`로 검사한다.
    - `1`과 `3`: 둘 다 홀수. `same_parity(1, 3)` -> `true`. 같은 그룹.
    - `3`과 `2`: 홀수와 짝수. `same_parity(3, 2)` -> `false`. 여기서 그룹이 나뉜다. 첫 번째 그룹은 `{1, 3}`.
    - `2`와 `4`: 둘 다 짝수. `same_parity(2, 4)` -> `true`. 같은 그룹.
    - `4`와 `6`: 둘 다 짝수. `same_parity(4, 6)` -> `true`. 같은 그룹.
    - `6`과 `5`: 짝수와 홀수. `same_parity(6, 5)` -> `false`. 여기서 그룹이 나뉜다. 두 번째 그룹은 `{2, 4, 6}`.
    - `5`와 `7`: 둘 다 홀수. `same_parity(5, 7)` -> `true`. 같은 그룹.
    - `7`과 `9`: 둘 다 홀수. `same_parity(7, 9)` -> `true`. 같은 그룹.
    - `9`과 `8`: 홀수와 짝수. `same_parity(9, 8)` -> `false`. 여기서 그룹이 나뉜다. 세 번째 그룹은 `{5, 7, 9}`.
    - 마지막 요소 `8`은 혼자 네 번째 그룹 `{8}`이 된다.

### 실행 결과
```
원본 벡터: 1 3 2 4 6 5 7 9 8
chunk_by 결과: [ 1 3 ] [ 2 4 6 ] [ 5 7 9 ] [ 8 ]
```

## 마치며
`views::chunk_by`는 데이터의 연속적인 특징을 기준으로 레인지를 동적으로 분할할 수 있는 강력한 도구이다. 데이터를 특정 조건에 따라 그룹으로 묶어 처리해야 할 때 매우 유용하며, 코드의 가독성과 표현력을 높여준다.

---

*작성일: 2025.07.19*<br/>
*작성자: Cho Donghyun*
