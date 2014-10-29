//
//  WeChatObject.m
//  ShanKu
//
//  Created by LiangChao on 14-8-28.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import "WeChatObject.h"

@implementation WeChatObject

@synthesize chatInfo;



- (id)initWithParamaters:(NSDictionary *)info
{
    WeChatObject *weChatObject = [[WeChatObject alloc] init];
    weChatObject.chatInfo = info;
    return weChatObject;
}
@end
