//
//  RH_DepositeTransferQRCodeCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
@class RH_DepositeTransferQRCodeCell;
@protocol DepositeTransferQRCodeCellDelegate<NSObject>
@optional
-(void)depositeTransferQRCodeCellDidTouchSaveToPhoneWithImageUrl:(NSString *)imageUrl;
@end
@interface RH_DepositeTransferQRCodeCell : CLTableViewCell
@property(weak,nonatomic)id <DepositeTransferQRCodeCellDelegate> delegate;
@end
