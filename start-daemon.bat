@echo off
title wechat-claude-code Daemon
cd /d %USERPROFILE%\.claude\skills\wechat-claude-code
echo Starting wechat-claude-code daemon...
echo Press Ctrl+C to stop.
echo.
node dist\main.js
pause
