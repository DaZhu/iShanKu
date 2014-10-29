//
//  Config.m
//  ShanKu
//
//  Created by LiangChao on 14-8-27.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import "Config.h"

@implementation Config
@synthesize gameObject;
@synthesize weChatobject;

static Config *instance = nil;
+ (Config *) Instance
{
    @synchronized(self)
    {
        if (nil == instance) {
            [self new];
        }
    }
    return instance;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}
@end
