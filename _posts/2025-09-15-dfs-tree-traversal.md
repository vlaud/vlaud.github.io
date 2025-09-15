---
layout: post
title: "자료구조 - DFS와 트리 순회 (전위, 중위, 후위)"
date: 2025-09-15
categories: [Algorithm, Data Structure]
tags: [DFS, Algorithm, Tree, Traversal, Pre-order, In-order, Post-order]
---

## 개념
트리(Tree) 자료구조의 모든 노드를 한 번씩 방문하는 과정을 '순회(Traversal)'라고 한다. 깊이 우선 탐색(DFS, Depth-First Search)은 트리 순회의 가장 기본적인 방법 중 하나이며, 노드를 어떤 순서로 방문하느냐에 따라 전위 순회(Pre-order), 중위 순회(In-order), 후위 순회(Post-order) 세 가지로 나뉜다.

이 세 가지 순회 방식은 모두 재귀적으로 동작하며, 현재 노드를 언제 처리하느냐에 따라 구분된다.

- **전위 순회 (Pre-order):** `Root` -> Left -> Right
- **중위 순회 (In-order):** Left -> `Root` -> Right
- **후위 순회 (Post-order):** Left -> Right -> `Root`

## 순회 방식 분석
아래와 같은 간단한 이진 트리를 예시로 세 가지 순회 방식을 분석해 본다.

```
      F
    /   \
   B     G
  / \     \
 A   D     I
    / \   /
   C   E H
```

### 1. 전위 순회 (Pre-order Traversal)
**규칙: Root -> Left -> Right (현재 노드 처리 -> 왼쪽 서브트리 방문 -> 오른쪽 서브트리 방문)**

가장 먼저 현재 노드를 방문(처리)한 뒤, 왼쪽 서브트리로 내려가고, 왼쪽 서브트리 순회가 끝나면 오른쪽 서브트리를 순회한다.

- **순회 경로:**
    1. `F` 방문
    2. `F`의 왼쪽 자식 `B` 방문
    3. `B`의 왼쪽 자식 `A` 방문
    4. `A`의 자식이 없으므로 `B`로 돌아와 오른쪽 자식 `D` 방문
    5. `D`의 왼쪽 자식 `C` 방문
    6. `C`의 자식이 없으므로 `D`로 돌아와 오른쪽 자식 `E` 방문
    7. `E`의 자식이 없으므로 `F`까지 모두 돌아온 뒤, `F`의 오른쪽 자식 `G` 방문
    8. `G`의 왼쪽 자식은 없으므로 오른쪽 자식 `I` 방문
    9. `I`의 왼쪽 자식 `H` 방문
    10. 모든 노드 방문 완료

- **결과:** `F, B, A, D, C, E, G, I, H`

### 2. 중위 순회 (In-order Traversal)
**규칙: Left -> Root -> Right (왼쪽 서브트리 방문 -> 현재 노드 처리 -> 오른쪽 서브트리 방문)**

가장 왼쪽 끝 노드까지 내려간 뒤, 돌아오면서 현재 노드를 방문하고, 그 다음 오른쪽 서브트리를 순회한다. 이진 탐색 트리(BST)를 중위 순회하면 오름차순으로 정렬된 결과를 얻을 수 있다.

- **순회 경로:**
    1. `F`에서 시작 -> `B` -> `A` (가장 왼쪽)
    2. `A` 방문
    3. `B`로 돌아와 `B` 방문
    4. `B`의 오른쪽 자식 `D`로 이동 -> `D`의 왼쪽 자식 `C`로 이동
    5. `C` 방문
    6. `D`로 돌아와 `D` 방문
    7. `D`의 오른쪽 자식 `E` 방문
    8. `F`로 돌아와 `F` 방문
    9. `F`의 오른쪽 자식 `G`로 이동
    10. `G`의 오른쪽 자식 `I`로 이동 -> `I`의 왼쪽 자식 `H`로 이동
    11. `H` 방문
    12. `I`로 돌아와 `I` 방문
    13. `G`로 돌아와 `G` 방문 (G의 왼쪽은 없었음)
    14. 모든 노드 방문 완료

- **결과:** `A, B, C, D, E, F, H, I, G` (예시 트리는 BST가 아니므로 정렬되지는 않음)

