//
//  RH_WithdrawCashTwoCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_WithdrawCashTwoCell.h"
#import "coreLib.h"

@interface RH_WithdrawCashTwoCell() <UITextFieldDelegate>
@end
@implementation RH_WithdrawCashTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textField.secureTextEntry = NO;
        self.textField.delegate = self;
        self.textField.returnKeyType = UIReturnKeyDone;
        self.detailTextLabel.textColor = colorWithRGB(153, 153, 153);
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = colorWithRGB(51, 51, 51);
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine;
        self.separatorLineWidth = 1.0f;
        self.separatorLineColor = colorWithRGB(226, 226, 226);
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0) ;
        self.backgroundColor = colorWithRGB(255, 255, 255);
        [self.contentView addSubview:self.textField];
        self.textField.whc_CenterY(0).whc_RightSpace(20).whc_Height(39).whc_Width(screenSize().width/5*3);
        self.textField.font = [UIFont systemFontOfSize:14];
        self.selectionOption = CLSelectionOptionHighlighted;
        self.selectionColor = RH_Cell_DefaultHolderColor;
        
        UIView *line = [UIView new];
        [self.contentView addSubview:line];
        line.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_Height(1);
        line.backgroundColor = colorWithRGB(226, 226, 226);
        
        [self.textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"请输入整数金额"
                                                                                 attributes:@{NSFontAttributeName : self.textField.font, NSForegroundColorAttributeName : ColorWithNumberRGB(0xcacaca)}]] ;
    }
    return self;
}

- (void)updateCellWithInfo:(NSDictionary *)info context:(id)context {
    self.textLabel.text = info[@"title"];
    self.textField.text = ([context floatValue]>0?[NSString stringWithFormat:@"%8.0f",[context floatValue]]:@"") ;
}

#pragma mark-
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    ifRespondsSelector(self.delegate, @selector(withdrawCashTwoCellDidTouchDONE:)){
        [self.delegate withdrawCashTwoCellDidTouchDONE:self] ;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
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
