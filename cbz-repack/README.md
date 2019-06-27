# cbz-repack
This script serves the purpose unzipping an archive, uploading 10 sample files to [uguu.se](https://uguu.se) file hosting and packing all the files into .cbz archive. It might be useful when dealing with digitally purchased comic books, if one wants to be sure there is no metadata of some sort attached to the downloaded content. Such data may be used to track down the user who shared the purchased digital asset.  

**Keep in mind!** This script doesn't remove eventual metadata of actual, archived files. It may only protect you from being tracked, if the archive is *poisoned* with some data itself!  

## Usage
Execute the script with a path to your archive as an argument. E.g:
```
./cbz-repack "Some_Artist-A_Book_Vol1_x3200.zip"
```
Script will create new, .cbz archive with no compression used alongside the original file. Links to the uploaded sample files will be written to the `uplinks` file, created alongside the original archive as well.  

The original file indicated by the argument will be kept intact. Executing script with `-rm` argument before the path to the file will result in deletion of the original file after all work is done.