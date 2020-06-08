#!/bin/bash
rm -f run.sh* results.txt confirmed nolinks dupes dupesdebug rmnolinks.sh
ist=$(find -type f -links 1 | grep -v .sh)
find . -name "*.mkv" -links 1 -print0 | while read -d $'\0' file
do
    filename=${file##*/}
    find /mnt/user/Media/Movies/ /mnt/user/Media/TV/ -name "$filename" -print0 | while read -d $'\0' found
    do
        echo "testing: $file -> $found"
        if [[ $(stat --printf '%h\n' $found) == '1' ]]
        then
            pv $file | cmp -s $found && echo "$file" >> confirmed && echo "confirmed: $file -> $found" | tee -a results.txt
&& echo "rm -v \"$found\" && ln \"$file\" \"$found\"" >> run.sh
            printf "\n"
        elif [[ $(stat --printf '%h\n' $found) == '2' ]]
        then
            pv $file | cmp -s $found && echo "link already exits: $file -> $found" | tee -a results.txt
            printf "\n"
    fi
    done
    echo $file >> nolinks
done

# sanity check duplicates that ( nolink on destination but two in downloads/complete
cat confirmed | while read -r file
do
    basename $file >> dupesdebug
done

sort dupesdebug | uniq -d > dupes
if [[ -z $(cat dupes) ]]
then
    comm -23 <(sort nolinks) <(sort confirmed) | while read -r file
    do
        filename="${file}"
        echo "notlinked: $filename" >> results.txt
root@Tower:/mnt/user/Media/downloads/complete# cat fixnolinks.sh
#!/bin/bash
rm -f run.sh* results.txt confirmed nolinks dupes dupesdebug rmnolinks.sh
ist=$(find -type f -links 1 | grep -v .sh)
find . -name "*.mkv" -links 1 -print0 | while read -d $'\0' file
do
    filename=${file##*/}
    find /mnt/user/Media/Movies/ /mnt/user/Media/TV/ -name "$filename" -print0 | while read -d $'\0' found
    do
        echo "testing: $file -> $found"
        if [[ $(stat --printf '%h\n' $found) == '1' ]]
        then
            pv $file | cmp -s $found && echo "$file" >> confirmed && echo "confirmed: $file -> $found" | tee -a results.txt && echo "rm -v \"$found\" && ln \"$file\" \"$found\"" >> run.sh
            printf "\n"
        elif [[ $(stat --printf '%h\n' $found) == '2' ]]
        then
            pv $file | cmp -s $found && echo "link already exits: $file -> $found" | tee -a results.txt
            printf "\n"
    fi
    done
    echo $file >> nolinks
done

# sanity check duplicates that ( nolink on destination but two in downloads/complete
cat confirmed | while read -r file
do
    basename $file >> dupesdebug
done

sort dupesdebug | uniq -d > dupes
if [[ -z $(cat dupes) ]]
then
    comm -23 <(sort nolinks) <(sort confirmed) | while read -r file
    do
        filename="${file}"
        echo "notlinked: $filename" >> results.txt
        echo "rm -v \"$filename\"" >> rmnolinks.sh
    done
    
    chmod +x run.sh
    chmod +x rmnolinks.sh
    printf "\n\n\n\n"
    echo "----"
    echo done
    echo "----"
    echo "see debug to confirmed and nolinks"
    echo 'see ouput to results.txt'
    echo "see script to run to fixlinks run.sh"
    echo "see script to remove nolinks rmnolinks.sh"
else
    echo "you have dupes see dupes and dupesdebug file"
fi
