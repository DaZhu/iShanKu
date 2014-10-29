//
//  Tool.m
//  ShanKu
//
//  Created by LiangChao on 14-8-27.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import "Tool.h"
#import "SKAppDelegate.h"

@implementation Tool

+ (NSArray*)shuffleArray:(NSArray*)array {
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:array];
    
    for(NSUInteger i = [array count]; i > 1; i--) {
        NSInteger j = arc4random_uniform((int)i);
        [temp exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
    
    return [NSArray arrayWithArray:temp];
}

+ (void)createMenu:(id)sender target:(UIViewController *)t
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"发送给朋友" image:[UIImage imageNamed:@"menu_weixin" ] target:t action:@selector(shareToFriend)],
      [KxMenuItem menuItem:@"分享到朋友圈" image:[UIImage imageNamed: @"menu_weixin_circle"] target:t action:@selector(shareToCircle)],
      [KxMenuItem menuItem:@"随手摇一摇" image:[UIImage imageNamed: @"menu_shake"] target:t action:@selector(shakeAndShake)],
      [KxMenuItem menuItem:@"检查更新" image:[UIImage imageNamed: @"menu_checkupdate"] target:t action:@selector(checkUpdate)],
      [KxMenuItem menuItem:@"意见反馈" image:[UIImage imageNamed: @"menu_feedback"] target: t action:@selector(initFeedBack)],
      [KxMenuItem menuItem:@"关于闪酷" image:[UIImage imageNamed: @"menu_about"] target:t action:@selector(aboutShanku)],
      
      ];
    
    if (IS_IOS7) {
        menuItems =
        @[
          
          [KxMenuItem menuItem:@"发送给朋友" image:[UIImage imageNamed:@"menu_weixin" ] target:t action:@selector(shareToFriend)],
          [KxMenuItem menuItem:@"分享到朋友圈" image:[UIImage imageNamed: @"menu_weixin_circle"] target:t action:@selector(shareToCircle)],
          [KxMenuItem menuItem:@"随手摇一摇" image:[UIImage imageNamed: @"menu_shake"] target:t action:@selector(shakeAndShake)],
          [KxMenuItem menuItem:@"随手扫一扫" image:[UIImage imageNamed: @"menu_qrcode"] target:t action:@selector(scanAndScan)],
          [KxMenuItem menuItem:@"检查更新" image:[UIImage imageNamed: @"menu_checkupdate"] target:t action:@selector(checkUpdate)],
          [KxMenuItem menuItem:@"意见反馈" image:[UIImage imageNamed: @"menu_feedback"] target: t action:@selector(initFeedBack)],
          [KxMenuItem menuItem:@"关于闪酷" image:[UIImage imageNamed: @"menu_about"] target:t action:@selector(aboutShanku)],
          
          ];
    }
    
    UIView *targetView = (UIView *)[sender performSelector:@selector(view)];
    CGRect _rect = targetView.frame;
    _rect.origin.y = _rect.origin.y + 30;
    CGRect rect = _rect;
    
    [KxMenu showMenuInView: t.navigationController.view fromRect: rect menuItems:menuItems];
}

+ (void)init
{
    [self initGlobalBroadcast];
}

+ (void)initGlobalBroadcast
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shakeToShake:) name:Notification_ShakeToShake object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanAndScan:) name: Notification_ScanAndScan object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aboutShanku:) name: Notification_AboutShanku object:nil];
}

// 摇一摇
+ (void) shakeToShake: (NSNotification *) notification
{
    NSDictionary *info = [notification userInfo];
    SKShakeViewController *shakeView = [[SKShakeViewController alloc] init];
   
    [[info objectForKey:@"controller"] pushViewController:shakeView animated:YES];
}

+ (void) scanAndScan: (NSNotification *) notification
{
    [self setupCamera: notification];
}

// 调起相机
+ (void)setupCamera: (NSNotification *) notification
{
    NSDictionary *info = [notification userInfo];
    if (IS_IOS7) {
        SKScanViewController *scan = [[SKScanViewController alloc] init];
        
        [[info objectForKey:@"controller"] presentViewController:scan animated:YES completion:^{
            
        }];
    } else {
        
    }
    
}

// 分享到朋友圈
+ (void) shareToFriendCircle
{
    
    SKAppDelegate *AppDelegate = (SKAppDelegate *)[[UIApplication sharedApplication] delegate];
    [AppDelegate changeScene:WXSceneTimeline];
    [AppDelegate sendLinkContent];
    [MobClick event:@"shareToCircle"];
}

+ (void) shareToFriend
{
    SKAppDelegate *AppDelegate = (SKAppDelegate *)[[UIApplication sharedApplication] delegate];
    [AppDelegate changeScene:WXSceneSession];
    [AppDelegate sendLinkContent];
    [MobClick event:@"shareToFriend"];
}

+ (void)aboutShanku: (NSNotification *) notification
{
    NSDictionary *info = [notification userInfo];
    SKAboutViewController *about = [[SKAboutViewController alloc] init];
    [[info objectForKey:@"controller"] pushViewController:about animated:YES];
}

+ (void) checkUpdate
{
    [MobClick checkUpdateWithDelegate:self selector:@selector(isUpdate:)];
}



+ (void)isUpdate:(NSDictionary *)appInfo
{
    
    if ([[appInfo objectForKey:@"update"] isEqualToString:@"NO"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"已经是最新版本" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

+ (NSString *) getBundleVersion
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    return version;
}

@end
