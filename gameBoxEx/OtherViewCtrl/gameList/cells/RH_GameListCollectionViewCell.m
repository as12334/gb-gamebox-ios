//
//  RH_GameListCollectionViewCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/5.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GameListCollectionViewCell.h"
#import "coreLib.h"

@implementation RH_GameListCollectionViewCell

+(CGSize)sizeForViewWithInfo:(NSDictionary *)info containerViewSize:(CGSize)containerViewSize context:(id)context
{
    return CGSizeMake((containerViewSize.width-50)/4, (containerViewSize.width-50)/4*7/5);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
