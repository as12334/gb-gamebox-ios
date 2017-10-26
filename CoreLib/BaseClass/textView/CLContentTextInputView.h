//
//  CLContentTextInputView.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/23.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class CLContentTextInputView;
@protocol CLContentTextInputViewDelegate <NSObject>
@optional
-(void)contentTextInputView:(CLContentTextInputView *)doContentTextInputView withTextLength:(NSUInteger)textLength;
-(void)contentTextInputViewDidEndEditing:(CLContentTextInputView *)doContentTextInputView ;
@end

@interface CLContentTextInputView : UIView
@property(nonatomic,strong) NSString * text;
@property(nonatomic,strong) NSString *placeHolderText ;

@property(nonatomic,strong,readonly) NSAttributedString * attributedText;
@property(nonatomic,weak) id<CLContentTextInputViewDelegate> delegate;
@property(nonatomic,getter=isEditting) BOOL editting;

@end
