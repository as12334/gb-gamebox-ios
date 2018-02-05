//
//  RH_MPSiteMessageHeaderView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPSiteMessageHeaderView.h"
#import "coreLib.h"
@interface RH_MPSiteMessageHeaderView()
@property (nonatomic,assign)BOOL choceMark;
@property (weak, nonatomic) IBOutlet UIImageView *allSelectedImageView;
@property (weak, nonatomic) IBOutlet UIButton *deletedBtn;
@property (weak, nonatomic) IBOutlet UIButton *readMarkBtn;

@end
@implementation RH_MPSiteMessageHeaderView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.choceMark=YES;
        self.backgroundColor = colorWithRGB(242, 242, 242);
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.deletedBtn.layer.cornerRadius = 4.f;
    self.deletedBtn.layer.borderColor = colorWithRGB(226, 226, 226).CGColor;
    self.deletedBtn.layer.borderWidth = 1.f;
    self.deletedBtn.layer.masksToBounds = YES;
    [self.deletedBtn setTitleColor:colorWithRGB(51, 51, 51) forState:UIControlStateNormal];
    [self.deletedBtn setBackgroundColor:colorWithRGB(255, 255, 255)];
    self.readMarkBtn.layer.cornerRadius = 4.f;
    self.readMarkBtn.layer.borderColor = colorWithRGB(226, 226, 226).CGColor;
    self.readMarkBtn.layer.borderWidth = 1.f;
    self.readMarkBtn.layer.masksToBounds = YES;
    [self.readMarkBtn setTitleColor:colorWithRGB(51, 51, 51) forState:UIControlStateNormal];
    [self.readMarkBtn setBackgroundColor:colorWithRGB(255, 255, 255)];
     self.allChoseBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [self.allChoseBtn setTitleColor:colorWithRGB(51, 51, 51) forState:UIControlStateNormal];
    self.allChoseBtn.titleLabel.layoutMargins= UIEdgeInsetsMake(0, 20, 0, 0);
    self.allSelectedImageView.layer.cornerRadius = 4.f;
    self.allSelectedImageView.layer.borderColor = colorWithRGB(226, 226, 226).CGColor;
    self.allSelectedImageView.layer.borderWidth = 1.f;
    self.allSelectedImageView.layer.masksToBounds = YES;
    if (self.choceMark==YES) {
        [self.allChoseBtn setTitle:@"全选" forState:UIControlStateNormal];
        self.allSelectedImageView.image = nil;
    }
    else if (self.choceMark ==NO){
    [self.allChoseBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        self.allSelectedImageView.image = [UIImage imageNamed:@"choose"];
    }
    else if (self.choceMark!=NO&&self.choceMark!=YES){
        [self.allChoseBtn setTitle:@"全选" forState:UIControlStateNormal];
        self.allSelectedImageView.image = nil;
    }
    
}
-(void)setStatusMark:(BOOL)statusMark
{
    _statusMark = statusMark;
    self.choceMark = _statusMark;
    if (self.choceMark==YES) {
        [self.allChoseBtn setTitle:@"全选" forState:UIControlStateNormal];
        self.allSelectedImageView.image = nil;
        
    }
    else if (self.choceMark ==NO){
        [self.allChoseBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        self.allSelectedImageView.image = [UIImage imageNamed:@"choose"];
    }
}
- (IBAction)deleteChooseOnCell:(id)sender {
    ifRespondsSelector(self.delegate, @selector(siteMessageHeaderViewDeleteCell:)){
        [self.delegate siteMessageHeaderViewDeleteCell:self] ;
    }
}
- (IBAction)markReadClick:(id)sender {
    ifRespondsSelector(self.delegate, @selector(siteMessageHeaderViewReadBtn:)){
        [self.delegate siteMessageHeaderViewReadBtn:self] ;
    }
}
- (IBAction)allChoseBtnClick:(id)sender {
    if (self.choceMark==YES) {
        ifRespondsSelector(self.delegate, @selector(siteMessageHeaderViewAllChoseBtn:)){
            [self.delegate siteMessageHeaderViewAllChoseBtn:self.choceMark];
        }
         [self.allChoseBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        self.allSelectedImageView.image = [UIImage imageNamed:@"choose"];
        self.choceMark=NO;
    }
    else if (self.choceMark==NO){
        ifRespondsSelector(self.delegate, @selector(siteMessageHeaderViewAllChoseBtn:)){
            [self.delegate siteMessageHeaderViewAllChoseBtn:self.choceMark];
        }
        [self.allChoseBtn setTitle:@"全选" forState:UIControlStateNormal];
        self.allSelectedImageView.image = nil;
        self.choceMark=YES;
    }
}

@end
