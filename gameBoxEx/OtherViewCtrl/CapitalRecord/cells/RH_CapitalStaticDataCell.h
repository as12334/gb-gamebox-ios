//
//  RH_CapitalStaticDataCell.h
//  gameBoxEx
//
//  Created by Richard on 04/01/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLStaticCollectionViewCell.h"

@interface RH_CapitalStaticDataCell : UIView
-(void)addTarget:(id)object Selector:(SEL)selector  ;
-(void)updateUIWithDate:(NSDate*)date ;
@end
