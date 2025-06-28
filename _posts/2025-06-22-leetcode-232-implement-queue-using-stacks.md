---
layout: post
title: "[LeetCode 232]  Implement Queue using Stacks"
date: 2025-06-22
categories: [Algorithm, LeetCode]
tags: [Algorithm, LeetCode, Stack, Queue, 자료구조]
---

<a href="https://leetcode.com/problems/implement-queue-using-stacks/" style="font-size:1.5em;"><b>문제 링크</b></a>

## 문제 설명
<br/>
스택 두 개를 이용해 큐(Queue)를 구현하라.
- `push(x)`: x를 큐의 뒤에 삽입
- `pop()`: 큐의 앞에서 원소 제거 및 반환
- `peek()`: 큐의 앞에 있는 원소 반환
- `empty()`: 큐가 비었는지 확인

**제약:**
- 오직 표준 스택 연산(`push`, `pop`, `top`, `empty`)만 사용할 수 있음

## 풀이 전략
<br/>
스택 2개(`inStack`, `outStack`)를 사용:
- `push`는 `inStack`에 삽입
- `pop`/`peek` 시 `outStack`이 비어있으면 `inStack`의 모든 원소를 `outStack`으로 옮김 (순서 반전)
- 그 후 `outStack`에서 pop/peek

이렇게 하면 큐의 FIFO(선입선출) 구조를 스택으로 구현할 수 있다.

## c++ 코드
```cpp
class MyQueue {
    stack<int> inStack, outStack;
public:
    MyQueue() {}

    void push(int x) {
        inStack.push(x);
    }

    int pop() {
        int val = peek();
        outStack.pop();
        return val;
    }

    int peek() {
        move();
        return outStack.top();
    }

    bool empty() {
        return inStack.empty() && outStack.empty();
    }

private:
    void move() {
        if (!outStack.empty()) return;
        while (!inStack.empty()) {
            outStack.push(inStack.top());
            inStack.pop();
        }
    }
};
```

## 해설
- `push`: inStack에 바로 추가 (O(1))
- `pop`/`peek`: outStack이 비어있을 때만 inStack의 모든 원소를 옮김 (평균 O(1))
- `move`: 두 스택 사이의 이동을 관리
- 큐의 앞(front)은 항상 outStack의 top에 위치

## 시간복잡도
- 각 연산의 평균 시간복잡도: O(1) (Amortized)
- `move`: O(n)

## 마치며
이 문제는 스택과 큐의 차이, 그리고 두 자료구조의 조합을 이해하는데 좋은 문제이다.<br/>
자료구조의 응용과 변환 방법을 이해할 수 있다.

---

*작성일: 2025.06.22*<br/>
*작성자: Cho Donghyun*