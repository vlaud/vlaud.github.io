---
layout: post
title: "[LeetCode 994] Rotting Oranges"
date: 2025-06-28
categories: [Algorithm, LeetCode]
tags: [Algorithm, LeetCode, BFS, Queue, 자료구조]
---

<a href="https://leetcode.com/problems/rotting-oranges/" style="font-size:1.5em;"><b>문제 링크</b></a>

## 문제 설명<br/><br/>
신선한 오렌지가 썩은 오렌지에 의해 썩어가는 최소 시간 구하기 <br/><br/>

<!-- 백틱: `grid[i][j]`(각 배열의 원소)는 0, 1 이나 2이다.-->
<!-- 이스케이프: grid\[i\]\[j\](각 배열의 원소)는 0, 1 이나 2이다.-->
**입력 예시:** `grid = [[2,1,1],[1,1,0],[0,1,1]]`<br/><br/>
**출력 예시:** `4` <br/><br/>
**제약:**
- `m(행의 길이) == grid.length` 
- `n(열의 길이) == grid[i].length`
- `1 <= m, n <= 10`
- `grid[i][j](각 배열의 원소)는 0, 1 이나 2이다.`<br/><br/>

## 풀이 전략<br/><br/>
**핵심 아이디어:** BFS(너비 우선 탐색)을 통해 썩은 오렌지부터 확산<br/><br/>
**BFS 사용 이유:** 최단 시간을 구해야 하기 때문에<br/><br/>
**구체적 방법:**
- 썩은 오렌지(2)를 큐에 넣음
- 각 단계마다 인접한 신선 오렌지(1)을 썩게(2로 변환) 만든 후, 큐에 좌표 삽입
- 큐가 빌 때까지 반복

<br/>
<!-- {% raw %} 중괄호 {{}} {% endraw %} -->
## c++ 코드
```cpp{% raw %}
class Solution {
// 좌표 r,c와 time을 넣는 큐
using timeQ = queue<pair<pair<int,int>, int>>; 
public:
    int orangesRotting(vector<vector<int>>& grid) {
        const int m = grid.size(), n = grid[0].size();
        int res = 0;
        timeQ q;

        // 그리드 내의 썩은 오렌지를 큐에 삽입(좌표, 시간 0)
        for (int i = 0; i < m; i++){
            for (int j = 0; j < n; j++){
                if (grid[i][j] == 2) q.push({{i,j}, 0});
            }
        }

        while(!q.empty()){
            // it (좌표), time(시갼)
            auto [it, time] = q.front(); 
            q.pop();

            // r : x축, c : y축
            int r = it.first, c = it.second; 

            res = max(res, time);
            for (int i = -1; i < 2; i+=2){
                int nr = r+i, nc = c+i;
                
                // 가능 범위 좌표에서 원소가 1이면 2로 바꾸고 큐에 좌표와, time+1 삽입
                if (0 <= nr && nr < m && grid[nr][c] == 1) {
                    grid[nr][c] = 2;
                    q.push({{nr,c},time+1});
                }
                if (0 <= nc && nc < n && grid[r][nc] == 1) {
                    grid[r][nc] = 2;
                    q.push({{r,nc},time+1});
                }
            }
        }

        // 여전히 1이 남아있으면 -1 반환
        for (int i = 0; i < m; i++){
            for (int j = 0; j < n; j++){
                if (grid[i][j] == 1) return -1;
            }
        }

        // res 반환
        return res;
    }
};{% endraw %}
```

## 해설
- 단계별 과정:
    1. 썩은 오렌지 위치를 큐에 저장
    2. BFS로 인접한 신선 오렌지들을 썩힘
    3. 각 단계마다 시간 카운트
    4. 모든 오렌지가 썩었는지 확인
- 예외 처리:
    - 고립된 신선 오렌지가 있는 경우 (-1 반환)

## 시간복잡도
- BFS: O(m * n) - 모든 셀을 한 번씩 방문

## 마치며
이 문제는 스택과 큐의 차이, 그리고 두 자료구조의 조합을 이해하는데 좋은 문제이다.<br/>
자료구조의 응용과 변환 방법을 이해할 수 있다.

---

*작성일: 2025.06.28*<br/>
*작성자: Cho Donghyun*