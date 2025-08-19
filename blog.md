---
layout: page
title: 블로그
permalink: /blog/
---

<div id="post-container">
  <h2>최근 포스트</h2>
  <button id="toggle-button" style="background: none; border: none; padding: 0; font: inherit; color: gray; cursor: pointer; text-decoration: underline;">확장</button>
  <ul id="post-list">
    {% for post in site.posts limit:50 %}
      <li><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>
    {% endfor %}
  </ul>
</div>

<script>
window.initializePageScripts = function() {
  const toggleButton = document.getElementById('toggle-button');
  const postList = document.getElementById('post-list');

  // 현재 페이지가 블로그 페이지인 경우에만 나머지 코드를 실행
  if (toggleButton && postList) {
    const listItems = Array.from(postList.getElementsByTagName('li'));
    const initialShow = 3;

    // --- 클릭 핸들러 정의 ---
    const clickHandler = () => {
      const isExpanded = toggleButton.dataset.expanded === 'true';
      const newExpandedState = !isExpanded;
      toggleButton.dataset.expanded = newExpandedState;

      listItems.forEach((item, index) => {
        if (index >= initialShow) {
          item.style.display = newExpandedState ? 'list-item' : 'none';
        }
      });

      toggleButton.textContent = newExpandedState ? '축소' : '확장';
      toggleButton.style.color = newExpandedState ? 'gray' : 'yellow';
    };

    // --- 기존 리스너가 있으면 제거하고 새 리스너를 연결 ---
    if (toggleButton._clickHandler) {
      toggleButton.removeEventListener('click', toggleButton._clickHandler);
    }
    toggleButton._clickHandler = clickHandler;
    toggleButton.addEventListener('click', toggleButton._clickHandler);

    // --- 초기 상태 설정 ---
    toggleButton.dataset.expanded = 'false';
    toggleButton.textContent = '확장';
    toggleButton.style.color = 'yellow';

    if (listItems.length <= initialShow) {
      // 포스트가 3개 이하이면 실행

      // 확장 버튼 숨김
      toggleButton.style.display = 'none';

      // 모든 포스트 항목을 화면에 표시
      listItems.forEach(item => item.style.display = 'list-item');
    } else {
      // 포스트가 3개 초과 시 실행

      // 확장 버튼 표시
      toggleButton.style.display = 'inline';

      // 모든 포스트 항목을 순회하면서,
      listItems.forEach((item, index) => {
        // 처음 3개는 보여주고, 나머지는 숨김
        item.style.display = index < initialShow ? 'list-item' : 'none';
      });
    }
  }
};

// 페이지 최초 로드 시에도 초기화 함수를 실행
document.addEventListener('DOMContentLoaded', () => {
    window.initializePageScripts();
});
</script>

<hr>

## 카테고리
- [Unity](/categories/#unity)
- [GameDev](/categories/#gamedev)
- [Portfolio](/categories/#portfolio)
- [Blog](/categories/#blog)