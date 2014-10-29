//
//  SKAppDelegate.m
//  ShanKu
//
//  Created by LiangChao on 14-8-17.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import "SKAppDelegate.h"


@implementation SKAppDelegate

- (id)init
{
    if (self = [super init]) {
        _scene = WXSceneSession;
        [Tool init];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    _rootController = [[SKViewController alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:_rootController];
    _rootController.delegate = self;
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    UIImage *image = [UIImage imageNamed:@"nav_bar"];
    image=[image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
    
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

    
    [self initSplashAnimation];
    
    // 注册友盟统计
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH channelId: nil];
    [MobClick checkUpdate];
//    [MobClick setLogEnabled:YES];
    
    // 注册在线参数
    [MobClick updateOnlineConfig];
    
    [WXApi registerApp: WeChat_APPKEY withDescription:@"一闪而过，依然很酷"];
    
    
    
    // 注册友盟推送
    [UMessage startWithAppkey:UMENG_APPKEY launchOptions:launchOptions];
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
//    [UMessage setLogEnabled:YES];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


#pragma mark - 游戏开场动画
- (void)initSplashAnimation
{
    slognView = [[UIImageView alloc] initWithFrame:self.window.frame];
    slognView.image = [UIImage imageNamed:@"loding.jpg"];
    mainLoadingView = [[UIView alloc] initWithFrame:self.window.frame];
    [mainLoadingView addSubview:slognView];
    [self.window addSubview:mainLoadingView];
    [self performSelector:@selector(splashAnimationLoading) withObject:nil afterDelay:.2];
}

- (void)splashAnimationLoading
{
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.2;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    mainLoadingView.hidden = YES;
    [[mainLoadingView layer] addAnimation:animation forKey:@"animation"];
       
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:@"guideRuned"]) {
        [self initGuideAnimation];
        [userDefaults setBool:YES forKey:@"guideRuned"];
        [userDefaults synchronize];
    } else {
        self.window.rootViewController = _navigationController;
    }

}

#pragma mark - 游戏引导介绍
- (void)initGuideAnimation
{
    
    // Init the pages texts, and pictures.
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"guide_00@2x.jpg"
                                                            duration:3.0];
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"guide_01@2x.jpg"
                                                            duration:3.0];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"guide_02@2x.jpg"
                                                            duration:3.0];

    NSArray *tutorialLayers = @[layer1,layer2,layer3];
    
    // Set the common style for the title.
    ICETutorialLabelStyle *titleStyle = [[ICETutorialLabelStyle alloc] init];
    [titleStyle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
    [titleStyle setTextColor:[UIColor whiteColor]];
    [titleStyle setLinesNumber:1];
    [titleStyle setOffset:180];
    [[ICETutorialStyle sharedInstance] setTitleStyle:titleStyle];
    
    // Set the subTitles style with few properties and let the others by default.
    [[ICETutorialStyle sharedInstance] setSubTitleColor:[UIColor whiteColor]];
    [[ICETutorialStyle sharedInstance] setSubTitleOffset:150];
    
    // Init tutorial.
    self.viewController = [[ICETutorialController alloc] initWithPages:tutorialLayers
                                                              delegate:self];
    // Run it.
    [self.viewController startScrolling];
    
    self.window.rootViewController = self.viewController;
}

// 进入游戏
- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnRightButton:(UIButton *)sender {
    
    [self.viewController stopScrolling];
    self.window.rootViewController = _navigationController;
}


#pragma mark - 微信相关
- (void)changeScene:(NSInteger)scene
{
    _scene = (int)scene;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    [UMessage sendClickReportForRemoteNotification:self.userInfo];

}


- (void)sendLinkContent
{

    NSDictionary *weChatInfo = [Config Instance].weChatobject.chatInfo;
    NSURL *imageUrl = [NSURL URLWithString:[weChatInfo objectForKey:@"image"]];
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [weChatInfo objectForKey:@"title"];
    message.description = [weChatInfo objectForKey:@"description"];
    [message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = Mobile_URL;

    if ([weChatInfo objectForKey:@"url"] == nil) {
        ext.webpageUrl = Mobile_URL;
    } else {
        ext.webpageUrl = [weChatInfo objectForKey:@"url"];
    }
    
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];

//    NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  isSuc;
}


#pragma mark - 友盟推送服务
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage setAutoAlert:NO];
    self.userInfo = userInfo;
    NSString *pushMsg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    [UMessage didReceiveRemoteNotification:userInfo];
    
//    自定义弹出框
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"消息提醒" message:pushMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
