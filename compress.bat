@echo off
setlocal enabledelayedexpansion

:: Capture the current directory
set "current_dir=%cd%"
echo Original directory: %current_dir%

:: Convert to WSL path format
set "wsl_dir=!current_dir:~0,1!"
:: Convert drive letter to lowercase
for %%i in ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i" "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r" "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z") do (
    set "wsl_dir=!wsl_dir:%%~i!"
)
set "wsl_dir=/mnt/!wsl_dir!"
set "wsl_dir=!wsl_dir!!current_dir:~2!"
set "wsl_dir=!wsl_dir:\=/!"
:: Remove potential duplicate slashes (e.g., /mnt//c/)
set "wsl_dir=!wsl_dir:/mnt//=mnt/!"

echo Converted WSL directory: !wsl_dir!

:: Execute the script in WSL, passing the modified path
wsl bash --login -c "compress.sh '!wsl_dir!'"

pause