//
//  RH_ApplyDiscountHeaderView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ApplyDiscountHeaderView.h"

#import "coreLib.h"

@interface RH_ApplyDiscountHeaderView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray *arrayTypeList ;

@end

@implementation RH_ApplyDiscountHeaderView
@synthesize selectedIndex = _selectedIndex ;
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
        NSArray *itemArray = @[@"游戏公告",@"系统公告",@"站点信息"];
        //初始化UISegmentedControl
        self.segmentedControl = [[UISegmentedControl alloc]initWithItems:itemArray];
        //设置frame
        [self.segmentedControl setFrame:CGRectMake((MainScreenW-200)/2,15/2, 200, 35)];
        [self.segmentedControl addTarget:self action:@selector(segmentSelectedClick:) forControlEvents:UIControlEventValueChanged];
        self.segmentedControl.tintColor = colorWithRGB(23, 102, 187);
        //添加到视图
        [self addSubview:self.segmentedControl];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.backgroundColor = [UIColor whiteColor] ;
    _selectedIndex = 0 ;
    _viewHeight = 0.0f ;
}

-(void)updateView:(NSArray*)typeList
{
//    self.arrayTypeList = ConvertToClassPointer(NSArray, typeList) ;
    self.arrayTypeList = @[[UIColor redColor],[UIColor yellowColor],[UIColor blueColor]];
    self.segmentedControl.selectedSegmentIndex = _selectedIndex;
}
-(RH_DiscountActivityTypeModel*)typeModelWithIndex:(NSInteger)index
{
    if (index>=0 && index <self.arrayTypeList.count){
        return self.arrayTypeList[index] ;
    }
    
    return nil ;
}
#pragma mark-
-(NSInteger)allTypes
{
    return self.arrayTypeList.count ;
}

-(NSInteger)selectedIndex
{
    return _selectedIndex ;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex!=selectedIndex){
        _selectedIndex = selectedIndex ;
//        self.segmentedControl.selectedSegmentIndex = _selectedIndex;
    }
}
- (void)segmentSelectedClick:(id)sender {
    [self setSelectedIndex:self.segmentedControl.selectedSegmentIndex] ;
    ifRespondsSelector(self.delegate, @selector(DiscountTypeHeaderViewDidChangedSelectedIndex:SelectedIndex:)){
        [self.delegate DiscountTypeHeaderViewDidChangedSelectedIndex:self SelectedIndex:self.segmentedControl.selectedSegmentIndex] ;
    }
}
@end
