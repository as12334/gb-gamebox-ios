//
//  RH_MineHeaderView.h
//  gameBoxEx
//
//  Created by paul on 2018/9/30.
//  Copyright © 2018 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RH_MineHeaderViewDelegate <NSObject>
-(void)mineHeaderViewButtonClickWithTag:(NSInteger)tag;
@end
@interface RH_MineHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *logonTime_label;
@property (weak, nonatomic) IBOutlet UILabel *totalAmount_label;
@property (weak, nonatomic) IBOutlet UILabel *balance_label;
@property (weak, nonatomic) IBOutlet UILabel *userName_label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraintHeight;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (nonatomic,assign)id<RH_MineHeaderViewDelegate>delegate;

+(instancetype)createInstanceMineHeaderView;
-(void)updateCell;
@end

NS_ASSUME_NONNULL_END
