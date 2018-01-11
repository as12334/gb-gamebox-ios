//
//  RH_MPGameSeletedDateView.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/11.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coreLib.h"
@interface RH_MPGameSeletedDateView : CLSelectionControl
-(void)addTarget:(id)object Selector:(SEL)selector  ;
-(void)updateUIWithDate:(NSDate*)date ;
@end
