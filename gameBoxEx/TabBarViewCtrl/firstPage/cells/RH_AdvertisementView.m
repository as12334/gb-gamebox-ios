//
//  RH_AdvertisementView.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/29.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_AdvertisementView.h"
#import "coreLib.h"


@interface RH_AdvertisementView()<UIWebViewDelegate>
@end


@implementation RH_AdvertisementView
{
    UIView *contentView;
    UILabel *titleLab ;
    UIWebView *contentWebView ;
    UIButton *sureBtn ;
    UIButton *cancelButton ;
    RH_PhoneDialogModel *model ;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = ColorWithRGBA(134, 134, 134, 0.3);
        contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        contentView.whc_Center(0, 0).whc_Width(295).whc_Height(426);
        contentView.backgroundColor = colorWithRGB(255, 255, 255);
        contentView.layer.cornerRadius = 10;
        contentView.clipsToBounds = YES;
        
        
        titleLab = [[UILabel alloc] init];
        [contentView addSubview:titleLab];
        titleLab.whc_CenterX(0).whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_Height(37);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont systemFontOfSize:17];
        titleLab.textColor = colorWithRGB(51, 51, 51);
        titleLab.backgroundColor = colorWithRGB(242, 242, 242) ;
        
        UIView *contentBgView = [UIView new] ;
        [contentView addSubview:contentBgView] ;
        contentBgView.whc_TopSpaceToView(18, titleLab).whc_RightSpace(26).whc_LeftSpace(26).whc_BottomSpace(64) ;
        contentBgView.backgroundColor = colorWithRGB(242, 242, 242) ;
        contentBgView.layer.cornerRadius = 10 ;
        contentBgView.layer.masksToBounds = YES ;
        
        contentWebView = [UIWebView new] ;
        [contentBgView addSubview:contentWebView];
        contentWebView.backgroundColor = [UIColor clearColor] ;
        contentWebView.opaque = NO;
        contentWebView.delegate = self ;
        contentWebView.whc_LeftSpace(13).whc_TopSpace(18).whc_RightSpace(13).whc_Height(230);
        
        
        sureBtn = [[UIButton alloc] init] ;
        [contentView addSubview:sureBtn];
        sureBtn.whc_LeftSpace(39).whc_TopSpaceToView(15, contentWebView).whc_RightSpace(39).whc_Height(35) ;
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureBtn.layer.cornerRadius = 5;
        sureBtn.layer.masksToBounds = YES ;
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:14.f] ;
        [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
 
        cancelButton = [[UIButton alloc] init];
        if ([THEMEV3 isEqualToString:@"green"]){
            [cancelButton setImage:ImageWithName(@"home_announce_close_green") forState:UIControlStateNormal];
            sureBtn.backgroundColor = colorWithRGB(4, 109, 79);
        }else if ([THEMEV3 isEqualToString:@"red"]){
            [cancelButton setImage:ImageWithName(@"home_announce_close_red") forState:UIControlStateNormal];
            sureBtn.backgroundColor =RH_NavigationBar_BackgroundColor_Red;
            
        }else if ([THEMEV3 isEqualToString:@"black"]){
            //shaole
            [cancelButton setImage:ImageWithName(@"home_announce_close_black") forState:UIControlStateNormal];
        }else if ([THEMEV3 isEqualToString:@"orange"]){
            //shaole
            [cancelButton setImage:ImageWithName(@"home_announce_close_orange") forState:UIControlStateNormal];
            sureBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Orange;
        }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
            //shaole
            [cancelButton setImage:ImageWithName(@"home_announce_close_coffee") forState:UIControlStateNormal];
            sureBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Orange;
        }else{
            [cancelButton setImage:ImageWithName(@"home_announce_close_default") forState:UIControlStateNormal];
            sureBtn.backgroundColor = RH_NavigationBar_BackgroundColor;
        }
        [self addSubview:cancelButton];
        cancelButton.whc_TopSpaceToView(5, contentView).whc_CenterX(0).whc_Width(70).whc_Height(70);
        cancelButton.layer.cornerRadius = 35;
        self.clipsToBounds = YES;
        [cancelButton addTarget:self action:@selector(cancelButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)cancelButtonDidTap:(UIButton *)button {
    [self hideAdvertisementView] ;
}

-(void)advertisementViewUpDataWithModel:(RH_PhoneDialogModel *)phoneModel
{
    titleLab.text = phoneModel.name ;
    [contentWebView loadHTMLString:phoneModel.content baseURL:nil] ;
    [contentWebView reload];
    model = phoneModel ;
}
#pragma mark - 去除HTML标签
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

-(void)sureBtnClick:(UIButton *)sender
{
    if ([model.link isEqualToString:@""] || model.link == nil) {
        [self hideAdvertisementView] ;
    }else
    {
        ifRespondsSelector(self.delegate, @selector(advertisementViewDidTouchSureBtn:DataModel:)){
            [self.delegate advertisementViewDidTouchSureBtn:self DataModel:model] ;
        }
    }
}

-(void)hideAdvertisementView
{
    [UIView animateWithDuration:0.3 animations:^{
        contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        contentView.alpha =1;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    for (UIView *_aView in [contentWebView subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
            //右侧的滚动条
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
            [(UIScrollView *)_aView setAlwaysBounceHorizontal:NO];//禁止左右滑动
            //下侧的滚动条
            for (UIView *_inScrollview in _aView.subviews)
            {
                if ([_inScrollview isKindOfClass:[UIImageView class]])
                {
                    _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }
}


@end
