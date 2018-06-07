//
//  RH_GameItemsCell.m
//  gameBoxEx
//
//  Created by shin on 2018/6/6.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GameItemsCell.h"
#import "RH_GameItemView.h"
#import "WHC_AutoLayout.h"
#import "RH_LotteryAPIInfoModel.h"
#import "MacroDef.h"

@interface RH_GameItemsCell () <RH_GameItemViewDelegate>
@end

@implementation RH_GameItemsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemsArr:(NSArray *)itemsArr
{
    _itemsArr = itemsArr;
    for (id subView in self.subviews) {
        if ([subView isMemberOfClass:[RH_GameItemView class]]) {
            [subView removeFromSuperview];
        }
    }

    int numOfRow = 3;//每行显示3个
    CGFloat temp = 10.0;
    CGFloat w = ([UIScreen mainScreen].bounds.size.width-temp*numOfRow*2)/numOfRow;
    CGFloat h = 1.2*w;
    
    for (int i = 0; i < _itemsArr.count; i++) {
        RH_GameItemView *item = [[[NSBundle mainBundle] loadNibNamed:@"RH_GameItemView" owner:nil options:nil] lastObject];
        item.model = _itemsArr[i];
        item.typeModel = self.typeModel;
        item.delegate = self;
        [self addSubview:item];
        item.whc_TopSpaceToView(temp, self).whc_LeftSpace(i*w+(i*2+1)*temp).whc_Width(w).whc_Height(h);
    }
}

#pragma mark - RH_GameItemViewDelegate M

- (void)gameItemView:(RH_GameItemView *)view didSelect:(RH_LotteryInfoModel *)model
{
    ifRespondsSelector(self.delegate, @selector(gameItemsCell:didSelect:)){
        [self.delegate gameItemsCell:self didSelect:model];
    }
}

@end
