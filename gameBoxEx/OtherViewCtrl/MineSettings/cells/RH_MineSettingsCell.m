//
//  RH_MineSettingsCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MineSettingsCell.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"

@interface RH_MineSettingsCell()
@property (nonatomic, strong) UISwitch *rightSwitch;
@property (nonatomic,strong) NSDictionary *cellDict ;
@end

@implementation RH_MineSettingsCell

+ (CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context {
    return 45;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = colorWithRGB(51, 51, 51);
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine;
        self.separatorLineColor = colorWithRGB(242, 242, 242);
        self.separatorLineWidth = 1.0f;
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
        
        [self.contentView addSubview:self.rightSwitch];
        self.rightSwitch.whc_RightSpace(20).whc_CenterY(0).whc_Width(51).whc_Height(31);
        
        self.selectionOption = CLSelectionOptionHighlighted ;
        self.selectionColor = RH_Cell_DefaultHolderColor ;
        
    }
    return self;
}

- (void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.cellDict = info ;
    self.textLabel.text = info[@"title"];
    self.rightSwitch.on = [context boolValue] ;
}

#pragma mark -
- (UISwitch *)rightSwitch {
    if (_rightSwitch == nil) {
        _rightSwitch = [[UISwitch alloc] init];
        [_rightSwitch addTarget:self action:@selector(rightSwitchHandle)
               forControlEvents:UIControlEventValueChanged] ;
        
    }
    return _rightSwitch;
}

-(void)rightSwitchHandle
{
    switch ([self.cellDict integerValueForKey:@"id"]) {
        case 0: ////声音
            [[RH_UserInfoManager shareUserManager] updateVoickSwitchFlag:self.rightSwitch.isOn] ;
            break;
            
        case 1: ////锁屏
            [[RH_UserInfoManager shareUserManager] updateScreenLockFlag:self.rightSwitch.isOn] ;
            break;
            
        default:
            break;
    }
}

@end
