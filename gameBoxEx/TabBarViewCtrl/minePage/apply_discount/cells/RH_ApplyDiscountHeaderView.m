//
//  RH_ApplyDiscountHeaderView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ApplyDiscountHeaderView.h"

#import "coreLib.h"

@interface RH_ApplyDiscountHeaderView()<UICollectionViewDelegate>
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
//        self.segmentedControl.layer.cornerRadius = 6.f;
//        self.segmentedControl.clipsToBounds = YES;
        
        self.segmentedControl.layer.borderWidth=1;
        if ([THEMEV3 isEqualToString:@"green"]){
            self.segmentedControl.layer.borderColor= RH_NavigationBar_BackgroundColor_Green.CGColor;
            self.segmentedControl.tintColor = RH_NavigationBar_BackgroundColor_Green;
        }else if ([THEMEV3 isEqualToString:@"red"]){
            self.segmentedControl.layer.borderColor= RH_NavigationBar_BackgroundColor_Red.CGColor;
            self.segmentedControl.tintColor = RH_NavigationBar_BackgroundColor_Red;
        }else if ([THEMEV3 isEqualToString:@"black"]){
            self.segmentedControl.layer.borderColor= RH_NavigationBar_BackgroundColor_Black.CGColor;
            self.segmentedControl.tintColor = RH_NavigationBar_BackgroundColor_Black;
        }else{
            self.segmentedControl.layer.borderColor= RH_NavigationBar_BackgroundColor.CGColor;
            self.segmentedControl.tintColor = RH_NavigationBar_BackgroundColor;
        }
        
        self.segmentedControl.layer.masksToBounds=YES;
        self.segmentedControl.layer.cornerRadius=6;
        //设置frame
        [self.segmentedControl setFrame:CGRectMake((MainScreenW-288)/2.0,15, 288, 33)];
        [self.segmentedControl addTarget:self action:@selector(segmentSelectedClick:) forControlEvents:UIControlEventValueChanged];
    
      
        UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [self.segmentedControl setTitleTextAttributes:attributes
                                   forState:UIControlStateNormal];
        UIColor *noSelectTitleColor = colorWithRGB(93, 95, 103);
        NSDictionary *colorAttr = [NSDictionary dictionaryWithObject:noSelectTitleColor forKey:NSForegroundColorAttributeName];
        [self.segmentedControl setTitleTextAttributes:colorAttr forState:UIControlStateNormal];
        //添加到视图
        [self addSubview:self.segmentedControl];
//        badgeLab.backgroundColor = [UIColor redColor] ;
//        badgeLab.layer.cornerRadius = 10;
//        badgeLab.layer.masksToBounds = YES;
//        badgeLab.text = @"99+";
//        badgeLab.textColor = [UIColor whiteColor] ;
//        badgeLab.font = [UIFont systemFontOfSize:8.f];
//        badgeLab.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:badgeLab];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.backgroundColor = [UIColor whiteColor] ;
//    _selectedIndex = 0 ;
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
