#!/bin/sh
/Applications/BlitzMax150/bin/bmk makemods
/Applications/BlitzMax150/bin/bmk makeapp -r -a -t console -x "${1}.bmx" -o "${1}.bin"
