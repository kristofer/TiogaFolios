#!/bin/sh

#  set_build_number.sh
#  tiogafolios-beta
#
#  Created by Kristofer on 5/21/20.
#  Copyright © 2020 Kristofer. All rights reserved.

git=`sh /etc/profile; which git`
branch_name=`$git symbolic-ref HEAD | sed -e 's,.*/\\(.*\\),\\1,'`
git_count=`$git rev-list $branch_name |wc -l | sed 's/^ *//;s/ *$//'`
simple_branch_name=`$git rev-parse --abbrev-ref HEAD`

build_number="$git_count"
if [ $CONFIGURATION != "Release" ]; then
build_number+="-$simple_branch_name"
fi

plist="${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
dsym_plist="${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist"

/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $build_number" "$plist"
if [ -f "$DSYM_INFO_PLIST" ] ; then
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $build_number" "$dsym_plist"
fi
