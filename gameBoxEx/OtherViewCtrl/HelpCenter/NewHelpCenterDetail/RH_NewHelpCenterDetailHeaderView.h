//
//  RH_NewHelpCenterDetailHeaderView.h
//  gameBoxEx
//
//  Created by richard on 2018/10/1.
//  Copyright © 2018 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RH_HelpCenterDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HeaderViewClickedBack)(BOOL);

@interface RH_NewHelpCenterDetailHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) HeaderViewClickedBack HeaderClickedBack;


@property (nonatomic, strong) RH_HelpCenterDetailModel *sectionModel;

@end

NS_ASSUME_NONNULL_END
