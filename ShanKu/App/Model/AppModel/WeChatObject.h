//
//  WeChatObject.h
//  ShanKu
//
//  Created by LiangChao on 14-8-28.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeChatObject : NSObject

@property (copy, nonatomic) NSDictionary *chatInfo;

- (id)initWithParamaters:(NSDictionary *)info;
@end
