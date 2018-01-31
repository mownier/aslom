# aslom

A manga downloader.

This downloads manga from:
- [x] mangareader.net

## Usage

| options | description |
|:----:|-------|
| -s | Slug name of the manga. |
| -f | The first chapter to be downloaded.<br>Should be greater than 0. |
| -l | The last chapter to be downloaded.<br>Should be greater than or equal to the value of -f argument. |
| -o | The output directory. |
| -i | An option whether to get only the images or convert to pdf.<br>Value is either 1 or 0. 1 for image only, 0 for converting to pdf. |

### Getting the Slug name

In this link http://www.mangareader.net/fairy-tail, `fairy-tail` is the lsug name

### Example

```bash
# Downloads only the images from chapter 400 to 545
$ ./aslom.sh -s fairy-tail -f 400 -l 545 -o ~/Desktop -i 1

# Downloads images and creates pdf files from chapter 400
$ ./aslom.sh -s fairy-tail -f 400 -o ~/Desktop
```

## Remarks
Converting pdf is invoked with the option-value `-i 0` (_this is the default value of the option -i_). This process is using automators in macOS. If you wish to use `aslom.sh` in other operating system, I suggest to use the option-value `-i 1`. It will just download the images and pdf conversion will not proceed.
