

#!/bin/sh

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
# '_rf80^21^"测试原生综合站"'  \
# '_8l6r^71^"全线综合站71"'  \
#  '_7cxt^69^"百发彩票"' \
# '_1wl5^70^"线上测试70"'  \
# '_8l6r^71^"线上v2-71"'  \
#  '_XH5Z^76^"澳门永利"'  \
# '_zmis^80^"测试站点三"'  \
#  '_cabu^110^"超博娱乐"'  \
#  '_74bk^111^"新葡京娱乐场"'  \
#  '_SNRM^112^"威尼斯人娱乐"'  \
#  '_jwdg^113^"伟德娱乐"'  \
#  '_ojlj^114^"澳门金沙娱乐场"'  \
#  '_bldz^116^"电子777娱乐"'  \
#  '_yytt^117^"澳门威尼斯人"'  \
#'_ys3q^118^"澳门星际娱乐"'  \
# '_nu9r^119^UEDBET'  \
#  '_cvqb^120^"演示站点"'  \
#120是演示站点
#'_pnuw^121^"太阳城集团"'  \
#'_seck^123^"皇家赌场"'  \
# '_98ph^124^"澳门金沙"'  \
#'_bqmn^125^"幸运彩票"'  \
#'_8wu8^126^"澳门永利娱乐城"'  \
#停用    '_xjc9^128^"新葡京娱乐场"'  \
#'_0a74^129^"新葡京娱乐城"'  \
#'_ixpm^130^"澳门新葡京"'  \
#'_xwc7^133^"澳门威尼斯人"'  \
#'_o7av^134^"澳门威尼斯人"'  \
# '_miv5^135^"澳门金沙娱乐场"'  \
#'_5rdu^136^"澳门威尼斯人"'  \
#'_ix2i^140^"澳门威尼斯人"'  \
#'_hihk^141^BET365'  \
#'_vbgt^142^"澳门新葡京娱乐场"'  \
#'_zhcu^143^"太阳城娱乐城"'  \
#'_zz1g^150^"威尼斯人"'  \
#停用    '_tloz^151^bet365'  \
#'_cqkv^153^"澳门威尼斯人"'  \
#'_zqq5^155^"澳门银河娱乐城"'  \
#'_xmil^156^"新葡京娱乐场"'  \
#'_uhte^157^"澳门金沙赌场"'  \
#'_7p44^158^"九狮国际娱乐城"'  \
#'_mhi7^159^"澳门威尼斯人赌场"'  \
#'_n0o7^161^"bet365亚洲官网"'  \
#'_bgst^162^"葡京娱乐场"'  \
#'_duzr^163^FUNGAME'  \
#'_g7oq^165^"澳门赌场"'  \
#'_hzy3^167^"澳门新葡京赌场"'  \
#'_lont^168^"澳门威尼斯人"'  \
#停用    '_c79k^169^"澳门银河在线赌场Casino"'  \
#'_ihqx^171^"宝开娱乐"'  \
# '_izbv^172^"豪森国际"'  \
#'_jr3j^173^"濠利会娱乐城"'  \
#'_x0le^175^"澳门银河娱乐城"'  \
# '_qgjl^176^"全胜娱乐"'  \
#'_x1dv^177^"澳门威尼斯人娱乐场"'  \
#'_ptxa^178^"点金坊"'  \
#'_rosz^179^"威尼斯人"'  \
#'_qfxk^180^"皇冠国际"'  \
#'_4w3g^181^"超博娱乐"'  \
#'_ixuf^182^"雄伟集团"'  \
#  '_nrpf^183^"美高梅赌场"'  \
#  '_fyxi^185^PhoenixGaming' \
#  '_cwad^186^"赛博体育"'  \
#  '_b02h^187^"澳门银河"'  \
# '_acpb^188^"鸿泰国际"'  \
# '_a56r^189^"澳门永利贵宾会"'  \
# '_yj4v^190^"万博体育"'  \
# '_d1hg^191^"澳门赌场"'  \
# '_gc7p^192^"星河娱乐城"'  \
#'_f9wn^193^"皇冠娱乐"'  \
#'_xjvs^195^"大唐娱乐城"'  \
#'_6rrt^196^"澳门巴黎人"'  \
#'_sn2m^197^"完美彩票"'  \
#'_urbr^198^"澳门金沙娱乐场"'  \
#'_n5ns^199^"澳门威尼斯人"'  \
#'_cghs^200^"钱多多娱乐城"'  \
#'_vtfw^201^"澳门威尼斯人"'  \
#'_ucuy^202^"博亿娱乐城"'  \
#'_q5tj^203^"中博娱乐城"'  \
#'_dfvp^205^"百乐博"'  \
#'_lnd9^206^"葡京国际"'  \
#'_xlei^207^BET365'  \
#'_npsa^208^"彩中彩"'  \
# '_arau^209^"大发OK"'  \
# '_1lgt^210^"威廉希尔"'  \
#'_3qj8^211^"大发OK"'  \
#'_cmu6^212^"金元宝娱乐城"'  \
#'_8y1c^213^"万豪国际"'  \
#'_mjiu^215^"盈泰娱乐"'  \
#'_cbe1^216^"COD娱樂"'  \
#'_w7ls^217^"云顶国际"'  \
#'_osxg^218^"永利娱乐城"'  \
#'_tcjp^219^"鼎彩国际"'  \
#'_yrdy^220^"皇朝娱乐"'  \
#'_ionm^221^"金沙娱乐场"'  \
#'_4hwq^222^"美高梅娱乐城"'  \
#'_elpc^223^"大咖汇"'  \
#'_gwkk^225^"永利娱乐城"'  \
#'_oiqg^226^"新葡京娱乐场"'  \
#'_mkoz^227^"银河娱乐城"'  \
#'_idr9^228^"亚盈国际"'  \
#'_ixyu^229^"美高梅娱乐城"'  \
#'_r7pt^230^"金沙娱乐城"' \
#'_vxcb^231^"新濠国际"'  \
#'_z1yn^232^"新亚洲"'  \
# '_87lr^233^"金沙娱乐城"'  \
#'_cspr^235^"美高梅娱乐城"'  \
#'_8gez^236^"拉斯维加斯国际"'  \
#'_akm1^237^"金沙娱乐城"'  \
#'_wlf6^238^BET365'  \
#'_5e7b^239^"云顶娱乐"'  \
#'_e2ce^251^"威尼斯人"'  \
#'_pox4^252^"COBO超博"' \
#'_7rda^253^"澳门威尼斯人"'  \
#'_p0a7^255^"澳门威尼斯人"'  \
#'_vqwq^256^"XB彩票"'  \
#'_wnmt^257^"盛大国际"'  \
#'_yqgk^258^"金凯娱乐"'  \
#'_jzgy^260^"拉斯维加斯"'  \
#nodefine    '_jzgy^260^"拉斯维加斯"'  \
#'_7vhp^800^"四海娱乐"'  \
#'_cx7r^801^"万达彩票"'  \
#'_98jb^802^"凤凰彩票"'  \
#'_yg9x^803^"头彩"'  \
#nodefine     '_s0sa^804^"亿彩汇"'  \
#'_yrxk^805^"亿彩汇"'  \
#'_2ztl^259^"新海天"' \
#'_xmwf^261^"澳门威尼斯人"' \
#'_nt6y^262^"9发bet"' \
#'_n6pg^263^"太阳城集团"' \
#'_ywo4^806^"万濠彩票"' \
#'_hjnl^807^"凤凰彩票"' \
# '_x70n^265^"澳门美高梅"'\
#'_0ru7^266^"太阳城集团"'\
#'_q1mv^268^bet365'\
#'_aqpd^808^"天天彩票"'\
#'_o3km^267^OPEBET'\
#'_57h0^270^LOVEBET'\
#'_7ybc^269^"金沙娱乐城"'\
#'_rqcc^272^"金沙娱乐场"'\
#'_zrax^271^VIPBET'\
# '_1pff^273^"太阳城集团"'\
# '_xngu^301^"亚洲娱乐"'\
# '_cdrx^302^"澳门新葡京电玩城"'\
# '_slla^300^"皇冠娱乐城"'\
# '_dpmi^303^"银河娱乐场官网"'\
# '_mpyz^305^"澳门娱乐城"'\
# '_sv8i^306^"银河娱乐城"'\
# '_7dfu^307^"云顶至尊娱乐城"'\
# '_whsl^308^"澳门威尼斯人"'  \
# '_5noo^309^"新葡京娱乐城"'  \
# '_x3wl^311^"永利国际"'  \
# '_we64^310^"萬象城国际"'  \
# '_mwve^312^"澳门巴黎人"'  \
# '_no9y^313^"巴黎人贵宾会"'  \
# '_reft^315^"澳门金沙"'  \
# '_iugy^318^"澳门太阳城"'  \
# '_w3ty^319^"太阳城集团"'  \
# '_r54t^316^"澳门新葡京娱乐城"'  \
# '_0chi^317^"威尼斯人娱乐城"'  \
# '_huih^320^"澳门新葡京赌场"'  \
# '_q6gw^325^"澳门威尼斯人"'  \
# '_whk7^326^"澳门百乐门娱乐城"'  \
# '_rb4b^330^"澳门银河线上赌场"'  \
# '_xdvv^331^"澳门金沙娱乐城"'  \
# '_wzt8^332^"金尊娱乐城"'  \
# '_sy7u^335^"恒大娱乐城"'  \
# '_fluv^333^"大赢家娱乐城"'  \
# '_hnvv^336^"CH娱乐城"'  \
# '_j8kq^337^"澳门威尼斯人"'  \
# '_kbmv^338^"澳门银河赌场"'  \
# '_jeia^339^"澳门新葡京官方授权直营网"'  \
#  '_g2mj^350^"新博娱乐"'  \
#  '_nnop^351^"五环娱乐"'  \
# '_wqck^353^"bet365"'  \
#  '_j1ms^352^"威尼斯人娱乐城"'  \
# '_dllb^355^"金沙娱乐场"'  \
# '_wbzt^356^"澳门美高梅"'  \
# '_opmi^357^"永利娱乐城"'  \
# '_n5gl^358^"澳门威尼斯人"'  \
#'_vyx1^360^"大大彩票"'  \
#'_tw1z^362^"澳门新葡京"'  \
# '_feas^366^"澳门威尼斯人"'  \
  )

