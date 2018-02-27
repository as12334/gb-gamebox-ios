//
//  RH_NavigationUserInfoView.h
//  gameBoxEx
//
//  Created by luis on 2017/12/24.
//  Copyright © 2017年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coreLib.h"

@interface RH_NavigationUserInfoView :UIControl
@property (nonatomic,strong,readonly)  UIButton *buttonCover ;
@property (nonatomic,strong) IBOutlet UILabel *labBalance  ;
-(void)updateUI ;
@end
