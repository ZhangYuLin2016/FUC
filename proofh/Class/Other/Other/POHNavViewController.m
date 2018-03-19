//
//  POHNavViewController.m
//  proofh
//
//  Created by 张玉琳 on 2018/3/5.
//  Copyright © 2018年 zyl. All rights reserved.
//

#import "POHNavViewController.h"

@interface POHNavViewController ()

@end

@implementation POHNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self nav];
}

- (void)nav{
    UINavigationBar * bar = [UINavigationBar appearance];
    bar.barTintColor = kNavColor;
    bar.tintColor = kTextColor;
    bar.translucent = NO;
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:kTextColor}];
    [bar setBackgroundImage:[UIImage new]
             forBarPosition:UIBarPositionAny
                 barMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[UIImage new]];
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
