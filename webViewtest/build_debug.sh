#!/bin/sh

#--------------------------------------------
# 功能：实现Debug版本的打包
# 作者：Panda
# 使用教程： 1. cd 脚本所在的目录
#           2. chmod 777 build_debug.sh (仅第一次的时候需要)
#           3. ./build_debug.sh
# 创建日期：2016/02/22
#--------------------------------------------

# 替换你要打包项目的 profile name
profile_name='5646b496-c916-4d75-8fc5-9e820a5300a1'
echo "======Debug Profile name：${profile_name}======"

# 获取工程根目录
xCodeBuild_GetDocumentDirPath(){
project_Path=$(pwd)
echo ${project_Path}
}

cd ..

# 获取ipa文件导出路径
build_outputPath(){
#cd ..
scheme=$(ls | grep xcodeproj | awk -F.xcodeproj '{print $1}')
cd ~/Desktop

SYSTEM_TIME=`date '+%Y-%m-%d-%T'`
outputPath=$(pwd)/${scheme}_${SYSTEM_TIME}
mkdir ${outputPath}
#cd ${projectPath}
echo ${outputPath}
}

buildExportPath=$(build_outputPath)
echo "======输出路径：${buildExportPath}======"

# 打包类型
build_Mode='Release'

# 工程名称
project_name=$(ls | grep xcodeproj | awk -F.xcodeproj '{print $1}')
echo "======工程名字：${project_name}======"

# 获取工程绝对路径
project_path=$(xCodeBuild_GetDocumentDirPath)
echo "======工程绝对路径：${project_path}======"

#echo ${project_path}
# 获取xcworkSpace的路径
workspacePath=${project_path}/${project_name}.xcworkspace
echo "======workspacePath路径：${workspacePath}======"

# build文件夹路径
build_path=${project_path}/build

# 工程配置文件路径
project_name=$(ls | grep xcodeproj | awk -F.xcodeproj '{print $1}')
project_infoplist_path=${project_path}/${project_name}/Info.plist
# 取版本号
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" ${project_infoplist_path})
echo "======版本名称：${bundleShortVersion}"

# 取build值
bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" ${project_infoplist_path})
echo "======版本号：${bundleVersion}"

# 取bundle Identifier前缀
bundlePrefix=$(/usr/libexec/PlistBuddy -c "print CFBundleIdentifier" `find . -name "Info.plist"` | awk -F$ '{print $1}')
echo "======bundle Identifier前缀：${bundlePrefix}"

# 进入工程路径下
cd ${project_path}
echo 开始清理工程~

# 删除bulid目录
if [ -d ${build_path} ]; then
    rm -rf ${build_path}
    echo 清理build文件成功
fi

# 清理工程
xcodebuild clean -configuration ${build_Mode} || exit

# 编译
xcodebuild archive -scheme ${project_name} -archivePath ${project_path}/build/Debug-iphoneos/${project_name}_Debug.xcarchive -configuration ${build_Mode} || exit
#  CONFIGURATION_BUILD_DIR=$SNAPSHOT_PATH CODE_SIGN_IDENTITY="$code_sign_id" PROVISIONING_PROFILE="${provision_id}"
# 打包
xcodebuild -exportArchive -archivePath ${project_path}/build/Debug-iphoneos/${project_name}_Debug.xcarchive -exportPath ${buildExportPath}/debug.ipa  -exportOptionsPlist "${project_path}/archive.plist" || exit

if [ -d ./ipa-build ];then
rm -rf ipa-build
fi

if [ -d ./build/Debug-iphoneos ];then
rm -rf Debug-iphoneos
fi
