//
//  CLSelectionView.h
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "CLBorderView.h"
#import "CLSelectionProtocol.h"

@interface CLSelectionView : CLBorderView<CLSelectionProtocol>

@property(nonatomic,strong) UIView * backgroundView;

@end
