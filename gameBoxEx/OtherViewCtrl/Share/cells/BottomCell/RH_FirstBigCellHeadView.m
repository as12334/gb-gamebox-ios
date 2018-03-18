//
//  RH_FirstBigCellHeadView.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_FirstBigCellHeadView.h"
#import "coreLib.h"
@interface RH_FirstBigCellHeadView ()
@property (nonatomic,strong) NSArray *arrayTypeList ;
@end
@implementation RH_FirstBigCellHeadView
@synthesize selectedIndex = _selectedIndex ;


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSArray *itemArray = @[@"奖励规则",@"分享记录"];
        //初始化UISegmentedControl
        self.segmentedControl = [[UISegmentedControl alloc]initWithItems:itemArray];
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
        //添加到视图
        [self addSubview:self.segmentedControl];
        //设置frame
        self.segmentedControl.whc_CenterX(0).whc_TopSpace(15).whc_Width(154) ;
        [self.segmentedControl addTarget:self action:@selector(segmentSelectedClick:) forControlEvents:UIControlEventValueChanged];
        
        UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [self.segmentedControl setTitleTextAttributes:attributes
                                             forState:UIControlStateNormal];
        UIColor *noSelectTitleColor = colorWithRGB(93, 95, 103);
        NSDictionary *colorAttr = [NSDictionary dictionaryWithObject:noSelectTitleColor forKey:NSForegroundColorAttributeName];
        [self.segmentedControl setTitleTextAttributes:colorAttr forState:UIControlStateNormal];
  
    }
    return self ;
}

-(void)updateView:(NSArray*)typeList
{
    self.arrayTypeList = ConvertToClassPointer(NSArray, typeList) ;
    self.segmentedControl.selectedSegmentIndex = _selectedIndex;
}

-(RH_SharePlayerRecommendModel *)typeModelWithIndex:(NSInteger)index 
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
    }
}
- (void)segmentSelectedClick:(id)sender {
    [self setSelectedIndex:self.segmentedControl.selectedSegmentIndex] ;
    ifRespondsSelector(self.delegate, @selector(firstBigCellHeadViewDidChangedSelectedIndex:SelectedIndex:)){
        [self.delegate firstBigCellHeadViewDidChangedSelectedIndex:self SelectedIndex:self.segmentedControl.selectedSegmentIndex] ;
    }
}


@end
