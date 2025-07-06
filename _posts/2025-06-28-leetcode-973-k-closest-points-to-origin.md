---
layout: post
title: "[LeetCode 973] K Closest Points to Origin"
date: 2025-06-28
categories: [Algorithm, LeetCode]
tags: [Algorithm, LeetCode, QuickSelect, 3-way-partitioning, Sorting]
---

<a href="https://leetcode.com/problems/k-closest-points-to-origin/" style="font-size:1.5em;"><b>문제 링크</b></a>

## 문제 설명<br/><br/>
`points` 배열이 주어지는데, 각 `points[i] = [xi, yi]`는 2D 평면의 한 점을 나타낸다. 정수 `k`가 함께 주어질 때, 원점 `(0, 0)`에서 가장 가까운 `k`개의 점들을 반환해야 한다. 두 점 사이의 거리는 유클리드 거리를 사용한다. 반환되는 점들의 순서는 상관없다.<br/><br/>

**입력 예시:** `points = [[1,3],[-2,2]], k = 1`<br/><br/>
**출력 예시:** `[[-2,2]]` <br/><br/>
**제약:**
- `1 ≤ k ≤ points.length ≤ 10⁴`
- `-10⁴ ≤ xi, yi ≤ 10⁴`

## 풀이 전략<br/><br/>
**핵심 아이디어:** Quickselect 알고리즘과 3-way partitioning을 결합하여, 평균적으로 O(N) 시간 복잡도로 원점에서 k번째로 가까운 점을 찾는다. k번째 점을 찾으면, 그 점보다 거리가 짧거나 같은 점들을 반환한다.<br/><br/>

**Quickselect를 사용한 이유:**
- **효율성:** 전체 배열을 정렬하는 `O(N log N)`보다 훨씬 빠르다. 상위 k개의 점만 찾으면 된다.
- **In-place:** 추가적인 메모리 사용을 최소화하면서 배열 자체를 재정렬하여 문제를 해결할 수 있다.

**구체적 방법:**
1.  **피벗(Pivot) 선택:** 임의의 점을 피벗으로 선택하고, 원점으로부터의 거리를 계산한다.
2.  **3-way Partitioning:**
    - 피벗보다 거리가 짧은 점들은 왼쪽
    - 피벗과 거리가 같은 점들은 중앙
    - 피벗보다 거리가 긴 점들은 오른쪽
    으로 배열을 재배치
3.  **재귀적 탐색:**
    - 만약 `k`가 왼쪽 파티션의 크기보다 작거나 같으면, 왼쪽 파티션에서 다시 Quickselect를 수행
    - 만약 `k`가 왼쪽과 중앙 파티션을 합친 크기보다 작거나 같으면, k개의 점을 모두 찾은 것이므로 탐색을 종료
    - 그렇지 않다면, 오른쪽 파티션에서 `k - (왼쪽 + 중앙 파티션 크기)` 만큼의 점을 더 찾기 위해 Quickselect를 수행
4.  **결과 반환:** Quickselect가 종료되면, 배열의 첫 k개의 원소가 원점에서 가장 가까운 k개의 점들이 된다.

<br/>

## c++ 코드
```cpp{% raw %}
class Solution {
using ll = long long;
using int2d = vector<vector<int>>;
using iPair = pair<int, int>;
public:
    vector<vector<int>> kClosest(vector<vector<int>>& points, int k) {
        quickselect(points, 0, points.size()-1, k);
        int2d res;
        for (int i =0; i <k; i++) res.push_back(points[i]);
        return res;
    }
    iPair partition(int2d& p, int l, int r){
        int pivot = dist(p[(l+r)/2]);
        int m = l;

        while (m<=r){
            int d = dist(p[m]);
            if (d < pivot) swap(p[l++], p[m++]);
            else if (d == pivot) m++;
            else swap(p[m], p[r--]);
        }
        return {l,m};
    }
    void quickselect(vector<vector<int>>& p, int l, int r, int k){
        while (l<=r){
            auto [lc, m] = partition(p,l,r);
            if (lc > k) r = lc-1;
            else if (m >k) break;
            else l = m;
        }
    }
    ll dist(vector<int>& p){
        return 1ll*p[0]*p[0]+1ll*p[1]*p[1];
    }
};{% endraw %}
```

## 해설
- 단계별 과정:
    1. `quickselect` 함수는 `l`과 `r` 인덱스 사이의 `points` 배열 일부에 대해 Quickselect를 수행한다.
    2. `partition` 함수는 `(l+r)/2` 위치의 점을 피벗으로 선택하고, 3-way partitioning을 수행한다. 이 함수는 두 개의 인덱스 `(lc, m)`을 반환하는데, `lc`는 피벗보다 작은 원소들의 마지막 위치 다음을, `m`은 피벗과 같은 원소들의 마지막 위치 다음을 가리킨다.
    3. `quickselect`는 `partition`의 결과에 따라 탐색 범위를 좁혀 나간다.
        - `lc > k`이면, k번째 점이 왼쪽 파티션에 있으므로 `r = lc - 1`로 범위를 줄임
        - `m > k`이면, k번째 점이 중앙 파티션 어딘가에 포함되므로, 이미 k개의 가장 가까운 점을 찾은 상태이므로 탐색 종료
        - 그 외의 경우, k번째 점은 오른쪽 파티션에 있으므로 `l = m`으로 범위를 줄여 오른쪽 파티션만 탐색
    4. 이 과정이 끝나면 `points` 배열의 앞쪽 `k`개 원소는 원점에서 가장 가까운 점들이 된다.

## 시간복잡도
- **평균:** O(N)
  - Quickselect는 매 단계에서 탐색 범위를 절반 가까이 줄여나가므로, 평균적으로 `N + N/2 + N/4 + ... = 2N`에 가까운 연산을 수행
- **최악:** O(N²)
  - 매번 피벗을 최악의 경우(가장 작거나 가장 큰 원소)로 선택하게 되면 발생할 수 있지만, 피벗을 무작위로 선택하거나 중앙값으로 선택함으로써 거의 항상 피할 수 있음

## 공간복잡도
- **O(1)**
  - Quickselect는 주어진 배열 내에서 정렬(in-place)하므로, 추가적인 메모리를 거의 사용하지 않음
  - 재귀 호출에 따른 스택 공간이 필요하지만, `while` 루프로 구현하여 더 최적화함

## 마치며
Quickselect와 3-way partitioning을 이용한 풀이는 LeetCode 973번 문제를 매우 효율적으로 해결하는 방법이다.<br/>
단순히 모든 점을 정렬하는 것보다 훨씬 빠른 성능을 보여주며, "상위 K개 선택" 문제에 대한 강력한 해결책임을 보여준다.<br/>
특히 데이터의 중복이 많을 경우 3-way partitioning은 2-way보다 더 효율적일 수 있다.

---

*작성일: 2025.06.28*<br/>
*작성자: Cho Donghyun*