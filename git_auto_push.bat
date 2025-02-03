@echo off
setlocal enabledelayedexpansion

:: Define commit messages sequence
set messages=a b c d e f g h i j k l m n o p q r s t u v w x y z

:: Get the last commit message
for /f "tokens=*" %%a in ('git log --format^=%%s -n 1') do set last_msg=%%a

:: Find the next message in sequence
set next_msg=a
for %%m in (%messages%) do (
    if "!last_msg!"=="%%m" (
        set found=1
    ) else if defined found (
        set next_msg=%%m
        goto commit
    )
)

:commit
echo Commit message: %next_msg%
git add .
git commit -m "%next_msg%"
git push -u origin master

endlocal
