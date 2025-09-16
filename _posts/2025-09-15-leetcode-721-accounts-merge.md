---
layout: post
title: "[LeetCode 721] Accounts Merge"
date: 2025-09-15
categories: [Algorithm, LeetCode]
tags: [Algorithm, LeetCode, Graph, DFS, Union-Find, cplusplus]
---

<a href="https://leetcode.com/problems/accounts-merge/" style="font-size:1.5em;"><b>문제 링크</b></a>

## 문제 설명

여러 개의 계정 정보가 주어진다. 각 계정은 이름과 여러 개의 이메일 주소로 구성된다. 만약 두 계정이 하나라도 동일한 이메일 주소를 공유한다면, 두 계정은 동일한 사용자의 것으로 간주하여 하나로 병합해야 한다.

최종적으로 병합된 계정 목록을 반환해야 하며, 각 계정의 첫 번째 요소는 이름, 나머지 요소는 알파벳순으로 정렬된 이메일 목록이어야 한다.

**입력 예시:**
`accounts = [["John","johnsmith@mail.com","john_newyork@mail.com"],["John","johnsmith@mail.com","john00@mail.com"],["Mary","mary@mail.com"],["John","johnnybravo@mail.com"]]`

**출력 예시:**
`[["John","john00@mail.com","john_newyork@mail.com","johnsmith@mail.com"],["Mary","mary@mail.com"],["John","johnnybravo@mail.com"]]`

**제약:**
- `1 <= accounts.length <= 1000`
- `2 <= accounts[i].length <= 10`
- `1 <= accounts[i][j].length <= 30`
- `accounts[i][0]`는 영문자로만 구성된다.
- `accounts[i][j]` (j > 0)는 유효한 이메일 주소다.

---

이 문제는 본질적으로 **그래프에서 연결된 컴포넌트(Connected Components)를 찾는 것**과 동일하다. 각 이메일 주소를 그래프의 노드(Node)로 보고, 같은 계정에 속한 이메일들 사이에 간선(Edge)이 있다고 생각할 수 있다. 이 아이디어를 바탕으로 두 가지 대표적인 풀이법인 **Union-Find**와 **DFS**를 적용할 수 있다.

## 풀이 1: Union-Find (Disjoint Set Union)

### 풀이 전략
**핵심 아이디어:** Union-Find 자료구조를 사용하여 이메일들을 그룹으로 묶는다.

**사용 이유:** Union-Find는 여러 노드를 서로소 집합(Disjoint Sets)으로 관리하고, 두 노드가 같은 집합에 속하는지 빠르게 확인하거나 두 집합을 합치는 연산에 매우 효율적이다. 이메일들을 같은 그룹으로 묶는 이 문제에 안성맞춤이다.

**구체적 방법:**
1.  이메일 주소에 인덱스를 매핑하는 맵(map)과 Union-Find 자료구조를 선언한다. `(이메일 -> ID)`
2.  모든 계정을 순회하면서, 계정이 이미 해시맵에 존재하면 현재 인덱스와 이메일의 ID를 합치고(union), 그렇지 않으면 새로 추가한다.
3.  부모의 값이 같은 이메일들을 저장하는 벡터를 선언, 해시맵을 순회하며 ID들의 부모를 찾아, 그 부모의 인덱스 위치에 이메일 목록을 추가한다.
4.  다시 부모의 값이 같은 이메일 목록들을 순회하며, 알파벳순으로 정렬하고, 각 목록의 맨 앞에 계정 이름을 추가하여 최종 결과를 만든다.

### C++ 코드
```cpp
class UnionFind {
private:
    vector<int> parent, size;
public:
    UnionFind(int n) {
        parent.resize(n);
        iota(parent.begin(), parent.end(), 0); // 각 노드가 자기 자신을 부모로 초기화
        size.resize(n,1); // 각 노드의 크기를 1로 초기화
    }

    int find(int x) {
        if (x != parent[x]) parent[x] = find(parent[x]); // 경로 압축

        return parent[x]; // 최종 부모 반환
    }

    void unite(int a, int b) {
        a = find(a), b = find(b); // 부모 찾기

        if (a == b) return; // 부모가 같으면 빠져나가기 
        if (size[a] < size[b]) swap(a,b); // 더 큰 노드에 작은 노드 합치기

        parent[b] = a; // 부모 업데이트

        size[a] += size[b]; // 크기 업데이트
    }
};

class Solution {
public:
    vector<vector<string>> accountsMerge(vector<vector<string>>& accounts) {
        const int n = accounts.size();
        UnionFind uf(n); // Union-Find 초기화
        unordered_map<string, int> email_to_id; // 이메일을 ID로 매핑
        
        // 1. accounts 안의 이메일들을 탐색하며, 해시맵에 존재하면 현재 인덱스와 이메일의 ID를 합치고, 그렇지 않으면 새로 추가한다.
        for (int i = 0; i < n; i++) {
            for (int j = 1; j < accounts[i].size(); ++j) {
                const string& email = accounts[i][j];
                if (email_to_id.find(email) == email_to_id.end()) email_to_id[email] = i; // 존재하지 않으면 추가
                else uf.unite(i, email_to_id[email]); // 존재하면 합치기
            }
        }

        // 2. 해시맵의 키(이메일)과 값(ID)들을 순회하며 ID들의 부모를 찾아, parents[parent_id]에 이메일을 추가한다.
        vector<vector<string>> parents(n);
        for (const auto& [e, i] : email_to_id) {
            int parent_id = uf.find(i); // 부모 찾기
            parents[parent_id].push_back(e); // 이메일 추가
        }

        // 3. 결과를 형식에 맞게 변환한다.
        vector<vector<string>> result;
        for (int i = 0; i < n; i++) {
            if (parents[i].empty()) continue; // parents[i]가 비어있으면 스킵

            sort(parents[i].begin(), parents[i].end()); // 알파벳순 정렬

            result.push_back({accounts[i][0]}); // 계정 이름 추가
            result.back().insert(result.back().end(), parents[i].begin(), parents[i].end()); // 이메일 목록 추가
        }

        return result;
    }
};
```

