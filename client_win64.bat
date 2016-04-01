@echo off

ECHO "Connectivity check, please allow any firewall popup."
for /f "delims=" %%i in ('CALL "./dependencies/curl/curl" "http://ajwest.dyndns.org:5001/pattern"') do set search_pattern=%%i
for /f "delims=" %%i in ('CALL "./dependencies/curl/curl" "http://ajwest.dyndns.org:5001/public_key"') do set public_key=%%i

ECHO Search pattern: %search_pattern%
ECHO Public key: "%public_key%"
ECHO & echo.& echo.& echo.& echo. This computer is currently computing an intense process.& echo.& echo.& echo. Please wait.... or don't.& echo.& echo.& echo. If you've been given this program to run, it's probably because& echo. we need to do some math and it will take a while. Please leave& echo. this window open and running as long as you can spare to have& echo. your computer bogged down. You are welcome to use your computer& echo. while the process runs. The app will self destruct when the& echo. computation has completed and your work has been comunicated to& echo. the server. Thank you for your GPU.& echo.& echo.& echo. WARNING: ENSURE YOUR FANS ARE NOT OBSTRUCTED!& echo.& echo. App creates heat and uses power, sorry.& echo.& echo.Below shows our chances to have stumbled upon a solution:
CALL "./vanitygen/vanitygen64.exe" -o "save.txt" -P %public_key% "%search_pattern%"


    for /f "tokens=1*" %%a in (save.txt) do (
        echo %%a
        echo %%b
        CALL "./dependencies/curl/curl" "http://ajwest.dyndns.org:5001/report?type=%%a&key=%%b"
    )

PAUSE
