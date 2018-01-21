//
//  RH_WithdrawAddBitCoinAddressController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_WithdrawAddBitCoinAddressController.h"

@interface RH_WithdrawAddBitCoinAddressController ()
@property (weak, nonatomic) IBOutlet UIView *view_Back;

@property (strong, nonatomic)  UITextField *textF;
@property (weak, nonatomic) IBOutlet UIButton *button_Reset;
@property (weak, nonatomic) IBOutlet UIButton *button_Submit;
@end

@implementation RH_WithdrawAddBitCoinAddressController

- (BOOL)isSubViewController {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view insertSubview:self.view_Back atIndex:1];
    self.view_Back.backgroundColor = [UIColor whiteColor];
    self.view_Back.userInteractionEnabled = YES;
    self.view_Back.whc_TopSpace(70).whc_LeftSpace(0).whc_RightSpace(0).whc_Height(230);
    self.textF = [[UITextField alloc] init];
    [self.view_Back addSubview:self.textF];
    self.textF.whc_LeftSpace(5).whc_RightSpace(5).whc_TopSpace(100).whc_Height(44);
    self.textF.borderStyle = UITextBorderStyleRoundedRect;
    self.textF.textAlignment = NSTextAlignmentRight;
    
    self.button_Reset.whc_TopSpaceToView(20, self.textF).whc_LeftSpaceEqualView(self.textF).whc_Height(44).whc_WidthEqualViewRatio(self.textF, 0.45);
    self.button_Submit.whc_TopSpaceToView(20, self.textF).whc_RightSpaceEqualView(self.textF).whc_Height(44).whc_WidthEqualViewRatio(self.textF, 0.45);
    [self.button_Reset setBackgroundColor:colorWithRGB(27, 117, 217)];
    self.button_Reset.layer.cornerRadius = 5;
    self.button_Reset.clipsToBounds = YES;
    [self.button_Reset setTitleColor:colorWithRGB(255, 255, 255) forState:UIControlStateNormal];
    [self.button_Reset setTitle:@"重置" forState:UIControlStateNormal];
    [self.button_Reset setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button_Submit setBackgroundColor:colorWithRGB(27, 117, 217)];
    self.button_Submit.layer.cornerRadius = 5;
    self.button_Submit.clipsToBounds = YES;
    [self.button_Submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button_Submit setTitle:@"提交" forState:UIControlStateNormal];
    
}

- (void)buttonResetHandler {
//    ifRespondsSelector(self.delegate, @selector(withdrawAddBitCoinAddressResetButtonClicked:)) {
//        [self.delegate withdrawAddBitCoinAddressResetButtonClicked:self.button_Reset];
//    }
}

- (void)buttonSubmitHandler {
//    ifRespondsSelector(self.delegate, @selector(withdrawAddBitCoinAddressSubmitButtonClicked:)) {
//        [self.delegate withdrawAddBitCoinAddressResetButtonClicked:self.button_Submit];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
