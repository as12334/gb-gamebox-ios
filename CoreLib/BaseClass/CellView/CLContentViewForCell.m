//
//  CLContentViewForCell.m
//  TaskTracking
//
//  Created by apple pro on 2017/2/26.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLContentViewForCell.h"
#import "UIView+Instance.h"
#import "NSDictionary+CLCategory.h"
#import "UIColor+HexString.h"
#import "ScreenAdaptation.h"
#import "MacroDef.h"

@implementation CLContentViewForCell

+ (BOOL)_getCellSize:(CGSize *)pSize andInfo:(NSDictionary *)info containerViewSize:(CGSize)containerViewSize
{
    BOOL bRet = YES;

    id cellSizeValue = [info sizeValue];
    CGSize cellSize = CGSizeFromString(cellSizeValue);

    if (!cellSizeValue) {

        id heightValue = [info heightValue];
        id widthValue = [info widthValue];

        if (heightValue || widthValue) {
            cellSize = CGSizeMake(widthValue ? [widthValue floatValue] : containerViewSize.width, heightValue ? [heightValue floatValue] : containerViewSize.height);
        }else{
            bRet = NO;
        }
    }

    if (pSize) {
        *pSize = cellSize;
    }

    return bRet;
}

+ (CGSize)sizeForContentViewWithInfo:(NSDictionary *)info
                   containerViewSize:(CGSize)containerViewSize
                             context:(CLCellContext *)context
{
    CGSize cellSize = CGSizeZero;

    NSString * cellSizeValue = [info sizeValue];
    if (!cellSizeValue) {

        id heightValue = [info heightValue];
        id widthValue = [info widthValue];

        if (heightValue || widthValue) {
            cellSize = CGSizeMake(widthValue ? [widthValue floatValue] : containerViewSize.width, heightValue ? [heightValue floatValue] : containerViewSize.height);
        }
    }else {
        cellSize = CGSizeFromString(cellSizeValue);
    }

    cellSize.width  = MAX(0.f, cellSize.width);
    cellSize.height = MAX(0.f, cellSize.height);

    return cellSize;
}

- (void)updateViewWithInfo:(NSDictionary *)info {
    _info = info;
}

- (void)prepareForUseWithContext:(CLCellContext *)context containerCell:(id)containerCell
{
    [self endForUse];

    id<CLContentViewForCellDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(contentView:willUseWithContext:)){
        [delegate contentView:self willUseWithContext:context];
    }

    _used = YES;
    _context = context;
    _containerCell = containerCell;
}

- (void)endForUse
{
    if (self.isUsed) {

        id<CLContentViewForCellDelegate> delegate = self.delegate;
        ifRespondsSelector(delegate, @selector(contentViewWillEndUse:)){
            [delegate contentViewWillEndUse:self];
        }

        _used = NO;
        _context  = nil;
        _info = nil;
        _containerCell = nil;
    }
}

@end

//----------------------------------------------------------

@implementation CLContentViewForCellDefaultAllocator

- (CLContentViewForCell *)getContentViewForCellWithInfo:(NSDictionary *)info
                                                context:(CLCellContext *)context
{
    return [info contentViewForCellWithContext:context];
}

@end


//----------------------------------------------------------

@implementation NSDictionary (CLContentViewForCell)

- (NSString *)contentViewClassName
{
    NSString * className = [self valueForKey:@"contentViewClass" withClass:[NSString class]];
    if ([NSClassFromString(className) isSubclassOfClass:[CLContentViewForCell class]]) {
        return className;
    }

    return nil;
}

- (Class)contentViewClass {
    return NSClassFromString([self contentViewClassName]);
}

- (id)contentViewForCellWithContext:(CLCellContext *)context {
    return [[self contentViewClass] createInstanceWithContext:context];
}



@end