#自定义project 相关信息
project_path='/Users/lewis/Documents/Project/gamesbox'
project_name='gameBoxEx'
app_version='3.0'

archieve_path='/Users/lewis/Desktop/product_achive'
exportipa_path='/Users/lewis/Desktop/product_package'
exportOptionsPlist_file='/Users/lewis/Documents/Project/exportOptionPlist.plist'


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

_macrokey=${num%%^*}                 ##取macro default
_appname=${num##*^}                    ##取app显示名称
_sidvalue=${num#*${_macrokey}^}     ##取sid value
_sidvalue=${_sidvalue%%^*}

echo "_macrokey :"${_macrokey}
echo "_sidvalue :"${_sidvalue}
echo "_appname :"${_appname}
echo "_regixappname :"${_regixappname}

#修改配制
sid="\""${_sidvalue}"\""
app_icon="\"AppIcon-"${_sidvalue}"\""
pre_macro="\""${_macrokey}"=1\""
app_name=${_appname}
app_bundle_id="com.dawoo.gamebox.sid"${_sidvalue}

echo "sid:"${sid}
echo "app_icon:"${app_icon}
echo "pre_macro:"${pre_macro}
echo "app_name:"${app_name}
echo "app_bundle_id:"${app_bundle_id}

replace_build ${pbxcproj_file} 'ASSETCATALOG_COMPILER_APPICON_NAME' ${app_icon}";"
replace_build ${pbxcproj_file} 'GCC_PREPROCESSOR_DEFINITIONS' ${pre_macro}";"
replace_build ${pbxcproj_file} 'APP_DISPLAY_NAME' ${app_name}";"
replace_build ${pbxcproj_file} 'PRODUCT_BUNDLE_IDENTIFIER' ${app_bundle_id}";"

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

