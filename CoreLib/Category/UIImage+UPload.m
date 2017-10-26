//
//  UIImage+UPload.m
//  TaskTracking
//
//  Created by apple pro on 2017/2/26.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "UIImage+UPload.h"
#import "UIImage+Representation.h"

@implementation UIImage (UPload)

- (NSData *)imageDataForUpload {
    return [self representationWithMaxSize:2 * 1024 * 1024];
}

@end
