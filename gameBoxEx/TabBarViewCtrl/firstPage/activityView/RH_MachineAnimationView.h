//
//  RH_MachineAnimationView.h
//  gameBoxEx
//
//  Created by Lewis on 2018/1/1.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_OpenActivityModel.h"

@interface RH_MachineAnimationView : UIView
@property(nonatomic,strong)RH_OpenActivityModel *openActivityModel;
-(void)showAnimation;
@end
