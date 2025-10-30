---
layout: post
title: "Union-Find 최적화 - 경로 압축과 경로 절반화"
date: 2025-10-30
categories: [Algorithm, "Data Structure"]
tags: [Algorithm, "Data Structure", "Union-Find"]
---

## 개념
Union-Find는 서로소 집합(Disjoint Set)을 표현하는 자료구조로, 여러 원소가 주어졌을 때 이들을 몇 개의 그룹으로 나누고, 특정 원소가 어떤 그룹에 속해 있는지, 또는 두 원소가 같은 그룹에 속해 있는지를 효율적으로 판별하는 데 사용한다. `Union`과 `Find`라는 두 가지 핵심 연산으로 이루어진다.

- **Find:** 특정 원소 `x`가 속한 집합의 대표 원소(루트)를 찾는 연산이다.
- **Union:** 두 원소 `x`, `y`가 속한 집합을 하나로 합치는 연산이다.

이러한 연산의 효율성을 높이기 위해 **경로 압축(Path Compression)**과 **경로 절반화(Path Halving)** 같은 최적화 기법이 사용된다.

## Union-Find 최적화 기법

### 1. 경로 압축 (Path Compression)
`Find` 연산을 수행할 때, 경로 상의 모든 노드가 직접 루트를 가리키도록 갱신하는 기법이다. 이로 인해 트리의 높이가 크게 줄어들어, 이후의 `Find` 연산이 매우 빨라진다.

- **원리:** `Find(x)`를 호출하면, `x`에서부터 루트까지 거슬러 올라가면서 만나는 모든 노드의 부모를 최종적으로 발견한 루트로 설정한다.
- **장점:** `Find` 연산의 시간 복잡도를 거의 O(1)에 가깝게 만들어준다.

```cpp
// 경로 압축을 적용한 Find 연산
int find(int x) {
    // 부모가 자기 자신이면 루트이므로 반환
    if (parent[x] == x) {
        return x;
    }
    // 재귀적으로 루트를 찾고, 자신의 부모를 루트로 갱신
    return parent[x] = find(parent[x]);
}
```

### 2. 경로 절반화 (Path Halving)
경로 압축과 유사하지만, 경로 상의 모든 노드를 갱신하는 대신 한 칸씩 건너뛰며 부모를 갱신하는 방식이다.

- **원리:** `Find(x)`를 호출하면, `x`가 루트에 도달할 때까지 `parent[x] = parent[parent[x]]` 연산을 반복하여 경로를 절반으로 줄인다. 즉, 자신의 부모를 할아버지 노드로 바꾼다.
- **장점:** 재귀 호출 없이 반복문으로 구현할 수 있어 경로 압축보다 약간 더 간단하고, 성능도 유사하게 뛰어나다.

```cpp
// 경로 절반화를 적용한 Find 연산
int find(int x) {
    // x가 루트가 아닐 동안 반복
    while (x != parent[x]) {
        // 자신의 부모를 할아버지 노드로 변경
        parent[x] = parent[parent[x]];
        // x를 새로운 부모로 설정하여 위로 이동
        x = parent[x];
    }
    return x;
}
```

### 3. Union by Rank / Size
`Union` 연산을 최적화하는 기법으로, 두 트리를 합칠 때 높이가 낮은 트리(Rank)나 크기가 작은 트리(Size)를 다른 트리에 붙여 불필요하게 트리의 높이가 커지는 것을 방지한다.

- **Union by Rank:** 트리의 높이(rank)를 기준으로, 높이가 낮은 트리를 높은 트리 밑으로 붙인다.
- **Union by Size:** 트리의 노드 수(size)를 기준으로, 노드 수가 적은 트리를 많은 트리 밑으로 붙인다.

## 예시: 경로 절반화 코드

경로 절반화와 Union by Size를 함께 적용한 Union-Find 자료구조의 전체 코드는 다음과 같다.

```cpp
#include <vector>
#include <numeric>

class UnionFind {
public:
    // 생성자: n개의 원소로 초기화
    UnionFind(int n) : parent(n), size(n, 1) {
        // 각 원소의 부모를 자기 자신으로 초기화
        std::iota(parent.begin(), parent.end(), 0);
    }

    // Find 연산 (경로 절반화 적용)
    int find(int x) {
        while (x != parent[x]) {
            parent[x] = parent[parent[x]]; // 경로 절반화
            x = parent[x];
        }
        return x;
    }

    // Union 연산 (Union by Size 적용)
    void unite(int x, int y) {
        int rootX = find(x);
        int rootY = find(y);

        if (rootX != rootY) {
            // 크기가 작은 트리를 큰 트리에 붙인다
            if (size[rootX] < size[rootY]) {
                std::swap(rootX, rootY);
            }
            parent[rootY] = rootX;
            size[rootX] += size[rootY];
        }
    }

private:
    std::vector<int> parent; // 각 원소의 부모
    std::vector<int> size;   // 각 집합의 크기
};
```

## 마치며
Union-Find에서 경로 압축과 경로 절반화는 `Find` 연산의 효율을 극대화하는 핵심 최적화 기법이다. 특히 경로 절반화는 재귀 없이 간결하게 구현할 수 있으면서도 경로 압축에 버금가는 성능을 보여준다. Union by Rank/Size와 함께 이 기법들을 적용하면, Union-Find의 시간 복잡도는 거의 상수 시간에 가까워져(정확히는 아커만 함수 역함수) 매우 빠른 연산이 가능하다.

---

*작성일: 2025.10.30*<br/>
*작성자: Cho Donghyun*
