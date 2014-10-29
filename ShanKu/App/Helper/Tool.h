//
//  Tool.h
//  ShanKu
//
//  Created by LiangChao on 14-8-27.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KxMenu.h"
#import "SKShakeViewController.h"
#import "SKScanViewController.h"
#import "SKAppDelegate.h"

@interface Tool : NSObject

// 洗牌算法
+ (NSArray*)shuffleArray: (NSArray*) array;

// 创建下拉菜单
+ (void)createMenu:(id)sender target:(id)t;

// 开启消息中心监听机制
+ (void)initGlobalBroadcast;
+ (void) shakeToShake: (NSNotification *) notification;
+ (void) shareToFriendCircle;
+ (void) shareToFriend;
+ (void) checkUpdate;

// 获取版本
+ (NSString *) getBundleVersion;
@end
