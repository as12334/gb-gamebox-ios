//
//  RH_FirstBigCellHeadView.h
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RH_FirstBigCellHeadView ;
@protocol firstBigCellHeadViewDelegate<NSObject>
@optional
-(void)firstBigCellHeadViewDidChangedSelectedIndex:(RH_FirstBigCellHeadView*)firstBigCellHeadView SelectedIndex:(NSInteger)selectedIndex ;
@end
@interface RH_FirstBigCellHeadView : UIView
@property (nonatomic,weak) id<firstBigCellHeadViewDelegate> delegate ;

@property (nonatomic,assign,readonly) NSInteger allTypes ;
@property (nonatomic,assign) NSInteger selectedIndex ;
@property (nonatomic,assign,readonly) CGFloat viewHeight ;
@property (strong, nonatomic)UISegmentedControl *segmentedControl;
-(void)updateView:(NSArray*)typeList ;
//-(RH_DiscountActivityTypeModel*)typeModelWithIndex:(NSInteger)index ;
@end
