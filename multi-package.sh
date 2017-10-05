#!/bin/bash
IFS=$'\n'

#版本名称
VERSION_NAME=$1

#shell执行目录
PWD=$(pwd)

#工程目录
PROJECT_PATH=$(pwd)

#工程名称
PROJECT_NAME="${PROJECT_PATH##*/}"

#项目名称
ITEM_NAME="webViewtest"

#文件操作目录（包括获取资源文件，生成工程目录等）
OPERATE_PATH="${HOME}/app"

#目标目录名字
TARGETS_DIR_NAME="builds"

#站点工程目录
SITE_PATH="${OPERATE_PATH}/${TARGETS_DIR_NAME}"

#参数文件名
properties="parameter.properties"

#临时文件目录
TEMP_PATH="${OPERATE_PATH}/TmpProject"

#目录apk输出路径
TARGET_APK_PATH="${OPERATE_PATH}/ipa/${VERSION_NAME}"

#工程快照名字
SNAPSHOT_NAME="build-snapshot"

#工程快照
SNAPSHOT_PATH="${OPERATE_PATH}/${SNAPSHOT_NAME}"

#target保存路径
TARGETS_PATH="${SNAPSHOT_PATH}/${TARGETS_DIR_NAME}"

config_file=""

#Bundle_id
bundle_id_prefix=("com.dawoo.gamebox.sid")

code_preifx="app_"

#发布证书名称
code_sign_id="iPhone Distribution: Fujian Shitong Photoelectric Network Co., Ltd."

#version 由参数指定
app_version=$1

if [ ! -n "$1" ];then
    echo "请携带版本号，如：3.0.0"
    exit 1
fi
echo "本次打包版本号为：$1"

#指定打包目录
arr_code=($@)
#去除第一个参数
unset arr_code[0]
#指定个数
arr_code_len=${#arr_code[@]}
echo "指定打包站点个数：${arr_code_len} 个"

function log() {
    echo $1
}

function init_context() {
    #删除上次工程快照
    rm -rf ${SNAPSHOT_PATH}
    log "Generating project snapshot..."

    #临时目录不存在
    # if [ ! -d ${TEMP_PATH} ]; then
    #     mkdir -p ${TEMP_PATH}
    # fi

    #生成工程快照，保存在工作目录
    # cp -r ${PROJECT_PATH} ${TEMP_PATH}
    # mv ${TEMP_PATH}/${PROJECT_NAME} ${SNAPSHOT_PATH}
    # rm -r ${TEMP_PATH}
}

function generate_targets() {
    #需要生成的目标数组
    TARGET_ARRAY=()
    index=1

    if [ $arr_code_len -gt 0 ]; then
        log "开始打包指定站点..."
        for i in ${arr_code[@]}; do
            TARGET_ARRAY[$index]=$code_preifx$i
            let index=index+1
        done
    else
        log "开始打包全部站点..."
        for file in $(ls "${SITE_PATH}"); do
            if [ -d "${SITE_PATH}/${file}" ] && [ $file != 'out' ] && [ $file != 'ignore' ]; then
                TARGET_ARRAY[$index]=$file
                log "=======> ${file}"
                let index=index+1
            fi
        done
    fi

    #初始化工程快照
    init_context
    #生成各个工程的源代码ss
    for target in ${TARGET_ARRAY[@]}; do
        generate_target ${target}
    done
}

#生成target ${1}: 目标名字
function generate_target() {
    #创建快照下的builds目录
    if [ ! -d ${TARGETS_PATH} ]; then
        mkdir -p ${TARGETS_PATH}
    fi

    log "\nGenerate target |${1}|"
    target=${1}

    #复制一个以target命名的新项目，以src_project为蓝本
    cp -r "${PROJECT_PATH}" "${SNAPSHOT_PATH}/${target}"
    #删除旧得资源文件
    rm -r "${SNAPSHOT_PATH}/${target}/${ITEM_NAME}/res"

    cp -r "${SITE_PATH}/${target}" "${TARGETS_PATH}/${target}"
    #拷贝新的资源文件
    cp -r "${TARGETS_PATH}/${target}/res" "${SNAPSHOT_PATH}/${target}/${ITEM_NAME}"

    #修改图标
    cp -a "${TARGETS_PATH}/${target}/AppIcon.appiconset/." "${SNAPSHOT_PATH}/${target}/${ITEM_NAME}/Assets.xcassets/AppIcon.appiconset/"

    #替换.pch文件
    cp -f "${TARGETS_PATH}/${target}/AppBuildHeader.pch" "${SNAPSHOT_PATH}/${target}"

    source "${TARGETS_PATH}/${target}/${properties}"
    app_name=${app_name}
    app_bundle_id=${bundle_id_prefix}${app_sid}
    provision_id=${provision_id}

    plist_path="${SNAPSHOT_PATH}/${target}/${ITEM_NAME}/Info.plist"

    /usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $app_name" ${plist_path}
    /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $app_bundle_id" ${plist_path}
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $app_version" ${plist_path}

    #修改权限
    sudo chmod -R 777 "${SNAPSHOT_PATH}/${target}"
    cd "${SNAPSHOT_PATH}/${target}"

    #archive 打包
    xcodebuild archive -scheme webViewtest -configuration Release -archivePath ./target.xcarchive
    #  CONFIGURATION_BUILD_DIR=$SNAPSHOT_PATH CODE_SIGN_IDENTITY="$code_sign_id" PROVISIONING_PROFILE="${provision_id}"

}

generate_targets
