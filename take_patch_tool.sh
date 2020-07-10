#!/bin/bash
#CURREN_PATH=$(pwd)
CURREN_PATH=`pwd`
echo $CURREN_PATH
tmp_out_dir=patch_out_dir
fileName=filePath
SUCCESS_PATCH_NAME=patch_success.txt
FAIL_PATCH_NAME=patch_fail.txt
mkdir -p $tmp_out_dir
patch_name_suffix=bulletin.patch
find -name *.${patch_name_suffix} | sort > $tmp_out_dir/$fileName.patch
cat $tmp_out_dir/$fileName.patch | xargs > $tmp_out_dir/${fileName}_bak.patch
patch_file_name=$(cat $tmp_out_dir/${fileName}_bak.patch)
if [ -z $patch_file_name ]
then
	echo -e "\033[31m #### Can't find $patch_name_suffix file \033[0m"
fi

for patch_dir_name in $patch_file_name
do
 echo $patch_dir_name
 	tmp_patch_dir=$(echo ${patch_dir_name%/*})
 	echo $CURREN_PATH
	cd $CURREN_PATH/$tmp_patch_dir && git am --ignore-date --reject $CURREN_PATH/$patch_dir_name && rm $CURREN_PATH/$patch_dir_name
 	if [ $? -ne 0 ]
 	then
		git am --abort
		echo $CURREN_PATH/$patch_dir_name >> $CURREN_PATH/$tmp_out_dir/$FAIL_PATCH_NAME
		echo -e "\033[31m#########################################################\033[0m"
		echo -e "\033[31m$CURREN_PATH/$patch_dir_name apply ERROR!#\033[0m"
		echo -e "\033[31m#########################################################\033[0m"
		git status .
	 	exit 1
 	fi
	echo
	echo $CURREN_PATH/$patch_dir_name >> $CURREN_PATH/$tmp_out_dir/$SUCCESS_PATCH_NAME
	echo -e "\033[32m success take $CURREN_PATH/$patch_dir_name \033[0m"
	echo
	git status .
 	cd $CURREN_PATH
done

exit 0

