@echo off

ECHO "Trying to connect to the internet, please allow any firewall popup."
::Here we call the flask server host to get the desired search pattern to compute.
for /f "delims=" %%i in ('CALL "./dependencies/curl/curl" "http://ajwest.dyndns.org:5001/pattern"') do set search_pattern=%%i
::Then right away we make another call to get the public key from the server. This key is used for split-key cryptography
:: Calls are made one after another instead of something like json for simplicity (it's complex to decode json into variables in batch)
for /f "delims=" %%i in ('CALL "./dependencies/curl/curl" "http://ajwest.dyndns.org:5001/public_key"') do set public_key=%%i

ECHO Search pattern from server: %search_pattern%
ECHO Public key from server: "%public_key%"
ECHO & echo.& echo.& echo.& echo. This computer is currently computing an intense process.& echo.& echo.& echo.
ECHO Please wait.... we need your help computing a math probability problem.& echo.& echo.& echo.
ECHO If you've been given this program to run, it's probably because
ECHO we need to do some math and it will take a while. Please leave
ECHO this window open and running as long as you can spare to have
ECHO your computer bogged down. You are welcome to use your computer
ECHO while the process runs. The app will self destruct when the
ECHO computation has completed and your work has been comunicated to
ECHO the server. Thank you for your GPU.
ECHO WARNING: ENSURE YOUR FANS ARE NOT OBSTRUCTED! App creates heat and uses power, sorry.
ECHO Below shows our chances to have stumbled upon a solution:
CALL "./vanitygen/vanitygen64.exe" -o "save.txt" -P %public_key% "%search_pattern%"


    for /f "tokens=1*" %%a in (save.txt) do (
        echo %%a
        echo %%b
        CALL "./dependencies/curl/curl" "http://ajwest.dyndns.org:5001/report?type=%%a&key=%%b"
    )

PAUSE
