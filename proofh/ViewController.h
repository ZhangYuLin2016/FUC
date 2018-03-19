//
//  ViewController.h
//  proofh
//
//  Created by 张玉琳 on 2018/3/5.
//  Copyright © 2018年 zyl. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark - UIScrollView的分类
@interface UIScrollView (UITouch)

@end

@interface ViewController : UIViewController
@property (nonatomic, strong) UITableView *tableView;
- (void)showTost:(NSString *)txt;


@end

