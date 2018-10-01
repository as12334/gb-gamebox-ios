//
//  RH_NewHelpCenterDetailHeaderView.m
//  gameBoxEx
//
//  Created by richard on 2018/10/1.
//  Copyright © 2018 luis. All rights reserved.
//

#import "RH_NewHelpCenterDetailHeaderView.h"
#import "coreLib.h"


@interface RH_NewHelpCenterDetailHeaderView ()

@property (nonatomic,strong) UIImageView *directionImageView;

@end

@implementation RH_NewHelpCenterDetailHeaderView
{
    UIButton *_button ;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setupItems];
    }
    return self;
}


- (void)setupItems{
    
    //右上角箭头图片
    self.directionImageView.image = [UIImage imageNamed:@"brand_expand"];
    self.directionImageView.frame = CGRectMake(screenSize().width - 30, (44-8)/2, 15, 8);
    [self.contentView addSubview:self.directionImageView];
    
    //btn覆盖header,相应点击
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 34.f*WIDTH_PERCENT)];
    button.backgroundColor = [UIColor clearColor];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft ;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f] ;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0) ;
    [button setTitleColor:colorWithRGB(23, 102, 187) forState:UIControlStateNormal] ;
    [self.contentView addSubview:button];
    [button addTarget:self action:@selector(headerClick:) forControlEvents:UIControlEventTouchUpInside];
    self.contentView.backgroundColor = [UIColor whiteColor];
    _button = button ;
    
    UILabel *lineLab = [UILabel new] ;
    [self.contentView addSubview:lineLab];
    lineLab.frame = CGRectMake(0, 34.f*WIDTH_PERCENT, screenSize().width, 0.5) ;
    lineLab.backgroundColor = colorWithRGB(239, 239, 239) ;;
    
}

- (void)headerClick:(UIButton *)btn{
    
    self.sectionModel.isExpanded = !self.sectionModel.isExpanded;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        if (!self.sectionModel.isExpanded) {
            self.directionImageView.transform = CGAffineTransformIdentity;
            
        }else{
            self.directionImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }
    }];
    
    if (self.HeaderClickedBack) {
        
        self.HeaderClickedBack(self.sectionModel.isExpanded);
    }
    
    
}



- (UIImageView *)directionImageView{
    
    
    if (!_directionImageView) {
        
        _directionImageView = [[UIImageView alloc] init];
    }
    
    return _directionImageView;
}


-(void)setSectionModel:(RH_HelpCenterDetailModel *)sectionModel
{
    _sectionModel = sectionModel;
    [_button setTitle:sectionModel.helpTitle forState:UIControlStateNormal] ;
    if (!_sectionModel.isExpanded)
    {
        self.directionImageView.transform = CGAffineTransformIdentity;
    }
    else
    {
        self.directionImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
    
}


@end
