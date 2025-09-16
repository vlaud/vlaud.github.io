@echo off
cd /d %~dp0

:: Jekyll 실행
start cmd /k "bundle exec jekyll serve"

:: 브라우저 열기
start http://localhost:4000/
