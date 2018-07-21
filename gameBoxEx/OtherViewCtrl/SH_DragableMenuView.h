//
//  SH_DragableMenuView.h
//  GameBox
//
//  Created by shin on 2018/7/15.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SHDragableMenuViewClose)(void);
typedef void(^SHDragableMenuViewGoBack)(void);

@interface SH_DragableMenuView : UIView

@property (nonatomic, assign) BOOL autoAttract;//是否自动吸引

- (void)closeAction:(SHDragableMenuViewClose)closeBlock;
- (void)gobackAction:(SHDragableMenuViewClose)gobackBlock;

@end
