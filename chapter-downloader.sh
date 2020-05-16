get_chapters() {
    local slug=$1
    local chapter=$2
    local output_dir="$3/$slug/$chapter"
    local urls=()

    if [ ! -d "$3/$slug" ]; then
        mkdir "$3/$slug"
    fi

    if [ ! -d $output_dir ]; then
        mkdir $output_dir
    fi

    for i in {1..100}
    do
        local url=""
        if [ $i -eq 1 ]; then
            # url="http://www.mangareader.net/$slug/$chapter"
            url="http://www.mangapanda.com/$slug/$chapter"
        else
            # url="http://www.mangareader.net/$slug/$chapter/$i"
            url="http://www.mangapanda.com/$slug/$chapter/$i"
        fi

        local file="$output_dir/$i.html"
        curl --silent -o $file $url

        if grep -q "404 Not Found" $file; then
            rm $file
            break
        fi

        echo $file
    done

    for f in "$output_dir"/*; do
        if local line=$(grep -n ".jpg\"" $f); then
            local n=$(basename $f .html)
            local back=${line#*"src=\""}
            local url=${back%*"\" alt"*}
            echo $url
            local i=$((n-1))
            urls[$i]=$url
        fi
    done

    for i in ${!urls[@]}
    do
        local fn=""
        local page=$(($i + 1))
        if [[ $page -gt 9 ]]; then
            fn="$output_dir/0$page.jpg"
        else
            fn="$output_dir/00$page.jpg"
        fi
        echo $fn
        wget --quiet -O $fn ${urls[$i]}
    done

    rm $output_dir/*.html
}

slug_name=$1
min_chapter=$2
max_chapter=$3
dir=$4

index=$min_chapter
while [ $index -lt $((max_chapter + 1)) ]
do
    get_chapters $slug_name $index $dir
    index=$((index + 1))
done
