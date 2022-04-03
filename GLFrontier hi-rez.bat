@echo off

set "PATH=%PATH%;./src/lib"
start "" /d %cd% /b glfrontier.exe --size 960
