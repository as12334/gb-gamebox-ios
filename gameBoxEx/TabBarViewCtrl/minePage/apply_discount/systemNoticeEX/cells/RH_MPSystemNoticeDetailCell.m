//
//  RH_MPSystemNoticeDetailCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPSystemNoticeDetailCell.h"
#import "coreLib.h"
#import "RH_SystemNoticeDetailModel.h"
@interface RH_MPSystemNoticeDetailCell()<UIWebViewDelegate>



@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *topLine;

@property (weak, nonatomic) IBOutlet UIWebView *titleWebView;

@end
@implementation RH_MPSystemNoticeDetailCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return screenSize().height -15.f;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor] ;
    self.topLine.backgroundColor = colorWithRGB(226, 226, 226);
    self.topLine.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_Height(10);
    self.timeLabel.whc_TopSpaceToView(15, self.topLine).whc_RightSpace(10).whc_Height(20).whc_WidthAuto();
    self.titleWebView.whc_LeftSpace(0).whc_RightSpace(0).whc_TopSpaceToView(15, self.timeLabel).whc_HeightAuto();
    self.timeLabel.font = [UIFont systemFontOfSize:11.f] ;
    self.timeLabel.textColor = colorWithRGB(153, 153, 153);
    self.titleWebView.backgroundColor = [UIColor whiteColor] ;
    self.titleWebView.delegate = self;
    //隐藏webview底部的黑线
    self.titleWebView.opaque = NO;

}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_SystemNoticeDetailModel *detailModel = ConvertToClassPointer(RH_SystemNoticeDetailModel, context);
    [self.titleWebView loadHTMLString:detailModel.mContent baseURL:nil];
    self.timeLabel.text = dateStringWithFormatter(detailModel.mPublishTime, @"yyyy-MM-dd HH:mm:ss");
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //字体大小
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '70%'"];
    //字体颜色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'"];
    //页面背景色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#ffffff'"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
