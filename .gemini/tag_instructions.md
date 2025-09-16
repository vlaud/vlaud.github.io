# 포스트 태그 작성 규칙

포스트에 태그를 추가할 때, 특히 C++, C# 등 프로그래밍 언어와 관련된 태그는 `_data/taxonomy_names.yml` 파일을 참조하여 해당 파일에 정의된 키 값을 사용해야 합니다.

## 예시

'C++' 태그를 사용하고 싶다면, `_data/taxonomy_names.yml` 파일에서 `cplusplus: "C++"` 매핑을 찾아 포스트의 프런트 매터에 다음과 같이 `cplusplus`를 사용해야 합니다.

```yaml
---
tags: [cplusplus]
---
```

## 현재 `taxonomy_names.yml` 매핑

```yaml
cplusplus: "C++"
cplusplus11: "C++11"
cplusplus14: "C++14"
cplusplus17: "C++17"
cplusplus20: "C++20"
cplusplus23: "C++23"
csharp_legacy: "C# Legacy"
csharp: "C#"
modern-cplusplus: "Modern C++"
```
