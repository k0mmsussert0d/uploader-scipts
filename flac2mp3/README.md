# flac2mp3
This bash script is useful when preparing uploads for music sharing trackers like *RIP* `what.cd`  
It's main purpose is automation of the transcoding process. Usually, when you're in possesion of lossless version of the release you want to share, you might as well want to upload lossy transcodes to boost up your uploaded torrents quantity.  
  
## Usage
Script takes one argument as a parameter. It should be path indicating to the directory containing master (losslessly encoded) files.  
```
./flac2mp3.sh "~/Music/Various Artist - Some Album"
```
The output will be directories created alongside the directory indicated by the parameter, each one containing audio files transcoded according to the instructions given inside the `OPTIONS` associative array. Defaultly, you should get MP3 320 CBR and MP3 V0 VBR transcodes.  

```
~/Music/Various Artist - Some Album (CD - MP3 - 320)
~/Music/Various Artist - Some Album (CD - MP3 - V0)
```

Directories will be given a name of source files directory with a sufficient appendix. The directory with source files will remain untouched except for its name, which will be extended by an appendix.  

```
~/Music/Various Artist - Some Album (CD - FLAC)
```

Covers files will be copied to the new directories. Metadata files and directories inside a master directory will be omitted.

## Configuration
### Transcoding settings
The defualt configuration includes:
* transcoding to MP3 320 CBR and adding `(CD - MP3 - 320)` to the directory name,
* transcoding to MP3 (V0 VBR) and adding `(CD - MP3 - V0)` to the directory name,
* adding `(CD - FLAC)` to the directory name.  

These settings are defined within an `OPTIONS` associative array, right after the declaration line: `declare -A OPTIONS`. Every key-value element indicates a separate transcoding variant. A value is a command that will be evaluated for each file. You should use it to define transcoding options. There are two variables that can be put inside that value:
* `"$input"` - currently processed audio file path,
* `"$output"` - path to the output file.  

A key of an element will be used as an appendix for renaming the directory with transcoded files.

#### Example
```
OPTIONS['CD - MP3 - 320']='ffmpeg -i "$input" -b:a 320k "$output.mp3"'
```
This part of default configuration results in creating `DIRNAME (CD - MP3 - 320)` directory containing files transcoded using the command above, where `DIRNAME` is a master directory name.

### Master directory renaming
Directory with lossless files shall also receive a new name with a correct appendix. This is also determined by a key in the `OPTIONS` array, which corresponding value is **empty**.  

#### Example
```
OPTIONS['CD - FLAC']=""
```
This part of default configuration results in changing the name of master directory to `DIRNAME (CD - FLAC)`, where `DIRNAME` is its original name.

### Processing other files
You can specify the behaviour for all kinds of files. On default:
* all the `.flac` and `.wav` files are transcoded/encoded according to the configuration,
* all the `.jpeg .jpg .bmp .png` files are copied to new directories,
* all the `.log .cue` and directories inside are omitted.

## Prerequisites
In order to execute that script successfully, aside from bash shell, you'll need `ffmpeg`. If you'd like to use encoder of your choice, such as `avconv`, take a look at [configuration instructions](#Transcoding-settings).