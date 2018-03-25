//
//  RH_BankPickerSelectView.h
//  gameBoxEx
//
//  Created by Lenny on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BankPickerSelectViewHeight              200

@class RH_BankPickerSelectView ;
@protocol BankPickerSelectViewDelegate
@optional
-(void)bankPickerSelectViewDidTouchConfirmButton:(RH_BankPickerSelectView*)bankPickerSelectView WithSelectedBank:(id)bankModel;
-(void)bankPickerSelectViewDidTouchCancelButton:(RH_BankPickerSelectView*)bankPickerSelectView ;

@end

@interface RH_BankPickerSelectView : UIView
@property (nonatomic,weak) id<BankPickerSelectViewDelegate> delegate ;
///设置新的数据源
- (void)setDatasourceList:(NSArray *)list;
@end
