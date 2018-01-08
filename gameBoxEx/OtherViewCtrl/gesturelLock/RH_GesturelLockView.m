//
//  CLGesturelLickView.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/17.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_GesturelLockView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface RH_GesturelLockView()
{
    /** 判断是当设置密码用，还是解锁密码用*/
    PwdState Amode;
    /**
     标记起始点在button里面，后续的滑动才有回调
     */
    BOOL _startAtButton;
}
/** 解锁时手指经过的所有的btn集合*/
@property (nonatomic,strong)NSMutableArray * btnsArray;
/**
    记录一开始创建的九个按钮的数组
 */
@property(nonatomic,strong)NSMutableArray *nineBtnArray;
/** 手指当前的触摸位置*/
@property (nonatomic,assign)CGPoint currentPoint;
/** */
@property (nonatomic, strong)UIBezierPath * path;
@property (nonatomic, strong)CAShapeLayer * slayer;
@end
@implementation RH_GesturelLockView

-(NSMutableArray *)btnsArray{
    if (_btnsArray == nil) {
        _btnsArray = [NSMutableArray array];
    }
    return _btnsArray;
}
-(NSMutableArray *)nineBtnArray
{
    if (_nineBtnArray==nil) {
        _nineBtnArray = [NSMutableArray array];
    }
    return _nineBtnArray;
}
-(instancetype)initWithFrame:(CGRect)frame WithMode:(PwdState) mode{
    self = [super initWithFrame: frame];
    if (self) {
        Amode = mode;
        _startAtButton = NO;
        self.backgroundColor = [UIColor clearColor];
        if (self.lineColor == nil) {
            self.lineColor = [UIColor greenColor];
        }
        //        1、创建九个btn
        for (int i = 0; i<9; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            btn.userInteractionEnabled = NO;
            [self addSubview:btn];
            [self.nineBtnArray addObject:btn];
        }
    }
    return self;
}
-(void)layoutSubviews{
    for (int index = 0; index<self.subviews.count; index ++) {
        //        拿到每个btn
        UIButton *btn = self.subviews[index];
        //        设置frame
        CGFloat btnW = 74;
        CGFloat btnH = 74;
        CGFloat margin = (SCREEN_WIDTH - (btnW *3))/4;
        //x = 间距 + 列号*（间距+btnW）
        CGFloat btnX = margin + (index % 3)*(margin + btnW);
        CGFloat btnY = margin + (index / 3)*(margin + btnH);
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UIButton *button in self.nineBtnArray) {
        if (CGRectContainsPoint(button.frame,[[touches anyObject] locationInView:self])) {
            _startAtButton = YES;
            //创建贝塞尔曲线
            UIBezierPath *path = [[UIBezierPath alloc]init];
            path.lineCapStyle = kCGLineCapRound; //线条拐角
            path.lineJoinStyle = kCGLineCapRound; //终点处理
            path.lineWidth = 10;
            _path = path;
            CAShapeLayer * slayer = [CAShapeLayer layer];
            slayer.path = path.CGPath;
            slayer.backgroundColor = [UIColor clearColor].CGColor;
            slayer.fillColor = [UIColor clearColor].CGColor;
            slayer.lineCap = kCALineCapRound;
            slayer.lineJoin = kCALineJoinRound;
            slayer.strokeColor = [UIColor whiteColor].CGColor;
            slayer.lineWidth = path.lineWidth;
            [self.layer addSublayer:slayer];
            _slayer = slayer;
            //获取当前手指的位置
            CGPoint point = button.center;
            //获取当前手指移动到了哪个btn
            UIButton *btn = [self getCurrentBtnWithPoint:point];
            [_path moveToPoint:point];
            if (btn && btn.selected != YES) {
                btn.selected = YES;
                [self.btnsArray addObject:btn];
            }
        }
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_startAtButton==YES) {
        CGPoint movePoint = [self getCurrentTouch:touches];
        UIButton *btn = [self getCurrentBtnWithPoint:movePoint];
        if (btn && btn.selected != YES) {
            btn.selected = YES;
            [self.btnsArray addObject:btn];
        }
        self.currentPoint = movePoint;
        for (UIButton *btn in self.btnsArray) {
            if (CGRectContainsPoint(btn.frame, self.currentPoint)) {
                [_path addLineToPoint:btn.center];
                _slayer.path = _path.CGPath;
            }
        }
    }
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_startAtButton==YES) {
    for (UIButton *btn in self.subviews) {
        [btn setSelected:NO];
    }
    NSMutableString *result = [NSMutableString string];
    for (UIButton *btn in self.btnsArray) {
        [result appendString: [NSString stringWithFormat:@"%ld",(long)btn.tag]];
    }
    if (self.btnsArray.count > 3) {//如果选中的点大于3个才判断是不是正确密码
        
        //        判断是设置密码还是解锁密码
        switch (Amode) {
            case PwdStateResult:
                if (self.sendReaultData){
                    if (self.sendReaultData(result) == YES) {
                        
                        [self clear];
                    }else{
                        [self ErrorShow];
                    }
                }
                break;
            case PwdStateSetting:
                //如果是设置密码的话，直接调用Block传值
                if (self.setPwdData) {
                    self.setPwdData(result);
                    [self clear];
                }
                break;
            default:
                NSLog(@"不执行操作，类型不对");
                break;
        }
        
        
    }
    [_slayer removeFromSuperlayer];
        _startAtButton = NO;
    }
}


-(void)ErrorShow{  // 密码不正确处理方式
    
    // 1. 重绘成红色效果
    // 1.1 把selectedButtons中的每个按钮的selected = NO, enabled = NO
    for (UIButton *btn in self.btnsArray) {
        btn.selected = NO;
        btn.enabled = NO;
    }
    // 1.2 设置线段颜色为红色
    self.lineColor = [UIColor redColor];
    // 禁用与用户的交互
    self.userInteractionEnabled = NO;
    // 2. 等待0.5秒中, 然后再清空
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIButton *btn in self.btnsArray) {
            btn.selected = NO;
            btn.enabled = YES;
        }
        [self clear];
    });
}

-(void)clear{//清空上下文
    [self.btnsArray removeAllObjects];
    self.currentPoint = CGPointZero;
    [self setNeedsDisplay];
    self.lineColor = [UIColor greenColor];
    self.userInteractionEnabled = YES;
}

//获取触摸的点
-(CGPoint)getCurrentTouch:(NSSet<UITouch *> *)touches{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    return point;
}

/**
 getCurrentBtnWithPoint
 
 @param currentPoint 触摸的点
 
 @return 触摸到的btn
 */
-(UIButton *)getCurrentBtnWithPoint:(CGPoint) currentPoint{
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, currentPoint)) {
            
            return btn;
        }
    }
    return nil;
}



-(void)setBtnSelectdImgae:(UIImage *)btnSelectdImgae{
    for (UIButton *btn in self.subviews) {
        [btn setBackgroundImage:btnSelectdImgae forState:UIControlStateSelected];
    }
}
-(void)setBtnImage:(UIImage *)btnImage{
    for (UIButton *btn in self.subviews) {
        [btn setImage:btnImage forState:UIControlStateNormal];
    }
}
-(void)setBtnErrorImage:(UIImage *)btnErrorImage{
    for (UIButton *btn in self.subviews) {
        [btn setImage:btnErrorImage forState:UIControlStateDisabled];
    }
}

@end
