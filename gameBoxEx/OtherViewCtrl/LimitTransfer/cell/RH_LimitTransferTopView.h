//
//  RH_LimitTransferTopView.h
//  gameBoxEx
//
//  Created by Richard on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_GetNoAutoTransferInfoModel.h"
@class RH_LimitTransferTopView ;
@protocol LimitTransferTopViewDelegate

-(void)limitTransferTopViewDidTouchTransferInBtn:(UIButton *)sender withView:(RH_LimitTransferTopView *)topView;
-(void)limitTransferTopViewDidTouchTransferOutBtn:(UIButton *)sender withView:(RH_LimitTransferTopView *)topView;
-(void)limitTransferTopViewDidTouchRefreshBalanceBtn ;
-(void)limitTransferTopViewDidTouchSureSubmitBtn:(UIButton *)sender withTransferInBtn:(UIButton *)transfrtIn transferOut:(UIButton *)transferOut amount:(NSString *)amount ;
@end

@interface RH_LimitTransferTopView : UIView
@property (nonatomic, weak) id<LimitTransferTopViewDelegate> delegate;
-(void)updataBTnTitleTransferInBtnTitle:(NSString *)tranferInTitle ;
-(void)updataBTnTitletransferOutBtnTitle:(NSString *)tranferOutTitle ;
-(void)topViewUpdataTopDateWithModel:(RH_GetNoAutoTransferInfoModel *)model ;
@end
