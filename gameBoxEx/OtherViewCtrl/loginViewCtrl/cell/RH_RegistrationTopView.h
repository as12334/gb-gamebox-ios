//
//  RH_RegistrationTopView.h
//  gameBoxEx
//
//  Created by richard on 2018/9/28.
//  Copyright © 2018 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RegistrationTopViewDelegate <NSObject>

-(void)registrationTopViewbcloseBtnDidClick;

@end


@interface RH_RegistrationTopView : UIView

@property(nonatomic,weak) id<RegistrationTopViewDelegate> delegate ;

-(void)updateContentWithContext:(NSString *)context ;

@end

NS_ASSUME_NONNULL_END
