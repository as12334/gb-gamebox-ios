/**
 * 显示登陆视图
 */
function showLoginView(){
    document.location="rhtask:showLoginView";
}

/**
 * 开始分享
 */
function beginShare(){
    document.location="rhtask:beginShare";
}

/**
 * 返回上一页
 */
function backToPrePage(){
    document.location="rhtask:backToPrePage";
}

/**
 * 复制
 */
function setClipboardInfo(getClipboardInfo) {
    document.location="rhtask:setClipboardInfo:" + getClipboardInfo;
}

/**
 * 复制
 */
function userAuthInvaild() {
    document.location="rhtask:userAuthInvaild";
}


