---
layout: post
title: "위상 정렬 (Topological Sort) 개념과 구현"
date: 2025-10-01
categories: [Algorithm]
tags: [Algorithm, graph, "topological-sort", dag, cplusplus]
---

위상 정렬(Topological Sort)은 방향 그래프(Directed Graph)에 존재하는 정점(Vertex)들을 선형으로 나열하는 것을 의미한다. 이때, 그래프의 모든 간선(Edge) `u -> v`에 대해 정점 `u`가 정점 `v`보다 반드시 앞에 위치해야 한다.

이 알고리즘은 주로 **의존성**을 갖는 작업들의 순서를 결정하는 데 사용된다. 예를 들어, 대학교의 선수과목 구조나 프로젝트의 빌드 순서 등이 대표적인 예시다. A를 해야만 B를 할 수 있다면, 위상 정렬 결과에서 A는 항상 B보다 앞에 나타난다.

중요한 점은 위상 정렬은 **사이클(Cycle)이 없는 방향 그래프(DAG, Directed Acyclic Graph)**에서만 수행할 수 있다는 것이다. 만약 그래프에 사이클이 존재한다면(예: A->B, B->C, C->A), 작업 순서를 정하는 것 자체가 불가능하므로 위상 정렬 또한 정의될 수 없다.

## 핵심 개념

위상 정렬을 이해하기 위해 두 가지 개념을 알아야 한다.

-   **진입 차수 (In-degree)**: 한 정점으로 들어오는 간선의 개수. 진입 차수가 0인 정점은 선행 작업이 없는, 가장 먼저 시작할 수 있는 정점임을 의미한다.
-   **진출 차수 (Out-degree)**: 한 정점에서 나가는 간선의 개수.

위상 정렬 알고리즘은 주로 진입 차수를 이용하여 구현된다.

## 위상 정렬 알고리즘 (칸 알고리즘, Kahn's Algorithm)

가장 널리 사용되는 위상 정렬 알고리즘은 큐(Queue)를 사용하는 칸(Kahn)의 알고리즘이다. 동작 방식은 다음과 같다.

1.  **진입 차수 계산**: 그래프의 모든 정점에 대해 각각의 진입 차수를 계산한다.
2.  **큐 초기화**: 진입 차수가 0인 모든 정점을 큐에 넣는다. 이 정점들이 바로 시작점이 된다.
3.  **정렬 수행**:
    - 큐가 빌 때까지 다음 과정을 반복한다.
    - a. 큐에서 정점 `u`를 하나 꺼내 결과 리스트에 추가한다.
    - b. `u`에서 나가는 모든 간선 `u -> v`를 제거한다. 실제 간선을 지우는 대신, 연결된 정점 `v`의 진입 차수를 1씩 감소시킨다.
    - c. 진입 차수가 0이 된 정점 `v`가 있다면, 해당 정점을 큐에 추가한다. (선행 작업이 모두 완료되었으므로 이제 수행할 수 있다는 의미)
4.  **사이클 확인**: 모든 과정이 끝난 후, 결과 리스트에 포함된 정점의 수가 전체 정점의 수와 다르다면 그래프에 사이클이 존재하는 것이다. 같다면, 결과 리스트가 위상 정렬의 결과가 된다.

## C++ 구현 예시

칸 알고리즘을 C++로 구현한 예시는 다음과 같다.

```cpp
#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>

// 그래프와 정점의 수를 받아 위상 정렬 결과를 반환하는 함수
std::vector<int> topological_sort(int num_vertices, std::vector<std::vector<int>>& adj) {
    // 1. 진입 차수 계산
    std::vector<int> in_degree(num_vertices + 1, 0);
    for (int u = 1; u <= num_vertices; ++u) {
        for (int v : adj[u]) {
            in_degree[v]++;
        }
    }

    // 2. 진입 차수가 0인 정점을 큐에 추가
    std::queue<int> q;
    for (int i = 1; i <= num_vertices; ++i) {
        if (in_degree[i] == 0) {
            q.push(i);
        }
    }

    std::vector<int> result;

    // 3. 큐가 빌 때까지 반복
    while (!q.empty()) {
        int u = q.front();
        q.pop();
        result.push_back(u); // 결과에 추가

        // 현재 정점 u와 연결된 정점들의 진입 차수 감소
        for (int v : adj[u]) {
            in_degree[v]--;
            // 진입 차수가 0이 되면 큐에 추가
            if (in_degree[v] == 0) {
                q.push(v);
            }
        }
    }

    // 4. 사이클 확인
    if (result.size() != num_vertices) {
        // 사이클이 존재하면 빈 벡터를 반환
        return {};
    }

    return result;
}

int main() {
    int num_vertices = 6;
    // 인접 리스트로 그래프 표현 (1-based index)
    std::vector<std::vector<int>> adj(num_vertices + 1);
    adj[5].push_back(2);
    adj[5].push_back(0); // 0번 정점은 없지만 예시를 위해 추가 (무시됨)
    adj[4].push_back(0);
    adj[4].push_back(1);
    adj[2].push_back(3);
    adj[3].push_back(1);
    // 정점 0은 사용하지 않는다고 가정하고, 1~6번 정점 사용
    // 예시 그래프: 5->2, 4->1, 2->3, 3->1
    // (5,4) -> 2 -> 3 -> 1

    // 위상 정렬 수행
    std::vector<int> sorted_order = topological_sort(num_vertices, adj);

    if (sorted_order.empty()) {
        std::cout << "그래프에 사이클이 존재합니다." << std::endl;
    } else {
        std::cout << "위상 정렬 결과: ";
        for (int vertex : sorted_order) {
            // 0번 정점은 없으므로 출력에서 제외
            if(vertex != 0) std::cout << vertex << " ";
        }
        std::cout << std::endl;
    }

    return 0;
}
```
*위 코드에서 정점 0은 사용되지 않는다고 가정하여, `main` 함수에서 `adj` 리스트를 1-based index에 맞게 수정하고, 출력 시 0을 제외하는 로직을 추가해야 정확한 결과를 볼 수 있다. 위 예제는 칸 알고리즘의 기본 구조를 보여주는 데 초점을 맞추었다.*

## 또 다른 접근법: DFS

위상 정렬은 깊이 우선 탐색(DFS)으로도 구현할 수 있다. 

1.  모든 정점에 대해 DFS를 수행한다.
2.  DFS 탐색이 완전히 종료된 정점(자신과 연결된 모든 정점을 방문한 후)을 스택(Stack)에 추가한다.
3.  모든 정점에 대한 탐색이 끝나면, 스택에 쌓인 정점을 순서대로 꺼낸다. 이 순서가 바로 위상 정렬의 역순이 되며, 따라서 스택에서 꺼낸 순서가 위상 정렬 결과가 된다.

## 마치며

위상 정렬은 방향성이 있는 작업의 순서를 정하는 데 있어 매우 중요한 알고리즘이다. 칸 알고리즘은 진입 차수를 이용해 직관적으로 이해하기 쉽고, DFS 기반 알고리즘 또한 재귀적인 탐색으로 문제를 해결할 수 있다. 어떤 의존성을 가진 문제에 직면했을 때, 위상 정렬을 떠올릴 수 있다면 문제 해결에 큰 도움이 될 것이다.

---

*작성일: 2025.10.01*<br/>
*작성자: Cho Donghyun*
