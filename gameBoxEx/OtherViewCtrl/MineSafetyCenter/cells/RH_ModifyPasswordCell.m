//
//  RH_ModifyPasswordCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/7.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ModifyPasswordCell.h"
#import "coreLib.h"
@interface RH_ModifyPasswordCell()

@end

@implementation RH_ModifyPasswordCell
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
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.textColor = colorWithRGB(153, 153, 153);
        _textField.secureTextEntry = YES;
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
@end