---

## 풀이 2: DFS (Depth-First Search)

### 풀이 전략
**핵심 아이디어:** 이메일들을 노드로 하는 그래프를 명시적으로 구성하고, DFS를 사용하여 연결된 모든 노드(이메일)를 찾는다.

**사용 이유:** DFS는 그래프의 한 정점에서 시작하여 연결된 모든 정점을 탐색하는 표준적인 방법이다. 이 문제에서 연결된 이메일 그룹을 찾는 데 자연스럽게 적용할 수 있다.

**구체적 방법:**
1.  각 계정 목록의 첫 번째 이메일을 기준으로 나머지 이메일들을 별 모양으로 연결한다. `(첫 번째 이메일 -> 나머지 이메일들)`
2.  방문한 이메일을 추적하기 위한 `visited` 집합(set)을 만든다.
3.  모든 이메일을 순회하면서, 아직 방문하지 않은 이메일이 있다면 그 이메일을 시작점으로 DFS를 수행한다.
4.  DFS는 현재 이메일과 연결된 모든 이메일을 재귀적으로 탐색하며, 하나의 연결된 컴포넌트(즉, 하나의 병합된 계정)를 구성하는 모든 이메일을 찾는다.
5.  한 번의 DFS가 끝나면 하나의 병합된 계정에 속한 이메일 목록이 완성된다. 이 목록을 정렬하고 계정 이름을 찾아 맨 앞에 추가한다.
6.  모든 이메일을 방문할 때까지 4-6번 과정을 반복한다.

### C++ 코드
```cpp
class Solution {
public:
    unordered_map<string, vector<string>> adjacent;
    unordered_set<string> visited;
    vector<vector<string>> accountsMerge(vector<vector<string>>& accounts) {
        const int n = accounts.size();

        // 그래프 별모양으로 연결
        for (auto& e : accounts){
            string e1 = e[1];

            for (int j = 2; j < e.size(); j++){
                string email = e[j];
                adjacent[e1].push_back(email);
                adjacent[email].push_back(e1);
            }
        }

        vector<vector<string>> mgs;
        for (auto& ac : accounts){
            string acName = ac[0];
            string ac1 = ac[1];

            if (!visited.count(ac1)){
                vector<string> mg;
                mg.push_back(acName);
                dfs(mg, ac1);
                sort(mg.begin() + 1, mg.end());
                mgs.push_back(mg);
            }
        }

        return mgs;
    }

    void dfs(vector<string>& merge, string& email){
        visited.insert(email);
        merge.push_back(email);

        for (auto& n : adjacent[email]){
            if (!visited.count(n)){
                dfs(merge, n);
            }
        }
    }
};
```

## 시간 복잡도 분석
- `N`을 총 계정의 수, `K`를 계정 내 이메일의 최대 수, `M`을 총 이메일의 수라고 하자.

- **Union-Find:**
    - 이메일 매핑 및 Union-Find 초기화: O(N*K)
    - Union 연산: O(N*K * α(M)), 여기서 α는 아커만 함수의 역함수로 거의 상수 시간에 가깝다.
    - 그룹화 및 정렬: O(M log M) (이메일 정렬이 지배적)
    - **총 시간 복잡도:** O(N*K + M log M)

- **DFS:**
    - 그래프 구성: O(N*K)
    - DFS 탐색: 각 노드와 간선을 한 번씩 방문하므로 O(N*K)
    - 정렬: O(M log M)
    - **총 시간 복잡도:** O(N*K + M log M)

<br/>
DFS는 구현이 직관적이고, Union-Find는 이메일-계정 연결 관리가 깔끔하다.<br/>
성능적으로는 큰 차이는 없으며, 주어진 입력 크기에서 정렬이 병목한다.

## 마치며
Accounts Merge 문제는 그래프의 연결된 컴포넌트를 찾는 문제로 귀결된다는 것을 파악하는 것이 핵심이다. 이 문제를 통해 Union-Find와 DFS라는 두 가지 강력한 도구를 동일한 문제에 어떻게 적용하고 비교할 수 있는지 배울 수 있다. Union-Find는 특히 이런 종류의 "그룹화" 또는 "연결성 확인" 문제에서 매우 강력하고 효율적인 해결책을 제공한다는 점을 기억해두면 좋다.

---

*작성일: 2025.09.15*<br/>
*작성자: Cho Donghyun*
