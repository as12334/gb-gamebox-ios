# !/bin/sh

#  package.sh
#  gameBoxEx
#
#  Created by luis on 2017/10/18.
#  Copyright © 2017年 luis. All rights reserved.

# :<<eof
# eof

#自定义要编译打包的数据
# configuration_list=('_DEBUG' '_98jb')
configuration_list=(  \
    # '_0001^1^"超博娱乐"'  \
    # '_1qkq^65^"宏图娱乐"'  \
    # '_8l6r^71^"超博娱乐"'  \
    # '_8l6r^71^"超博娱乐"'  \
    # '_osxg^218^"永利娱乐城"'  \
    # '_qec8^517^"澳门金沙娱乐城"'  \
    # '_a56r^189^"澳门永利贵宾会"'  \
    # '_npsa^208^"彩中彩"'  \
    # '_ys3q^118^"澳门星际娱乐"'  \
    # '_kgu6^368^"爵士城"'  \
    # '_pnuw^121^"太阳城集团"'  \
    # '_w7ls^217^"众盈国际"'  \
    # '_q6gw^325^"澳门威尼斯人"'  \
    # '_jeia^339^"澳门新葡京官方授权直营网"'  \
    # '_yrdy^220^"皇朝娱乐"'  \
    # '_xjvs^195^"大唐娱乐城"'  \
    # '_hihk^141^"BET365"'  \
    # '_vbgt^142^"澳门新葡京娱乐场"'  \
    # '_yytt^117^"澳门威尼斯人"'  \
    # '_4w3g^181^"超博娱乐"'  \
    # '_ixyu^229^"众博国际娱乐城"'  \
    # '_x1dv^177^"澳门威尼斯人娱乐场"'  \
    # '_oiqg^226^"新葡京娱乐场"'  \
    # '_gwkk^225^"澳门永利娱乐场"'  \
    # '_j1ms^352^"威尼斯人娱乐城"'  \
    # '_lnd9^206^"葡京国际"'  \
    # '_gc7p^192^"星河娱乐城"'  \
    # '_mppv^371^"澳门新葡京娱乐城"'  \
    # '_llnd^388^"钱柜娱乐"'  \
    # '_xrql^322^"TSV天时娱乐"'  \
    # '_zrax^271^"VIPBET"'\
    # '_uvvu^522^"澳门银河娱乐城"'  \
    # '_yj4v^190^"万博体育"'  \
    # '_xngu^301^"亚洲娱乐"'\
    # '_cspr^235^"美高梅娱乐城"'  \
    # '_q1mv^268^bet365'\
    # '_dufx^372^"腾龙国际"'  \
    # '_vyx1^360^"大大彩票"'  \
    # '_ajco^396^"新葡京娱乐城"'  \
    # '_xmpk^510^"奥林匹克娱乐城"'  \
    # '_pgvj^509^"阿德国际"'  \
    # '_XH5Z^76^"澳门永利"'  \
    # '_n0pd^380^"永利娱乐场"'  \
    # '_n5gl^358^"澳门威尼斯人"'  \
    # '_miv5^135^"澳门金沙娱乐场"'  \
    # '_6rrt^196^"澳门巴黎人"'  \
    # '_hzy3^167^"澳门新葡京赌场"'  \
    # '_8egp^376^"VNS娱乐城"'  \
    # '_ionm^221^"澳门金沙娱乐场"'  \
    # '_idr9^228^"亚盈国际"'  \
    # '_suxr^377^"澳门巴黎人"'  \
    # '_rosz^179^"澳门威尼斯人"'  \
    # '_vtfw^201^"澳门威尼斯人"'  \
    # '_e2ce^251^"威尼斯人"'  \
    # '_djig^321^"新澳门娱乐城"'  \
    # '_nnop^351^"五环娱乐"'  \
    # '_izlr^503^"澳门威尼斯人"'  \
    # '_aioz^512^"九州国际"'  \
    # '_lont^168^"澳门威尼斯人"'  \
    # '_cwad^186^"赛博体育"'  \
    # '_ex57^516^"皇家娱乐城"'  \
    # '_r54t^316^"澳门新葡京娱乐城"'  \
    # '_wbzt^356^"澳门永利集团"'  \
    # '_vksg^369^"新葡京娱乐场"'  \
    # '_qgjl^176^"全胜娱乐"'  \
    # '_tcjp^219^"鼎彩国际"'  \
    # '_cbe1^216^"COD娱樂"'  \
    # '_wnmt^257^"盛大国际"'  \
    # '_5zx5^365^"BET365"'  \
    # '_mmrx^523^"澳门威尼斯人"'  \
    # '_0ru7^266^"太阳城集团"'\
    # '_7ybc^269^"金沙娱乐城"'\
    # '_x3wl^311^"永利国际"'  \
    # '_0chi^317^"葡京娱乐场"'  \
    # '_9tjq^328^"全民体育"'  \
    # '_ghng^329^"金汇国际"'  \
    # '_kbmv^338^"澳门银河赌场"'  \
    # '_dllb^355^"金沙娱乐场"'  \
    # '_r4pf^363^"胜益国际娱乐"'  \
    # '_wrde^381^"胜通国际娱乐城"'  \
    # '_3mdk^382^"皇家俱乐部"'  \
    # '_4pja^383^"新葡京娱乐城"'  \
    # '_fap9^506^"威尼斯人娱乐城"'  \
    # '_45jj^508^"澳门金沙娱乐场"'  \
    # '_jtet^513^"新濠天地"'  \
    # '_rl4o^515^"AUY澳盈"'  \
    # '_87lr^233^"金沙娱乐城"'  \
    # '_wlf6^238^BET365'  \
    # '_ptmx^399^"世茂国际娱乐"'  \
    # '_ihqx^171^"宝开娱乐"'  \
    # '_r7pt^230^"金沙娱乐城"' \
    # '_sv8i^306^"银河娱乐城"'\
    # '_iugy^318^"澳门太阳城"'  \
    # '_urbr^198^"澳门金沙娱乐场"'  \
    # '_mqsb^527^"澳门威尼斯人"'  \
    # '_duzr^163^FUNGAME'  \
    # '_7rda^253^"澳门威尼斯人"'  \
    # '_wjxd^392^"bet365"'  \
    # '_nu9r^119^UEDBET'  \
    # '_5rdu^136^"澳门威尼斯人"'  \
    # '_3qj8^211^"BET365"'  \
    # '_57h0^270^LOVEBET'\
    # '_n0o7^161^"bet365亚洲官网"'  \
    # '_nrpf^183^"美高梅赌场"'  \
    # '_n5ns^199^"澳门威尼斯人"'  \
    # '_5br6^530^"非凡国际"'  \
    # '_we64^310^"萬象城国际"'  \
    # '_cdrx^302^"澳门新葡京电玩城"'\
    # '_mpyz^305^"澳门娱乐城"'\
    # '_rqcc^272^"金沙娱乐场"'\
    # '_zqq5^155^"澳门银河娱乐城"'  \
    # '_jzgy^260^"拉斯维加斯"'  \
    # '_rb4b^330^"澳门银河线上赌场"'  \
    # '_g2mj^350^"新博娱乐"'  \
    # '_lt1x^359^"金鹰国际"'  \
    # '_mkoz^227^"银河娱乐城"'  \
    # '_8gez^236^"拉斯维加斯国际"'  \
    # '_x70n^265^"葡京娱乐场"'\
    # '_xmwf^261^"澳门威尼斯人"' \
    # '_ma0e^526^"澳门威尼斯人"'  \
    # '_akm1^237^"金沙娱乐城"'  \
    # '_acpb^188^"鸿泰国际"'  \
    # '_72wu^387^"百乐"'  \
    # '_unje^379^"99彩票网"'  \
    # '_lboi^511^"繁星国际"'  \
    # '_ixpm^130^"澳门新葡京"'  \
    # '_jwdg^113^"伟德娱乐"'  \
    # '_ix2i^140^"澳门威尼斯人"'  \
    # '_no9y^313^"巴黎人贵宾会"'  \
    # '_seck^123^"皇家赌场"'  \
    # '_98ph^124^"澳门金沙"'  \
    # '_dpmi^303^"银河娱乐场官网"'\
    # '_7dfu^307^"云顶至尊娱乐城"'\
    # '_feas^366^"澳门威尼斯人"'  \
    # '_wzt8^332^"金尊娱乐城"'  \
    # '_whk7^326^"澳门百乐门娱乐城"'  \
    # '_xwc7^133^"澳门威尼斯人"'  \
    # '_covy^370^"皇冠娱乐城"'  \
    # '_1xtq^385^"大庄家娱乐城"'  \
    # '_eobp^505^"威尼斯人"'  \
    # '_xc95^367^"星空娱乐城"'  \
    # '_nekt^323^"澳门巴黎人"'  \
    # '_pf8z^327^"威尼斯人娱乐城"'  \
    # '_5e7b^239^"云顶娱乐"'  \
    # '_tw1z^362^"万事达娱乐城"'  \
    # '_87y8^529^"抖音娱乐"'  \
    # '_huih^320^"澳门新葡京赌场"'  \
    # '_pox4^252^"COBO超博"' \
    # '_sogq^373^"太阳娱乐城"'  \
    # '_gvzi^375^"威尼斯人娱乐城"'  \
    # '_yym8^391^"趣博娱乐"'  \
    # '_palx^390^"大興娱乐"'  \
    # '_838o^502^"皇冠现金网"'  \
    # '_sa7t^518^"亿豪国际"'  \
    # '_jr3j^173^"濠利会娱乐城"'  \
    # '_j8kq^337^"澳门威尼斯人"'  \
    # '_opmi^357^"永利娱乐城"'  \
    # '_wjrd^395^"双赢国际城"'  \
    '_2x6s^525^"澳门威尼斯"'  \
    # '_sy7u^335^"恒大娱乐城"'  \
    # '_1mw8^361^"海皇亚洲"' \
    # '_nkwz^393^"BB娱乐城"'  \
    # '_n6pg^263^"太阳城集团"' \
    # '_nt6y^262^"必博"' \
    # '_xmil^156^"新葡京娱乐场"'  \
    # '_uhte^157^"澳门金沙赌场"'  \
    # '_u0er^507^"乐鼎国际娱乐"'  \
    # '_skab^501^"金尊娱乐城"'  \
    # '_fluv^333^"大赢家娱乐城"'  \
    # '_whsl^308^"澳门威尼斯人"'  \
    # '_wqck^353^"bet365"'  \
    # '_d1hg^191^"澳门赌场"'  \
    # '_bgst^162^"葡京娱乐场"'  \
    # '_hnvv^336^"CH娱乐城"'  \
    # '_gplw^389^"波贝娱乐城"'  \
    # '_i63i^398^"澳门新葡京"'  \
    # '_2etb^521^"太阳城集团"'  \
    # '_pvbs^528^"大富豪娱乐城"'  \
    # '_5jko^531^"澳门金沙娱乐城"'  \
    # '_arau^209^"lovebet爱博"'  \
    # '_13gs^532^"威尼斯人娱乐城"'  \
    # '_fhfd^533^"环宇国际"'  \
    # '_0ltm^535^"永利娱乐场"'  \
    # '_xngr^536^"大西洋娱乐城"'  \
    # '_clfb^537^"鑫濠天地"'  \
    # '_ovgr^538^"恒鑫互娱"'  \
    # '_rbld^520^"绝地求生"'  \
    # '_z3vd^519^"手中世界"'  \
    # '_zbtq^539^"威尼斯人"'  \
    # '_bqub^550^"云顶娱乐城"'  \
    # '_zwue^551^"太阳城集团"'  \
    # '_o7wq^552^"博赢国际"'  \
    # '_ayzb^555^"澳门威尼斯人"'  \
    # '_ava3^556^"多多博"'  \
    # '_pqgn^557^"云顶国际"'  \
    # '_f6gu^558^"澳门新葡京娱乐城"'  \
    # '_yodd^559^"百胜娱乐城"'  \
    # '_nrfn^560^"王牌国际"'  \
    # '_rucr^565^"永利娱乐城"'  \
    # '_ywi5^563^"澳门巴黎人"'  \
    # '_zekm^561^"盈凤凰娱乐城"'  \
    # '_glym^568^"太阳城集团"'  \
    # '_kizq^567^"澳门葡京"'  \
    # '_9sgz^569^"彩盟娱乐"'  \
    # '_tbxz^553^"澳盈"'  \
    # '_xzqz^570^"皇家娱乐城"'  \
    # '_zm3w^577^"东利娱乐"'  \
    # '_91ea^571^"皇冠娱乐城"'  \
    # '_vxcb^231^"新濠国际"'  \
    # '_mrle^572^"盛乾娱乐城"'  \
    # '_hz3b^578^"太阳城集团"'  \
    # '_uesp^576^"新葡京娱乐场"'  \
    # '_1kfc^573^"YY678娱乐城"'  \
    # '_maoy^579^"澳门银河"'  \
    # '_xguf^580^"澳门银河"'  \
    # '_xmjq^582^"大红鹰娱乐城"'  \
    # '_oqpv^575^"迪士尼国际娱乐城"'  \
    # '_ktal^581^"众博国际"'  \
    # '_rjgk^583^"新葡京娱乐场"'  \
    # '_kqv5^585^"澳门威尼斯人赌场"'  \
    # '_taxv^586^"宝能娱乐"'  \
    # '_hpvl^588^"星河国际"'  \
    # '_jkkx^587^"世界城国际娱乐城"'  \
    # '_vygf^589^"bet365"'  \
    # '_51fz^590^"王者娱乐"'  \
    # '_mc2v^592^"澳门御匾会"'  \
    # '_cghg^593^"新橙娱乐"'  \
    # '_elsd^595^"龙e"'  \
    # '_atrf^591^"拉斯维加斯"'  \
    # '_wopw^596^"金沙娱乐城"'  \
    # '_s90r^598^"戰神國際"'  \
    # '_udpt^599^"澳门新葡京"'  \
    # '_yyvd^597^"易博"'  \
    # '_35vx^601^"鸿盛国际"'  \
    # '_ulub^602^"澳门新葡京"'  \
    # '_ra3c^603^"澳门星际娱乐"'  \
    # '_gm5w^397^"聚福国际"'  \
    # '_81m3^600^"澳门美高梅娱乐城"'  \
    # '_pf6g^606^"天美娱乐"'  \
    # '_iei4^605^"金沙娱乐"'  \
    # '_jktb^607^"恒利"'  \
    # '_tjyo^608^"朝盈集团"'  \
    # '_k5sg^609^"新葡京"'  \
    # '_jwki^566^"七星娱乐"'  \
    # '_2d4n^610^"九五至尊"'  \
    # '_pse0^611^"万博体育"'  \
    # '_qlms^612^"新葡京娱乐城"'  \
    # '_tdlt^615^"金沙娱乐城"'  \
    # '_kdli^616^"环球娱乐"'  \
    # '_3hld^613^"手中世界"'  \
    # '_cepa^617^"博赢彩票"'  \
    # '_4bzo^619^"永利娱乐城"'  \
    # '_aba6^620^"天宏娱乐"'  \
    # '_q9uv^618^"万发娱乐"'  \
    # '_7zn0^622^"新盈博国际"'  \
    # '_3qzt^623^"金沙娱乐城"'  \
    # '_pfx2^627^"bet365"'  \
    # '_drxn^628^"易胜博"'  \
    # '_p3xh^630^"澳门美高梅赌场"'  \
    # '_3tnr^631^"新葡京集团"'  \
    # '_eqr7^632^"太阳城娱乐"'  \
    # '_fy8f^633^"皇朝娱乐"'  \
    # '_3hld^613^"手中世界"'  \
    # '_4bzo^619^"永利娱乐城"'  \
    # '_kzpl^638^"澳门国际"'  \
    # '_1kdc^636^"太阳城娱乐城"'  \
    # '_04du^639^"澳门威尼斯人"'  \
    # '_nbyt^637^"新葡京娱乐城"'  \
    # '_eiz9^653^"澳门美高梅娱乐场"'  \
    # '_u1o1^656^"众乐娱乐"'  \
    # '_mz0n^655^"添好运"'  \
    # '_b8gi^659^"星际娱乐城"'  \
    # '_y0hn^660^"电子娱乐"'  \
    # '_0zir^657^"澳门威尼斯人"' \
    #  '_reft^315^"五福彩票"' \
    # '_sftj^650^"新葡京娱乐场"' \
    # '_dvzh^662^"澳门银河赌场"' \
    # '_f7hi^665^"澳门金沙娱乐城"' \

  )

