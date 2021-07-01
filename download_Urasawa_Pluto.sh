#!/bin/bash

# validate input:
# 	* need 3 numbers,
# 	* first should be less or equal to the second,
# 	* both should be in range [1, 65]
# 	* thrid arg -> dump everything in one folder or create separate folders for each chapter
#		 should be either "dump-in-one-folder" or not specified
# 	- fourth arg(optional) -> dir to which to download 
#	 	(script will make new dir inside this one, and will dump files there)

display_usage(){

	echo -e "\
Description:\n\
  Downloads specified chapters of Naoki Urasawa's manga \"Pluto\" from \"pluto-manga-online.com\" \n\n\
Usage:\n\
  download_Urasawa_Pluto.sh <start_chapter_number> <end_chapter_number> {dump-chapters-into-separate-folders | dump-chapters-into-one-folder} [<output_dir>]\n\n\
Example:\n\
  download_Urasawa_Pluto.sh 64 65 dump-chapters-into-separate-folders"

}

if [[ "$#" -lt 2 ]]; then
	display_usage
  	exit 2
fi

if [[ "$(echo $1 | tr -d [:digit:])" != "" || "$(echo $2 | tr -d [:digit:])" != ""  ]]; then
	display_usage
	exit 2
fi

if [[ "$1" -gt "$2" ]]; then
	display_usage
	exit 2
fi

if [[ "$1" -lt 1  || "$2" -gt 162 ]]; then
	display_usage
	exit 2
fi

start_chapter_index=$1
end_chapter_index=$2

if [[ "$3" == "dump-chapters-into-separate-folders" ]]; then
	mode=1
elif [[ "$3" == "dump-chapters-into-one-folder" ]]; then
	mode=0
else
	display_usage
	exit 2
fi

if [[ ! -d "$4" ]]; then
	echo "fourth argument not specified or such directory doesn't exist, setting output dir to pwd"
	output_dir=$(pwd)
else
	output_dir="$4"
fi


current_chapter_index="$start_chapter_index"

while [ $current_chapter_index -le $end_chapter_index ]
do
	# if [ $current_chapter_index -eq 1 ]
	# then
	# 	image_urls=$(curl -s -X GET https://monster-manga.com/manga/anime-name-chapter-1/ | sed -n "s/^.*img src=\"\(\S*\)\".*$/\1/p")
	# elif [ $current_chapter_index -eq 48 ]
	# then
	# 	image_urls=$(curl -s -X GET https://monster-manga.com/manga/monster-chapter-48-2/ | sed -n "s/^.*img src=\"\(\S*\)\".*$/\1/p")		
	# elif [ $current_chapter_index -eq 49 ]
	# then
	# 	image_urls=$(curl -s -X GET https://monster-manga.com/manga/monster-chapter-48/ | sed -n "s/^.*img src=\"\(\S*\)\".*$/\1/p")
	# else
	# 	image_urls=$(curl -s -X GET https://monster-manga.com/manga/monster-chapter-$current_chapter_index/ | sed -n "s/^.*img src=\"\(\S*\)\".*$/\1/p")
	# fi

	image_urls=$(curl -s -X GET https://pluto-manga-online.com/manga/pluto-manga-chapter-$current_chapter_index/ | sed -n "s/^.*img src=\"\(\S*\)\".*$/\1/p")

	# there are 162 chapters -> padding with 3 digits should be sufficient
	padded_chapter_number=$(printf "%03d" $current_chapter_index)

	if [[ "$mode" -eq 0 ]]; then
		download_dir="$output_dir/Urasawa_Pluto"
	else
		download_dir="$output_dir/Urasawa_Pluto/$padded_chapter_number"
	fi

	mkdir -p "$download_dir"

	page_number=1
	while read p; do

		#there are += 30 pages in chapter -> 2 digits should be sufficient
		padded_image_number=$(printf "%02d" $page_number)
		
		#curl -s -X GET "$p" > "$download_dir/$padded_image_number.jpg"
		if [[ "$mode" -eq 0 ]]; then
			curl -s -X GET "$p" > "$download_dir/${padded_chapter_number}${padded_image_number}.jpg"
			#echo "$download_dir/${padded_chapter_number}${padded_image_number}.jpg"
		else
			curl -s -X GET "$p" > "$download_dir/$padded_image_number.jpg"
			#echo "$download_dir/$padded_image_number.jpg"
		fi 
		
		page_number=$(expr $page_number + 1)
	done <<<"$image_urls"

	current_chapter_index=$(expr $current_chapter_index + 1)
done

# push downloaded content to smartphone:
#  adb push Urasawa_Monster/. /storage/emulated/0/Pictures/UrasawaMonster
