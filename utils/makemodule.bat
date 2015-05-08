:: Usage: makemodule <modules...>
:: Example: makemodule math fenv complex
:: For each module supplied, a symlink will be created.
:: Before running please ensure that FROM_DIR and TO_DIR are accurate on your system, and that both paths exist.

@echo off
set FROM_DIR=E:/Dropbox/Projects/mach.mod/
set TO_DIR=E:/BlitzMax/BlitzMax150/mod/mach.mod/

:argsloop
    echo "Linking: %1.mod"
    set FROM_PATH="%FROM_DIR%%1.mod/"
    set TO_PATH="%TO_DIR%%1.mod"
    mklink /D %TO_PATH% %FROM_PATH%
    shift
    if not "%~1"=="" goto argsloop

echo "All done!"