shell_path=$(cd "$(dirname "$0")";pwd)
uplevel_path=${shell_path%/*}
#自定义project 相关信息 
project_path="${shell_path}"
project_name='gameBoxEx'
app_version='4.0.1'

archieve_path="${uplevel_path}/product_achive"
exportipa_path="${uplevel_path}/product_package"
exportOptionsPlist_file="${shell_path}/exportOptionPlist.plist"

#switch to project folder
cd ${project_path} 

#清理工程
xcodebuild clean || exit

#去掉xcode源码末尾的空格
# find . -name "*.[hm]" | xargs sed -Ee 's/ +$//g' -i ""

#备份 配制文件
pbxcproj_file=${project_path}/${project_name}.xcodeproj/project.pbxproj
_backTmp_name="`date '+%Y-%m-%d-%H%M%S'`" 
pbxcproj_file_back=${pbxcproj_file}.${_backTmp_name} 

#修改configuration
function replace_build() {
    src_str=${2}
    dest_str=${3}
#    echo "replace_build target: ${1},target_file: ${target_file},src_str: ${src_str},dest_str: ${dest_str}"

    sed -i.zztmp "s|\(${src_str}\).*$|\1 = ${dest_str}|g"  ${pbxcproj_file}
    rm "${pbxcproj_file}.zztmp" > /dev/null 2>&1
}

#在生成前 先清除exportipa_path 里的内容 
rm -rf ${exportipa_path}

for num in "${configuration_list[@]}"; do

  #先copy pbproj file .
  cp  $pbxcproj_file  $pbxcproj_file_back
  
  #传入configuration
  configuration_name=$num

  _macrokey=${num%%^*}          ##取macro default
  _appname=${num##*^}         ##取app显示名称
  _sidvalue=${num#*${_macrokey}^}   ##取sid value
  _sidvalue=${_sidvalue%%^*}

  echo "_macrokey :"${_macrokey}
  echo "_sidvalue :"${_sidvalue}
  echo "_appname :"${_appname}
  echo "_regixappname :"${_regixappname}

  #修改配制
  sid=${_sidvalue}
  app_icon="\"AppIcon-"${_sidvalue}"\""
  pre_macro="\""${_macrokey}"=1\""
  app_name=${_appname}
  app_bundle_id="com.dawoo.gamebox.sid"${_sidvalue}

  echo "sid:"${sid}
  echo "app_icon:"${app_icon}
  echo "pre_macro:"${pre_macro}
  echo "app_name:"${app_name}
  echo "app_bundle_id:"${app_bundle_id}
  echo "shell_path:"${shell_path}
  echo "uplevel_path:"${uplevel_path}

  #修改工程sid文件的值
  echo ${sid} > "${project_path}/sid"

  #修改pbxcproj文件的值
  replace_build ${pbxcproj_file} 'ASSETCATALOG_COMPILER_APPICON_NAME' "AppIcon"";" #modify by Shin 图标名称不变 只是更换不同的图片
  replace_build ${pbxcproj_file} 'GCC_PREPROCESSOR_DEFINITIONS' ${pre_macro}";"
  replace_build ${pbxcproj_file} 'APP_DISPLAY_NAME' ${app_name}";"
  replace_build ${pbxcproj_file} 'PRODUCT_BUNDLE_IDENTIFIER' ${app_bundle_id}";"
  replace_build ${pbxcproj_file} 'GCC_OPTIMIZATION_LEVEL'  "s;"

  #生成临时的archieve name
  archieve_name="`date '+%Y-%m-%d-%H%M%S'`" 
  # archieve_name=${_sidvalue}${_macrokey}
  # exportipa_folder=${archieve_name}${_macrokey}${_sidvalue}
  exportipa_folder=${_macrokey##*_}

  #编译工程 archieve
  xcodebuild archive -project ${project_path}/${project_name}.xcodeproj -scheme ${project_name}  \
  -configuration Release -archivePath ${archieve_path}/${archieve_name}.xcarchive \
  -allowProvisioningUpdates


  #打包工程
  xcodebuild -exportArchive -archivePath ${archieve_path}/${archieve_name}.xcarchive  \
  -exportPath ${exportipa_path}/${exportipa_folder} \
  -exportOptionsPlist ${exportOptionsPlist_file}  \
  -allowProvisioningUpdates

  #导出plist文件
  curl -o plist.tmp -d 'siteId='$sid'&version='$app_version https://gbboss.com:1344/boss-api/app/package/createPlist.html
  cat plist.tmp | jq -r .[0].plistStr > ${exportipa_path}/${exportipa_folder}/app${_macrokey}_${app_version}.plist

  #清除多余的文件
  rm -f ${exportipa_path}/${exportipa_folder}/DistributionSummary.plist
  rm -f ${exportipa_path}/${exportipa_folder}/ExportOptions.plist
  rm -f ${exportipa_path}/${exportipa_folder}/Packaging.log

  #rename ipa file
  oldname_ipa=${exportipa_path}/${exportipa_folder}/*.ipa
  newname_ipa=${exportipa_path}/${exportipa_folder}/app${_macrokey}_${app_version}.ipa
  mv $oldname_ipa $newname_ipa

  #重置 配制文件
  mv -f $pbxcproj_file_back $pbxcproj_file
done
echo end
