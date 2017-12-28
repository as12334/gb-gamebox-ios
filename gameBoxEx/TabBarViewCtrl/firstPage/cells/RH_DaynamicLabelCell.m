//
//  RH_DaynamicLabelCell.m
//  lotteryBox
//
//  Created by luis on 2017/12/10.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_DaynamicLabelCell.h"
#import "coreLib.h"

@interface  RH_DaynamicLabelCell()
@property(nonatomic,strong) IBOutlet CLLabel *labRemark;
@property(nonatomic,strong,readonly) UIView *scrollView ;
@property(nonatomic,strong,readonly) UILabel *labScrollText;
@property(nonatomic,assign) CGSize textSize;
@property(nonatomic,assign) BOOL isAnimation;

@end

@implementation RH_DaynamicLabelCell
@synthesize labScrollText  =_labScrollText              ;
@synthesize scrollView = _scrollView                    ;

+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 30.0f ;
}

#pragma mark-
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor] ;
    self.contentView.backgroundColor = colorWithRGB(239, 239, 239) ;
    self.labRemark.intrinsicSizeExpansionLength = CGSizeMake(5, 5) ;
    self.labRemark.backgroundColor = colorWithRGB(59, 142, 238) ;
    self.labRemark.textColor = [UIColor whiteColor] ;
    self.labRemark.font = [UIFont systemFontOfSize:14.0f] ;
    self.labRemark.layer.cornerRadius = 2.0f ;
    self.labRemark.text = @"公告" ;
    [self.scrollView addSubview:self.labScrollText];
    [self.contentView addSubview:self.scrollView] ;
    
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine ;
    self.separatorLineColor = RH_Line_DefaultColor ;
    self.separatorLineWidth = 1.0f ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.labScrollText.text = @"abcdefg你上课可是你的拿到了" ;
    self.textSize = caculaterLabelTextDrawSize(self.labScrollText.text, self.labScrollText.font, 0.0f) ;
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
    [UIView animateWithDuration:10//动画持续时间
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
    if (!_labScrollText){
        _labScrollText = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
        _labScrollText.textColor = colorWithRGB(51, 51, 51);
        _labScrollText.font = [UIFont systemFontOfSize:12.0f] ;
    }
    
    return  _labScrollText ;
}
-(UIView *)scrollView
{
    if (!_scrollView){
        _scrollView = [[UIView alloc] initWithFrame:CGRectMake(50,0,self.contentView.frame.size.width,30)];
        _scrollView.backgroundColor = RH_View_DefaultBackgroundColor ;
        _scrollView.layer.masksToBounds = YES ;
    }
    
    return  _scrollView ;
}

@end