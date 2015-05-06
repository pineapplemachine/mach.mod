FROM_DIR=~/Dropbox/Projects/mach.mod/
TO_DIR=/Applications/BlitzMax150/mod/mach.mod/

for arg in "$@"
do
    echo "Linking: ${arg}.mod"
    FROM_PATH="${FROM_DIR}${arg}.mod/"
    TO_PATH="${TO_DIR}${arg}.mod"
    ln -s $FROM_PATH $TO_PATH
done

echo "All done!"
