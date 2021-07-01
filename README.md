# Download manga chapters from [monster-manga.com](monster-manga.com), [pluto-manga-online.com](pluto-manga-online.com)

## TODO

* combine into one script
* parse links from main page (because chapter pages for "Monster" for example follow multiple naming rules)
	* in "Monster" some chapter was missing


``` 
Description:
  Downloads specified chapters of Naoki Urasawa's manga "Pluto" from "pluto-manga-online.com" 

Usage:
  download_Urasawa_Pluto.sh <start_chapter_number> <end_chapter_number> {dump-chapters-into-separate-folders | dump-chapters-into-one-folder} [<output_dir>]

Example:
  download_Urasawa_Pluto.sh 64 65 dump-chapters-into-separate-folders
```