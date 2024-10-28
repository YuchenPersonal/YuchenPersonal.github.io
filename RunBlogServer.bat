@echo off
echo Starting Jekyll server...

REM Check if the current directory is D:\Blog
if /i "%cd%" NEQ "D:\Blog" (
    cd /d D:\Blog
)

bundle exec jekyll serve
