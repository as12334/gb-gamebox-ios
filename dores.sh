# !/bin/sh
#  dores.sh
#  gameBoxEx
#
#  Created by Shin on 2018/6/2.
#  Copyright © 2018年 Shin. All rights reserved.
# 将对应SID的资源打包，避免ipa过大

#根据SID配置文件决定需要使用的资源
#读取sid的配置

project_path=$(cd "$(dirname "$0")";pwd) #"${shell_folder}/gamebox-ios" #工程文件夹路径
cat "${project_path}/sid" | while read line
do
  echo ${line}
  sid=${line} #取sid value
  echo "sid:${sid}"

  all_res_path="${project_path}/icon_logo" #存放所有渠道icon和logo的路径
  assets_path="${project_path}/gameBoxEx/Assets.xcassets" #工程中Assets文件夹的路径
  assets_logo_path="${assets_path}/app_logo" #logo存放的文件夹名称
  temp_logo_json_path="${project_path}/temp_json_file" #logo的Contents.json模板路径
  temp_icon_json_path="${project_path}/temp_json_file" #icon的Contents.json模板路径

  echo "${all_res_path}"
  echo "${assets_logo_path}"
  echo "====="
  #先删除Assets下的所有icon和logo
  for fileDir in "${assets_logo_path}"/*; do
     #删除现有logo资源
     rm -r ${fileDir}
  done

  for fileDir in "${assets_path}"/*; do
      AppIconFolder=${fileDir##*/} #截取得到sid文件夹名称
      AppIconName=${AppIconFolder%%.*}
      if [[ ${AppIconName} == "AppIcon" ]]; then
        #删除现有icon资源
        rm -r ${fileDir}
      fi
  done

  # 将新的图片资源更换上去

  # 替换logo
  for fileDir in "${all_res_path}"/*; do
     folder=${fileDir##*/} #截取得到sid文件夹名称
     if [[ ${folder} == ${sid} ]]; then
         #找到需要替换的sid资源目录

         #去assets_logo_path创建一个新的logo sid目录
         #app_logo_xxx.imageset
         cd ${assets_logo_path}
         mkdir "app_logo_${sid}.imageset"

         #将logo图片copy到新建的imageset目录
         cd ${fileDir}
         cp -i "app_logo_${sid}.png" "${assets_logo_path}/app_logo_${sid}.imageset"

         #将logo的Contents.json模板拷贝到imageset目录
         cd ${temp_logo_json_path}
         cp "logo_Contents.json" "Contents.json"
         mv "Contents.json" "${assets_logo_path}/app_logo_${sid}.imageset"
         #将"filename" : "temp_logo.png"替换成对应的值
            cd "${assets_logo_path}/app_logo_${sid}.imageset"
            sed 's/temp_logo.png/app_logo_'${sid}'.png/g' Contents.json > Contents.json.tmp
         mv Contents.json.tmp Contents.json
     fi
  done

  # 替换icon
  for fileDir in "${all_res_path}"/*; do
     folder=${fileDir##*/} #截取得到sid文件夹名称
     if [[ ${folder} == ${sid} ]]; then
         #找到需要替换的sid资源目录

         #去assets_path创建一个新的icon sid目录
         #AppIcon.appiconset
         cd ${assets_path}
         mkdir "AppIcon.appiconset"

         #将icon图片copy到新建的appiconset目录
         cd ${fileDir}
         cp -i "app_icon_${sid}_120x120.png" "${assets_path}/AppIcon.appiconset"
         cp -i "app_icon_${sid}_180x180.png" "${assets_path}/AppIcon.appiconset"

         #将icon的Contents.json模板拷贝到appiconset目录
         cd ${temp_icon_json_path}
         cp "icon_Contents.json" "Contents.json"
         mv "Contents.json" "${assets_path}/AppIcon.appiconset"
         #将"filename" : "app_icon_120x120.png" | "app_icon_180x180.png" 替换成对应的值
         cd "${assets_path}/AppIcon.appiconset"
         sed 's/app_icon_120x120.png/app_icon_'${sid}'_120x120.png/g' Contents.json > Contents.json.tmp
         mv Contents.json.tmp Contents.json
         sed 's/app_icon_180x180.png/app_icon_'${sid}'_180x180.png/g' Contents.json > Contents.json.tmp
         mv Contents.json.tmp Contents.json
     fi
  done

  for fileDir in "${all_res_path}"/*; do
     folder=${fileDir##*/} #截取得到sid文件夹名称
     if [[ ${folder} == ${sid} ]]; then
         #找到需要替换的sid资源目录
         /bin/cp -rf "${project_path}/temp_json_file/startimage_750x1134.jpg" "${assets_path}/startImage.imageset"
         /bin/cp -rf "${project_path}/temp_json_file/startimage_1242x2290.jpg" "${assets_path}/startImage.imageset"

         cd ${fileDir}
         for subfileDir in "${fileDir}"/*; do
            subFile=${subfileDir##*/} #截取得到sid文件夹名称
            if [[ ${subFile} == "startimage_750x1134.jpg" ]]; then
                /bin/cp -rf "startimage_750x1134.jpg" "${assets_path}/startImage.imageset"
            fi

            if [[ ${subFile} == "startimage_1242x2290.jpg" ]]; then
                /bin/cp -rf "startimage_1242x2290.jpg" "${assets_path}/startImage.imageset"
            fi
         done
     fi
  done
done

