rm -f run.sh*
list=$(find -type f -links 1 | grep -v .sh)
find . -name "*.mkv" -links 1 -print0 | while read -d $'\0' file
do
    filename=${file##*/}
    found=$(find /mnt/user/Media/Movies/ /mnt/user/Media/TV/ -name "$filename")
    if [ "$found" != '' ]
    then
        echo $found
        echo "rm \"$found\" && ln \"$file\" \"$found\"" >> run.sh
    fi
done
chmod +x run.sh
