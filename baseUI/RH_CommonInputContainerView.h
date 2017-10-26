//
//  RH_CommonInputContainerView.h
//  TaskTracking
//
//  Created by jinguihua on 2017/2/27.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLBorderView.h"

//----------------------------------------------------------

typedef enum{
    RH_CommonInputContainerViewTypeLine = 0,    //线
    RH_CommonInputContainerViewTypeBoder = 1    //边界
} RH_CommonInputContainerViewType;

//----------------------------------------------------------


@interface RH_CommonInputContainerView : CLBorderView

@property(nonatomic) RH_CommonInputContainerViewType type;

@property(nonatomic,strong) IBOutlet UITextField * textField;

@property(nonatomic,copy) void(^textFieldDidChangeEditStatusBlock)(BOOL isFirstResponder);

@end
