//
//  RH_RegistrationTopView.m
//  gameBoxEx
//
//  Created by richard on 2018/9/28.
//  Copyright © 2018 luis. All rights reserved.
//

#import "RH_RegistrationTopView.h"
#import "coreLib.h"

@interface RH_RegistrationTopView ()

@property(nonatomic,strong) CLLabel *labRemark;
@property(nonatomic,strong,readonly) UIView *scrollView ;
@property(nonatomic,strong,readonly) UILabel *labScrollText;
@property(nonatomic,assign) CGSize textSize;
@property(nonatomic,assign) BOOL isAnimation;

@end

@implementation RH_RegistrationTopView
{
    NSTimeInterval _dynamicTimeInterval ;
}
@synthesize labScrollText  =_labScrollText              ;
@synthesize scrollView = _scrollView                    ;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        _dynamicTimeInterval = 1.0f  ;// default ;
        self.backgroundColor = colorWithRGB(248, 181, 81) ;
        [self.scrollView addSubview:self.labScrollText];
        [self addSubview:self.scrollView] ;
        
        UIButton *closeBtn = [UIButton new] ;
        [self addSubview:closeBtn];
        closeBtn.whc_RightSpace(10).whc_CenterY(0).whc_Height(20).whc_Width(20) ;
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"home_cancel_white_icon"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside] ;
        
    }
    return self;
}

-(void)closeBtnClick
{
    [self setHidden:YES] ;
    ifRespondsSelector(self.delegate, @selector(registrationTopViewbcloseBtnDidClick))
    {
        [self.delegate registrationTopViewbcloseBtnDidClick] ;
    }
}


-(void)updateContentWithContext:(NSString *)context
{
    //.05
    NSString *strTmp = context ;
    strTmp = [strTmp stringByReplacingOccurrencesOfString:@"\n" withString:@""] ;
    strTmp = [strTmp stringByReplacingOccurrencesOfString:@"\r" withString:@""] ;
    if ([self.labScrollText.text isEqualToString:strTmp])
        return ;
    _dynamicTimeInterval = [strTmp lengthOfBytesUsingEncoding:NSUTF8StringEncoding] * .65;
    //    _dynamicTimeInterval = [strTmp lengthOfBytesUsingEncoding:NSUTF8StringEncoding] * .05  ;
    //    strTmp.length * 0.6 ;// 一个字符 0.5
    self.labScrollText.text = strTmp;
    self.labScrollText.font = [UIFont systemFontOfSize:14.f];
    self.labScrollText.textColor = [UIColor whiteColor];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f],};
    self.textSize = [self.labScrollText.text boundingRectWithSize:CGSizeMake(5000, 14) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    self.labScrollText.frame = CGRectMake(self.scrollView.frameWidth,
                                          floorf((self.scrollView.frameHeigh-self.textSize.height)/2.0),
                                          self.textSize.width,
                                          self.textSize.height) ;
}


#pragma mark-
-(void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow] ;
    if (newWindow){
        [self start];
    }
}

-(void)start{
    if (self.isAnimation) return ;
    [UIView animateWithDuration:_dynamicTimeInterval//动画持续时间
                          delay:0//动画延迟执行的时间
                        options:(UIViewAnimationOptionCurveLinear)//动画的过渡效果
                     animations:^{
                         self.isAnimation = YES ;
                         self.labScrollText.frame = CGRectMake(-self.textSize.width,
                                                               floorf((self.scrollView.frameHeigh-self.textSize.height)/2.0),
                                                               self.textSize.width,
                                                               self.textSize.height) ;
                     }completion:^(BOOL finished){
                         self.labScrollText.frame = CGRectMake(self.scrollView.frameWidth,
                                                               floorf((self.scrollView.frameHeigh-self.textSize.height)/2.0),
                                                               self.textSize.width,
                                                               self.textSize.height) ;
                         self.isAnimation = NO ;
                         if (self.window){
                             [self start];//动画执行完毕后的操作
                         }
                     }];
}

#pragma mark-
-(UILabel *)labScrollText
{
    if (!_labScrollText)
    {
        _labScrollText = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
        _labScrollText.textColor = [UIColor whiteColor] ;
        _labScrollText.font = [UIFont systemFontOfSize:14.0f] ;
    }
    return  _labScrollText ;
}
-(UIView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIView alloc] initWithFrame:CGRectMake(30,0,screenSize().width-80,30)];
        _scrollView.backgroundColor = [UIColor clearColor] ;
        _scrollView.layer.masksToBounds = YES ;
    }
    return  _scrollView ;
}
@end
