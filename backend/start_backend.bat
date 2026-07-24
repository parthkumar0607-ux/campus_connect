@echo off
cd /d D:\codes\projects\campus_connect_v2\backend
call .\venv\Scripts\activate.bat
uvicorn app.main:app --reload --host 0.0.0.0
pause