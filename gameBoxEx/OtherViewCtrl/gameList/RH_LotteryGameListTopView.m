//
//  RH_LotteryGameListTopView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/5.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_LotteryGameListTopView.h"
#import "coreLib.h"

@interface RH_LotteryGameListTopView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation RH_LotteryGameListTopView
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.whc_TopSpace(12).whc_LeftSpace(20).whc_RightSpace(20).whc_BottomSpace(5);
    self.button.whc_TopSpace(0).whc_RightSpace(0).whc_BottomSpace(0).whc_Width(60);
    self.textField.whc_TopSpace(0).whc_BottomSpace(0).whc_LeftSpace(0).whc_RightSpaceToView(0, self.button);
    self.textField.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.textField.layer.borderWidth = 1.0f;
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,10, self.textField.frame.size.height)];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.delegate = self;
    self.textField.textColor = colorWithRGB(204, 204, 204);
    self.contentView.layer.borderWidth = 1.0f ;
    self.contentView.layer.borderColor = colorWithRGB(204, 204, 204).CGColor ;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES ;
//    contentView.clipsToBounds = YES;
}

-(BOOL)isEdit
{
    return self.textField.isEditing ;
}

-(BOOL)endEditing:(BOOL)force
{
    [self.textField resignFirstResponder] ;
    return YES ;
}

#pragma mark-
-(NSString *)searchInfo
{
    return self.textField.text.length?[self.textField.text copy]:nil ;
}

- (IBAction)searchGame:(id)sender {
    ifRespondsSelector(self.delegate, @selector(lotteryGameListTopViewDidReturn:)){
        [self.delegate lotteryGameListTopViewDidReturn:self] ;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
