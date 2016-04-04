@echo off
::Set the server's url here. eg. http://192.168.1.130:5000, or use a dynamic dns service with a real domain.
::include trailing slash
set server_url="http://ajwest.dyndns.org:5001/"

ECHO "Trying to connect to the internet, please allow any firewall popup."
::Here we call the flask server host to get the desired search pattern.
for /f "delims=" %%i in ('CALL "./dependencies/curl/curl" "%server_url%pattern"') do set search_pattern=%%i
::Then right away we make another call to get the public key from the server. This key is used for split-key cryptography
::Calls are made one after another instead of something like json for simplicity (it's complex to decode json into variables with batch)
for /f "delims=" %%i in ('CALL "./dependencies/curl/curl" "%server_url%public_key"') do set public_key=%%i
ECHO Server: %server_url%
ECHO Search pattern from server: %search_pattern%
ECHO Public key from server: "%public_key%"
ECHO & echo.& echo.& echo.& echo. This computer is currently computing an intense process.& echo.& echo.& echo.
ECHO Please wait.... we need your help computing a math probability problem.& echo.& echo.& echo.
ECHO If you've been given this program to run, it's probably because
ECHO we need to do some math and it will take a while. Please leave
ECHO this window open and running as long as you can spare to have
ECHO your computer bogged down. You are welcome to use your computer
ECHO while the process runs. The app will self destruct when the
ECHO computation has completed and your work has been communicated to
ECHO the server. Thank you for you service.
ECHO WARNING: ENSURE YOUR FANS ARE NOT OBSTRUCTED! App creates heat and uses power, sorry.
ECHO Below shows our chances to have stumbled upon a solution:
if "%public_key%"=="OFF" CALL "./vanitygen/vanitygen64.exe" -o "save.txt" "%search_pattern%"
else CALL "./vanitygen/vanitygen64.exe" -o "save.txt" -P %public_key% "%search_pattern%"

    for /f "tokens=1*" %%a in (save.txt) do (
        echo %%a %%b
        CALL "./dependencies/curl/curl" "%server_url%report?type=%%a&key=%%b"
    )

PAUSE
