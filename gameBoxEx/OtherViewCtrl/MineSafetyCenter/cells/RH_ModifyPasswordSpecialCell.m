//
//  RH_ModifyPasswordSpecialCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/28.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ModifyPasswordSpecialCell.h"
#import "RH_ModifyPasswordCell.h"
#import "coreLib.h"

@interface RH_ModifyPasswordSpecialCell() <UITextFieldDelegate>




@end

@implementation RH_ModifyPasswordSpecialCell
{
    UILabel *label_Title;
    UILabel *label_tice;
    UILabel *label_One;
    UILabel *label_Two;
    UILabel *label_Three;
}
@synthesize textField = _textField;

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.textColor = colorWithRGB(153, 153, 153);
        _textField.secureTextEntry = YES;
        _textField.font = [UIFont systemFontOfSize:12];
    }
    return _textField;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context {
    return 70.f;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        label_Title = [[UILabel alloc] init];
        [self.contentView addSubview:label_Title];
        label_Title.whc_TopSpace(10).whc_LeftSpace(20).whc_Height(30).whc_WidthAuto();
        label_Title.font = [UIFont systemFontOfSize:12];
        label_Title.textColor = colorWithRGB(51, 51, 51);
        [self.contentView addSubview:self.textField];
        self.textField.whc_TopSpace(1).whc_RightSpace(20).whc_Height(39).whc_Width(screenSize().width/5*3);
        self.textField.delegate = self;
        [self.textField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventAllEvents];
        UIView *view_Back = [[UIView alloc]init];
        [self.contentView addSubview:view_Back];
        view_Back.whc_TopSpace(41).whc_LeftSpace(20).whc_RightSpace(20).whc_BottomSpace(0);
        view_Back.backgroundColor = RH_View_DefaultBackgroundColor;
        label_tice = [[UILabel alloc] init];
        [view_Back addSubview:label_tice];
        label_tice.whc_LeftSpace(20).whc_CenterY(0).whc_Width(60).whc_Height(20);
        label_tice.text = @"密码强度:";
        label_tice.textColor = RH_Label_DefaultTextColor;
        label_tice.font = [UIFont systemFontOfSize:12];
        label_One = [UILabel new];
        [view_Back addSubview:label_One];
        [self.contentView layoutIfNeeded];
        label_One.whc_CenterY(0).whc_LeftSpaceToView(10, label_tice).whc_Width(40).whc_Height(10);
        label_One.backgroundColor = RH_Image_DefaultBackgroundColor;
        label_One.layer.cornerRadius = 5;
        label_One.clipsToBounds = YES;
        label_Two = [UILabel new];
        [view_Back addSubview:label_Two];
        label_Two.whc_CenterY(0).whc_LeftSpaceToView(10, label_One).whc_Width(40).whc_Height(10);
        label_Two.backgroundColor = RH_Image_DefaultBackgroundColor;
        label_Two.layer.cornerRadius = 5;
        label_Two.clipsToBounds = YES;
        label_Three = [UILabel new];
        [view_Back addSubview:label_Three];
        label_Three.whc_CenterY(0).whc_LeftSpaceToView(10, label_Two).whc_Width(40).whc_Height(10);
        label_Three.backgroundColor = RH_Image_DefaultBackgroundColor;
        label_Three.layer.cornerRadius = 5;
        label_Three.clipsToBounds = YES;
        
        
//        if ([THEMEV3 isEqualToString:@"green"]){
//            _shareRedLab.textColor = RH_NavigationBar_BackgroundColor_Green;
//            huhuiLab.textColor = RH_NavigationBar_BackgroundColor_Green;
//        }else if ([THEMEV3 isEqualToString:@"red"]){
//            _shareRedLab.textColor = RH_NavigationBar_BackgroundColor_Red;
//            huhuiLab.textColor = RH_NavigationBar_BackgroundColor_Red;
//        }else if ([THEMEV3 isEqualToString:@"black"]){
//            _shareRedLab.textColor = RH_NavigationBar_BackgroundColor_Black;
//            huhuiLab.textColor =RH_NavigationBar_BackgroundColor_Black;
//        }else{
//            _shareRedLab.textColor =  RH_NavigationBar_BackgroundColor;
//            huhuiLab.textColor = RH_NavigationBar_BackgroundColor;
//        }
        
    }
    return self;
}

- (void)updateCellWithInfo:(NSDictionary *)info context:(id)context {
    label_Title.text = info[@"title"];
    self.textField.placeholder = info[@"detailTitle"];
}



- (void)textFieldValueChange:(UITextField *)textFiled {
    NSString *textRange = [self.textField.text copy];
    NSString *regexS = @"[a-zA-Z][0-9]|[0-9][a-zA-Z]";
    NSString *regexS2 = @"[!@#$%^&*_]";
    if (textRange.length > 4) {
        if ([THEMEV3 isEqualToString:@"green"]){
            label_One.backgroundColor = RH_NavigationBar_BackgroundColor_Green ;
        }else if ([THEMEV3 isEqualToString:@"red"]){
            label_One.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
        }else if ([THEMEV3 isEqualToString:@"black"]){
            label_One.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
        }else{
            label_One.backgroundColor = RH_NavigationBar_BackgroundColor;
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexS options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray<NSTextCheckingResult *> *result = [regex matchesInString:textRange options:0 range:NSMakeRange(0, textRange.length)];
        if (result.count > 0) {
            if ([THEMEV3 isEqualToString:@"green"]){
                label_Two.backgroundColor = RH_NavigationBar_BackgroundColor_Green ;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                label_Two.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                label_Two.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
            }else{
                label_Two.backgroundColor = RH_NavigationBar_BackgroundColor;
            }
            NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:regexS2 options:NSRegularExpressionCaseInsensitive error:nil];
            NSArray<NSTextCheckingResult *> *result2 = [regex2 matchesInString:textRange options:0 range:NSMakeRange(0, textRange.length)];
            if (result2.count > 0) {
                if ([THEMEV3 isEqualToString:@"green"]){
                    label_Three.backgroundColor = RH_NavigationBar_BackgroundColor_Green ;
                }else if ([THEMEV3 isEqualToString:@"red"]){
                    label_Three.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
                }else if ([THEMEV3 isEqualToString:@"black"]){
                    label_Three.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
                }else{
                    label_Three.backgroundColor = RH_NavigationBar_BackgroundColor;
                }
                return ;
            }
            label_Three.backgroundColor = RH_Image_DefaultBackgroundColor;
            return ;
        }
        label_Two.backgroundColor = RH_Image_DefaultBackgroundColor;
        return ;
    }
    label_One.backgroundColor = RH_Image_DefaultBackgroundColor;
    label_Two.backgroundColor = RH_Image_DefaultBackgroundColor;

    
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    return [self validateNumber:string];
//}
//
//- (BOOL)validateNumber:(NSString*)number {
//    BOOL res = YES;
//    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM!@#$_"];
//    int i = 0;
//    while (i < number.length) {
//        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
//        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
//        if (range.length == 0) {
//            res = NO;
//            break;
//        }
//        i++;
//    }
//    return res;
//}
@end
