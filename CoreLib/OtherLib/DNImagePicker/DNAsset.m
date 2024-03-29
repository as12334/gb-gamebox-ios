//
//  DNAsset.m
//  ImagePicker
//
//  Created by DingXiao on 15/3/6.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import "DNAsset.h"
#import "NSURL+DNIMagePickerUrlEqual.h"
@implementation DNAsset

- (id)initWithAsset:(ALAsset *)asset
{
    self = [super init];

    if (self) {
        _asset = asset;
    }

    return self;
}

- (NSURL *)url {
    return [self.asset valueForProperty:ALAssetPropertyAssetURL];
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        return [self isEqualToAsset:other];
    }
}

- (BOOL)isEqualToAsset:(DNAsset *)asset
{
    if ([asset isKindOfClass:[DNAsset class]]) {
        return [self.url isEqualToOther:asset.url];
    } else {
        return NO;
    }
}

@end
