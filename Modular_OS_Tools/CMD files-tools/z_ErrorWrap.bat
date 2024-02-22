@echo off
setlocal enabledelayedexpansion
:: START ERROR WRAPERS ::

    :: Set a variable to track the last successful line
    set "LAST_LINE=0"

    :: Example usage:
    call :ExecuteBlock (
        echo This is a code block
        echo Inside the block
    )

    call :ExecuteExecutable "dir"

    call :ExecuteBlock (
        echo Another code block
        echo With multiple commands
    )

    :: END ERROR WRAPERS ::

:: START ERROR CATCH ::

    :EXIT
    echo =========================================================================== >> "%logFilePath%"
    echo =============   "End Logging"   =============
    echo =========================================================================== >> "%logFilePath%"
    endlocal
    Pause
    goto :EOF

    :Error
    echo Error Encountered
    echo returncode=!retcode!
    echo Last successfully executed line: %LAST_LINE%
    goto :EXIT

    :ExecuteBlock
    set /a "LAST_LINE+=1"
    %*
    if %errorlevel% neq 0 (
        set "retcode=%errorlevel%"
        goto :Error
    )
    goto :EOF

    :ExecuteExecutable
    set /a "LAST_LINE+=1"
    %1
    if %errorlevel% neq 0 (
        set "retcode=%errorlevel%"
        goto :Error
    )
    goto :EOF