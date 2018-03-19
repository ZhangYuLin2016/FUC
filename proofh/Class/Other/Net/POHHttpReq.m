//
//  POHHttpReq.m
//  proofh
//
//  Created by 张玉琳 on 2018/3/6.
//  Copyright © 2018年 zyl. All rights reserved.
//

#import "POHHttpReq.h"
#import <AFNetworking.h>

@implementation POHHttpReq

+ (void)requestWithRequestURL:(NSString *)requestURL parameter:(NSDictionary *)parameter requestSuccessBlock:(RequestSuccessBlock)requestSuccessBlock failure:(void (^)(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error))failure {
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", [POHAPI shareInstance].baseUrl, requestURL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    
//    if (parameter == nil) {
//
//        parameter = [NSDictionary dictionaryWithObject:@"X6SRSrsEqD53HD7ikCwh0fBraHE8wv" forKey:@"appid"];
//
//    } else {
//        [parameter setValue:@"X6SRSrsEqD53HD7ikCwh0fBraHE8wv" forKey:@"appid"];
//
//    }
    [manager
     POST:URL
     parameters:parameter
     success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        requestSuccessBlock(dict);
    }
     failure:failure];
}


@end
