#!/bin/bash

#存储旧的分隔符
OLD_IFS="$IFS"
#设置分隔符
IFS="."
#如下会自动分隔
VersionString=`grep -E '#version.*=' UBTIMSDK_iOS.podspec`
IFS="="
arr=(${VersionString})
versionNumber="${arr[1]}"
IFS="."
arr=(${versionNumber})
#恢复原来的分隔符
IFS="$OLD_IFS"
buildNumber=arr[2]
newBuildNumber=$(($buildNumber + 1))
newVersionNumber=${arr[0]}.${arr[1]}.${newBuildNumber}
LineNumber=`grep -nE '#version.*=' UBTIMSDK_iOS.podspec | cut -d : -f1`
sed -i "" "${LineNumber}s/${versionNumber}/${newVersionNumber}/g" UBTIMSDK_iOS.podspec
LineNumber=`grep -nE 's.version.*=' UBTIMSDK_iOS.podspec | cut -d : -f1`
sed -i "" "${LineNumber}s/${versionNumber}/${newVersionNumber}/g" UBTIMSDK_iOS.podspec

echo "version:${versionNumber} up to version:${newVersionNumber}"

git add .
git commit -am "[发布配置]版本号升级至:${newVersionNumber}"
git tag ${newVersionNumber}
git push origin master --tags
pod repo push --sources=git@10.10.1.34:Common/podSpec.git,https://github.com/CocoaPods/Specs  Specs UBTIMSDK_iOS.podspec --allow-warnings --verbose
