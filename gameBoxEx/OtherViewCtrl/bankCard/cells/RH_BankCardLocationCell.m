//
//  RH_BankCardLocationCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/2/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BankCardLocationCell.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"

@interface RH_BankCardLocationCell() <UITextFieldDelegate>

@end
@implementation RH_BankCardLocationCell
@synthesize textField = _textField;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context {
    return 40;
}

-(BOOL)isEditing
{
    return self.textField.isEditing ;
}

-(BOOL)endEditing:(BOOL)force
{
    if (self.textField.isEditing){
        [self.textField resignFirstResponder] ;
    }
    
    return YES ;
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.textColor = colorWithRGB(153, 153, 153);
        _textField.secureTextEntry = NO;
        _textField.delegate = self;
    }
    return _textField;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel.textColor = colorWithRGB(153, 153, 153);
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.textColor = colorWithRGB(51, 51, 51);
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine;
        self.separatorLineWidth = 1.0f;
        self.separatorLineColor = colorWithRGB(226, 226, 226);
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0) ;
        self.backgroundColor = colorWithRGB(255, 255, 255);
        [self.contentView addSubview:self.textField];
        self.textField.whc_CenterY(0).whc_RightSpace(20).whc_Height(39).whc_Width(screenSize().width/5*3);
        self.textField.font = [UIFont systemFontOfSize:12];
        self.selectionOption = CLSelectionOptionHighlighted;
        self.selectionColor = RH_Cell_DefaultHolderColor;
    }
    return self;
}

- (void)updateCellWithInfo:(NSDictionary *)info context:(id)context {
    self.textLabel.text = info[@"title"];
    self.textField.placeholder = info[@"detailTitle"];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //    return [self validateNumber:string];
    return YES;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM!@#$_"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
@end
