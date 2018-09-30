//
//  RH_CollectionHeaderView.m
//  gameBoxEx
//
//  Created by paul on 2018/9/30.
//  Copyright © 2018 luis. All rights reserved.
//

#import "RH_CollectionHeaderView.h"
@interface RH_CollectionHeaderView()

@end
@implementation RH_CollectionHeaderView
+(instancetype)instanceCreateCollectionHeaderView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self  class]) owner:nil options:nil].lastObject;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)buttonClick:(UIButton *)sender {
    if (sender.tag==100) {
        [self.collection_button setBackgroundColor:[UIColor orangeColor]];
        [self.recentCollection_button setBackgroundColor:[UIColor  darkGrayColor]];
    }else{
        [self.recentCollection_button setBackgroundColor:[UIColor orangeColor]];
        [self.collection_button setBackgroundColor:[UIColor  darkGrayColor]];
    }
    if (self.delegate &&[self.delegate  respondsToSelector:@selector(collectionButtonClick:)]) {
        [self.delegate collectionButtonClick:sender];
    }
}

@end
