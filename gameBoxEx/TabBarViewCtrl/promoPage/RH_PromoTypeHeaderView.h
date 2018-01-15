//
//  RH_PromoTypeHeaderView.h
//  lotteryBox
//
//  Created by luis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RH_PromoTypeHeaderView : UIView
@property (nonatomic,assign,readonly) NSInteger allTypes ;
@property (nonatomic,assign,readonly) CGSize containSize ;
@property (nonatomic,assign) NSInteger selectedType ;
-(void)updateView:(NSArray*)typeList ;
@end
