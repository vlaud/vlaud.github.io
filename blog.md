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
document.addEventListener("DOMContentLoaded", function() {
  const postList = document.getElementById('post-list');
  const toggleButton = document.getElementById('toggle-button');
  const listItems = postList.getElementsByTagName('li');
  const initialShow = 3;
  let isExpanded = false;

  // 초기 버튼 색상 설정
  toggleButton.style.color = 'yellow';

  // 포스트가 3개 이하이면 버튼을 숨김
  if (listItems.length <= initialShow) {
    toggleButton.style.display = 'none';
    return;
  }

  // 처음에는 3개만 보이도록 설정
  for (let i = initialShow; i < listItems.length; i++) {
    listItems[i].style.display = 'none';
  }

  toggleButton.addEventListener('click', function() {
    isExpanded = !isExpanded;
    for (let i = initialShow; i < listItems.length; i++) {
      listItems[i].style.display = isExpanded ? 'list-item' : 'none';
    }
    toggleButton.textContent = isExpanded ? '축소' : '확장';
    toggleButton.style.color = isExpanded ? 'gray' : 'yellow';  
  });
});
</script>

<hr>

## 카테고리
- [Unity](/categories/#unity)
- [GameDev](/categories/#gamedev)
- [Portfolio](/categories/#portfolio)
- [Blog](/categories/#blog)