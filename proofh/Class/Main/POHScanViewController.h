//
//  POHScanViewController.h
//  proofh
//
//  Created by 张玉琳 on 2018/3/9.
//  Copyright © 2018年 zyl. All rights reserved.
//

#import "ViewController.h"

typedef enum : NSUInteger {
    ScanSuccessJumpComeFromHome,
    ScanSuccessJumpComeFromZhuanZhang
} ScanSuccessJumpComeFrom;

typedef void (^ReturnValueBlock) (NSString *strValue);

@interface POHScanViewController : ViewController

@property(nonatomic, copy) ReturnValueBlock returnValueBlock;

/**
 哪个页面跳转的
 */
@property (nonatomic, assign) ScanSuccessJumpComeFrom comeFromVC;

/**
 初始化二维码扫描控制器
 @param finish 扫码完成回调
 @return ScanViewController对象
 */
- (instancetype)initWithCanmOnFinish:(void (^)(NSString *result, NSError *error))finish;

@end
