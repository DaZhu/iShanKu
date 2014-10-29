//
//  SKAppDelegate.h
//  ShanKu
//
//  Created by LiangChao on 14-8-17.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICETutorialController.h"
#import "SKViewController.h"
#import "MobClick.h"
#import "UMessage.h"
#import "WXApi.h"

@interface SKAppDelegate : UIResponder <UIApplicationDelegate, ICETutorialControllerDelegate, UIAlertViewDelegate, sendMsgToWeChatViewDelegate, WXApiDelegate>
{
    UIImageView *slognView;
    UIView *mainLoadingView;
    enum WXScene _scene;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) SKViewController *rootController;
@property (strong, nonatomic) ICETutorialController *viewController;
@property (strong, nonatomic) NSDictionary *userInfo;
- (void)sendLinkContent;
@end
