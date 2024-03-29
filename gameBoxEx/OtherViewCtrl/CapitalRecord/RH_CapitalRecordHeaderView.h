//
//  RH_CapitalRecordHeaderView.h
//  gameBoxEx
//
//  Created by Richard on 04/01/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^typeLabelPullDownSelectedBlock)(CGRect frame);
typedef void(^quickBtnOpenBlock)(CGRect frame);
@class RH_CapitalRecordHeaderView ;
@protocol CapitalRecordHeaderViewDelegate
@optional
-(void)capitalRecordHeaderViewWillSelectedStartDate:(RH_CapitalRecordHeaderView*)CapitalRecordHeaderView DefaultDate:(NSDate*)defaultDate ;
-(void)capitalRecordHeaderViewWillSelectedEndDate:(RH_CapitalRecordHeaderView*)CapitalRecordHeaderView DefaultDate:(NSDate*)defaultDate ;
-(void)capitalRecordHeaderViewTouchSearchButton:(RH_CapitalRecordHeaderView*)capitalRecordHeaderView ;

@end

@interface RH_CapitalRecordHeaderView : UIView
@property (nonatomic,weak) id<CapitalRecordHeaderViewDelegate> delegate ;
@property (nonatomic,strong) NSDate *startDate ;
@property (nonatomic,strong) NSDate *endDate ;
@property (nonatomic,copy)typeLabelPullDownSelectedBlock block;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
/**快选*/
@property (weak, nonatomic) IBOutlet UIButton *btnQuickSelect;
@property(nonatomic,copy)quickBtnOpenBlock quickSelectBlock;


-(void)updateUIInfoWithDraw:(CGFloat)drawSum TransferSum:(CGFloat)transferSum ;
@end
