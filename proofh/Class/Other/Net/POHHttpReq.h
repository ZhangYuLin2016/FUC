//
//  POHHttpReq.h
//  proofh
//
//  Created by 张玉琳 on 2018/3/6.
//  Copyright © 2018年 zyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POHAPI.h"

typedef void(^RequestSuccessBlock)(NSDictionary *responseObject);

@interface POHHttpReq : NSObject

+ (void)requestWithRequestURL:(NSString *)requestURL parameter:(NSDictionary *)parameter requestSuccessBlock:(RequestSuccessBlock)requestSuccessBlock failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


@end
