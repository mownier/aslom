SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -f "$SOURCE_DIR/chapter-downloader.sh" ]; then
    echo "chapter-downloader.sh not found"
    exit 1
fi

if [ ! -d "$SOURCE_DIR/folder-provider.workflow" ]; then
    echo "folder-provider.workflow not found"
    exit 1
fi

if [ ! -d "$SOURCE_DIR/pdf-converter.workflow" ]; then
    echo "pdf-converter.workflow not found"
    exit 1
fi

if [[ $1 == "help" ]] || [[ $1 == "" ]]; then
    echo ""
    echo "aslom.sh"
    echo "  -s : Slug name of the manga."
    echo "  -f : The first chapter to be downloaded."
    echo "       Should be greater than 0"
    echo "  -l : The last chapter to be downloaded."
    echo "       Should be greater than or equal to the value of -f argument."
    echo "  -o : The output directory."
    echo "  -i : An option whether to get only the images or convert to pdf. "
    echo "       Value is either 0 or 1. 0 for image only, 1 for converting to pdf."
    echo ""
    echo "  example:"
    echo "    $ ./aslom.sh -s fairy-tail -f 400 -l 545 -o ~/Desktop -i 1"
    echo ""
    exit 0
fi

while getopts s:f:l:o:i: option
do
    case "${option}"
    in
    s) slug=${OPTARG};;
    f) min=${OPTARG};;
    l) max=${OPTARG};;
    o) output_dir=${OPTARG};;
    i) image_only=${OPTARG};;
    esac
done

if [ -z "$slug" ]; then
    echo "Manga slug name is empty"
    exit 1
fi

if [[ $min == "" ]] || [[ $min -eq 0 ]] || [[ $min < 0 ]]; then
    echo "minimum chapter should be greater than 0"
    exit 1
fi

if [[ $max != "" ]] && [[ $max < $min ]]; then
    echo "maximum chapter should be greater than or equal to minimum"
    exit 1
else
    if [[ $max == "" ]]; then
        max=$min
    fi
fi

if [ -z "$output_dir" ]; then
    output_dir=$(pwd)
fi

if [ ! -d "$output_dir" ]; then
    echo "$output_dir not a valid directory"
    exit 1
fi

ok=0
if [[ $image_only -eq 0 ]] || [[ $image_only -eq 1 ]]; then
    ok=1
fi

if [[ $ok -eq 0 ]]; then
    echo "-i valid value is either 0 or 1"
    exit 1
fi

if [[ $image_only -eq 1 ]]; then
    echo "START" &&
    echo "Downloading chapters..." &&
    "$SOURCE_DIR/chapter-downloader.sh" $slug $min $max $output_dir &&
    echo "OK: Finished downloading chapters" &&
    echo "END"
else
    echo "START" &&
    echo "Downloading chapters..." &&
    "$SOURCE_DIR/chapter-downloader.sh" $slug $min $max $output_dir &&
    echo "OK: Finished downloading chapters" &&
    echo "Converting to pdf..." &&
    automator -i "$output_dir/$slug,$SOURCE_DIR/pdf-converter.workflow" "$SOURCE_DIR/folder-provider.workflow"
    echo "END"
fi