### 3. 후위 순회 (Post-order Traversal)
**규칙: Left -> Right -> Root (왼쪽 서브트리 방문 -> 오른쪽 서브트리 방문 -> 현재 노드 처리)**

가장 아래 레벨까지 내려가 왼쪽과 오른쪽 서브트리 순회를 모두 마친 뒤, 돌아오면서 현재 노드를 방문한다. 자식 노드를 먼저 처리해야 할 때 유용하다 (e.g., 트리 삭제).

- **순회 경로:**
    1. `F` -> `B` -> `A` (가장 왼쪽)
    2. `A` 방문
    3. `B`로 돌아와 오른쪽 자식 `D`로 이동 -> `C`로 이동
    4. `C` 방문
    5. `D`로 돌아와 오른쪽 자식 `E` 방문
    6. `E` 방문 후 `D`로 돌아와 `D` 방문
    7. `B`로 돌아와 `B` 방문
    8. `F`로 돌아와 오른쪽 자식 `G`로 이동 -> `I` -> `H`
    9. `H` 방문
    10. `I`로 돌아와 `I` 방문
    11. `G`로 돌아와 `G` 방문
    12. `F`로 돌아와 `F` 방문
    13. 모든 노드 방문 완료

- **결과:** `A, C, E, D, B, H, I, G, F`

## 코드 예시 (C++)
```cpp
#include <iostream>
#include <vector>
#include <string>

// 트리 노드를 표현하는 구조체
struct Node {
    char data;
    Node* left;
    Node* right;

    // 생성자
    Node(char d) : data(d), left(nullptr), right(nullptr) {}
};

// 전위 순회 (Pre-order)
void preorder(Node* node) {
    if (node == nullptr) return;
    std::cout << node->data << " "; // Root
    preorder(node->left);           // Left
    preorder(node->right);          // Right
}

// 중위 순회 (In-order)
void inorder(Node* node) {
    if (node == nullptr) return;
    inorder(node->left);            // Left
    std::cout << node->data << " "; // Root
    inorder(node->right);           // Right
}

// 후위 순회 (Post-order)
void postorder(Node* node) {
    if (node == nullptr) return;
    postorder(node->left);          // Left
    postorder(node->right);         // Right
    std::cout << node->data << " "; // Root
}

int main() {
    // 예시 트리 생성
    Node* root = new Node('F');
    root->left = new Node('B');
    root->right = new Node('G');
    root->left->left = new Node('A');
    root->left->right = new Node('D');
    root->left->right->left = new Node('C');
    root->left->right->right = new Node('E');
    root->right->right = new Node('I');
    root->right->right->left = new Node('H');

    std::cout << "전위 순회 (Pre-order): ";
    preorder(root);
    std::cout << std::endl;

    std::cout << "중위 순회 (In-order):  ";
    inorder(root);
    std::cout << std::endl;

    std::cout << "후위 순회 (Post-order): ";
    postorder(root);
    std::cout << std::endl;
    
    // 메모리 해제는 후위 순회를 활용할 수 있다.
    // postorder_delete(root);

    return 0;
}
```

## 실전 활용 사례
- **전위 순회:** 트리를 복사하거나 직렬화(serialization)할 때 유용하다. 부모 노드가 먼저 생성되어야 자식 노드를 연결할 수 있기 때문이다. 폴더 구조를 그대로 복사하는 경우를 생각할 수 있다.
- **중위 순회:** 이진 탐색 트리(BST)에서 모든 노드를 오름차순으로 방문하고 싶을 때 사용된다.
- **후위 순회:** 트리의 각 노드를 메모리에서 해제(삭제)할 때 사용된다. 자식 노드를 먼저 해제해야 부모 노드를 안전하게 해제할 수 있기 때문이다.

## 마치며
전위, 중위, 후위 순회는 트리를 다루는 모든 알고리즘의 기초가 된다. 각 순회 방식의 이름은 '현재 노드(Root)를 언제 처리하는지'를 기준으로 정해졌다는 점(Pre: 먼저, In: 중간에, Post: 나중에)을 기억하면 혼동을 줄일 수 있다. 이 세 가지 순회 방식의 원리와 차이점을 명확히 이해하고 언제 사용되는지 알아두는 것이 중요하다.

--- 

*작성일: 2025.09.15*<br/>
*작성자: Cho Donghyun*
