# tv-symlinks.py
This scripts generates symlinks named in the convention of:
```
Show name - S01E01.mp4
Show name - S01E02.mp4
Show name - S01E03.mp4
```
in destination directory, each pointing to the file in source directory.

In order to achieve this, files in source directory are first sorted lexicographically, then scripts iterates over the list and generates symlink with an episode number derived from loop index number.

## Parameters
Mandatory parameters are:
- `-I --input` path to source directory storing media files,
- `-n --name` show name, used for naming symlinks (providing `-n Foo` will yield `Foo - S01E01` name for the first episode)

### Optional parameters
- `-O --output` path to destination directory. Current directory is used when empty
- `-s --season` season number ,used for naming symlinks (providing `-s 3` will yield `Foo - S03E01`, `Foo - S03E02` names and so on). Defaults to 1.
- `--skip` masks for files to be skipped on sorting step, compatible with unix-like wildcards system. Provide multiple masks by separating them with space. Default is `*.zip *.srt *.nfo`.

## TODO:
- detect season and episode numbers longer than 2 chars and adjust filenames
- functionality to provide custom filename templates