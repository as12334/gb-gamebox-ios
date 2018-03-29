//
//  RH_PhoneDialogModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/3/29.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import "RH_PhoneDialogModel.h"

@interface RH_PhoneDialogModel : RH_BasicModel
@property (nonatomic , assign , readonly) NSInteger              mId;
@property (nonatomic , assign , readonly) NSInteger              update_time;
@property (nonatomic , strong , readonly) NSString              * content;
@property (nonatomic , strong , readonly) NSString              * link;
@property (nonatomic , strong , readonly) NSString              * content_type;
@property (nonatomic , assign , readonly) NSInteger              start_time;
@property (nonatomic , strong, readonly) NSString              * type;
@property (nonatomic , assign, readonly) NSInteger              carousel_id;
@property (nonatomic , strong , readonly) NSString              * language;
@property (nonatomic , assign , readonly) NSInteger              end_time;
@property (nonatomic , strong ,readonly) NSString              * cover;
@property (nonatomic , strong , readonly) NSString              * name;
@property (nonatomic , assign , readonly) BOOL              status;
@end
