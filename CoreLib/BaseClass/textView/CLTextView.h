//
//  CLTextView.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/23.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLTextView : UITextView
@property(nonatomic,strong) NSString * placeholderText;
// font & color
@property(nonatomic,strong) NSDictionary * placeholderAttributed;


- (CGSize)sizeForFullShowWithWidth:(CGFloat)width;
@end
