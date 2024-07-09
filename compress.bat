@echo off
set current_dir=%cd%
wsl bash --login -c "compress.sh "%current_dir%"
pause