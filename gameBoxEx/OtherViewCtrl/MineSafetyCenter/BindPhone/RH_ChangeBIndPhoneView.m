//
//  RH_ChangeBIndPhoneView.m
//  gameBoxEx
//
//  Created by shin on 2018/6/8.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ChangeBIndPhoneView.h"
#import "MacroDef.h"

@interface RH_ChangeBIndPhoneView() <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phoneNumLB;
@property (weak, nonatomic) IBOutlet UIButton *changeBindBT;
@property (weak, nonatomic) IBOutlet UITextView *noticeLB;

@end

@implementation RH_ChangeBIndPhoneView

- (IBAction)changeAction:(id)sender {
    ifRespondsSelector(self.delegate, @selector(changBindUserPhoneChangeBind:))
    {
        [self.delegate changBindUserPhoneChangeBind:self];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.changeBindBT.layer.cornerRadius = 4;
    self.changeBindBT.clipsToBounds = YES;
    [self setupNoticeText];
}

- (void)setThemeColor:(UIColor *)themeColor
{
    _themeColor = themeColor;
    [self.changeBindBT setBackgroundColor:_themeColor];
}

- (void)setPhone:(NSString *)phone
{
    _phone = phone;
    self.phoneNumLB.text = _phone;
}

-(void)setupNoticeText{
    // 设置属性
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 设置行间距
    paragraphStyle.paragraphSpacing = 2; // 段落间距
    paragraphStyle.lineSpacing = 10;      // 行间距
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName:colorWithRGB(102,102, 102),
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:self.noticeLB.text attributes:attributes];
    [attrStr addAttributes:@{
                             NSLinkAttributeName:@"联系在线客服"
                             }
                     range:[self.noticeLB.text rangeOfString:@"联系在线客服"]];
    self.noticeLB.linkTextAttributes = @{NSForegroundColorAttributeName:colorWithRGB(23, 102, 187)};
    self.noticeLB.attributedText = attrStr;
    self.noticeLB.editable = NO;
    self.noticeLB.scrollEnabled = NO;
    self.noticeLB.delegate = self;
}

#pragma mark - UITextViewDelegate M

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    ifRespondsSelector(self.delegate, @selector(changBindUserPhoneContact:)){
        [self.delegate changBindUserPhoneContact:self];
    }
    return YES;
}
@end
