//
//  Config.h
//  ShanKu
//
//  Created by LiangChao on 14-8-27.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"
#import "WeChatObject.h"

@interface Config : NSObject

// 游戏信息存储
@property (retain, nonatomic) GameObject *gameObject;

// 微信分享存储
@property (retain, nonatomic) WeChatObject *weChatobject;


+ (Config *) Instance;
@end
