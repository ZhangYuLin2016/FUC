//
//  POHAPI.h
//  proofh
//
//  Created by 张玉琳 on 2018/3/6.
//  Copyright © 2018年 zyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POHAPI : NSObject

+ (instancetype)shareInstance;
@property (nonatomic, strong) NSString * baseUrl;
@property (nonatomic, strong) NSString * appid;
/**
 获取手机验证码
 */
@property (nonatomic, strong) NSString * getCodeURL;

/**
 注册
 */
@property (nonatomic, strong) NSString * registerURL;

/**
 登陆
 */
@property (nonatomic, strong) NSString * loginURL;


/**
 忘记密码  找回密码
 */
@property (nonatomic, strong) NSString * forgetPassURL;


/**
 修改登录密码
 */
@property (nonatomic, strong) NSString * changepasswordURL;

/**
 修改交易密码
 */
@property (nonatomic, strong) NSString * changePayPasswordURL;

/**
 首页余额和交易记录
 */
@property (nonatomic, strong) NSString * yuEURL;

/**
 获取addr
 */
@property (nonatomic, strong) NSString * geterwei;


/**
 * 转账
 */
@property (nonatomic, strong) NSString * zhuanZhang;


@end
