//
//  POHAPI.m
//  proofh
//
//  Created by 张玉琳 on 2018/3/6.
//  Copyright © 2018年 zyl. All rights reserved.
//

#import "POHAPI.h"

@implementation POHAPI
static POHAPI * _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    // 也可以使用一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            
        }
    });
    // 基础地址
//    _instance.baseUrl = @"http://116.62.113.145/";
    _instance.baseUrl = @"http://120.79.63.89:6389/";
    _instance.appid = @"X6SRSrsEqD53HD7ikCwh0fBraHE8wv";
    
    /*
     *TCZ
     _instance.baseUrl = @"http://120.79.63.89:6392/";
     _instance.appid = @"SX64SRSERrEqD53HD7ikCwhHE8wv1";
     
     */
    /*
     *DSLC
     _instance.baseUrl = @"http://120.79.63.89:6390/";
     _instance.appid = @"X6SRSERQEqD53HD7ikCwh0fBraHE8wv1";
     
     */
    
    /*
     *NCC
     _instance.baseUrl = @"http://120.79.63.89:6391/";
     _instance.appid = @"WX6SRSrslEqD53HD7LikCwh0fBraHE8wv";
     
     */
    _instance.getCodeURL = @"Home/Login/getCode";
    _instance.registerURL = @"login/reg";
    _instance.loginURL = @"login/login";
    _instance.forgetPassURL = @"login/getpassword";
    _instance.changepasswordURL = @"index/changepassword";
    _instance.changePayPasswordURL = @"index/changepaypassword";
    _instance.yuEURL = @"index/getblance";
    _instance.geterwei = @"index/geterwei";
    _instance.zhuanZhang = @"index/sendcoin";
    
    return _instance;
}

// 为了使实例易于外界访问 我们一般提供一个类方法
// 类方法命名规范 share类名|default类名|类名
+ (instancetype)shareInstance {
    // 最好用self 用Tools他的子类调用时会出现错误
    return [[self alloc]init];
}

// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}
@end
