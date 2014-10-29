//
//  SKViewController.m
//  ShanKu
//
//  Created by LiangChao on 14-8-17.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import "SKViewController.h"
#import "SKHomeView.h"
#import "Macros.h"
#import "KxMenu.h"

@interface SKViewController ()
{
    SKHomeView *mHomeView;
}

@end

@implementation SKViewController

@synthesize delegate = _delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        

    }
    return self;
}

- (void)viewDidLoad
{
    [self initView];
    [self setupNavigationBar];
    [self initWeChatData];
    [UMFeedback setLogEnabled:YES];
    _umFeedback = [UMFeedback sharedInstance];
    [_umFeedback setAppkey:UMENG_APPKEY delegate:self];

}

- (void)initWeChatData
{
    
    NSString *title = [MobClick getConfigParams:@"share_title"];
    NSString *desc = [MobClick getConfigParams:@"share_desc"];
    NSString *icon = [MobClick getConfigParams:@"share_icon"];
    
    [Config Instance].weChatobject = [[WeChatObject alloc] initWithParamaters:@{
                                                                                          @"title": title,
                                                                                          @"description": desc,
                                                                                          @"image": icon,
                                                                                          @"url": Mobile_URL
                                                                                          
                                                                                          }];
    
}

- (void)setupNavigationBar
{
    
    UIView *topbarView = [[[NSBundle mainBundle] loadNibNamed:@"SKTopbar" owner:nil options:nil] lastObject];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:topbarView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_more_white"] style:UIBarButtonItemStylePlain target:self action:@selector(operationMore:)];
    self.navigationItem.rightBarButtonItem = item;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}

#pragma mark - 下拉菜单操作
- (void)operationMore:(id)sender
{

    [Tool createMenu:sender target:self];
    
}

- (void)shakeAndShake
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ShakeToShake object:nil userInfo:@{@"controller": self.navigationController}];
}

- (void)scanAndScan
{
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ScanAndScan object:nil userInfo:@{@"controller": self.navigationController}];
}

- (void)shareToFriend
{

    [Tool shareToFriend];
    
}

- (void)shareToCircle
{
    [Tool shareToFriendCircle];
    
}

- (void)aboutShanku
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_AboutShanku object:nil userInfo:@{@"controller": self.navigationController}];
}

- (void)checkUpdate
{

    [Tool checkUpdate];
}

- (void)initFeedBack
{
    [UMFeedback showFeedback:self withAppkey:UMENG_APPKEY];
}

// 初始化view
- (void)initView
{
    if (IS_IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    int vWidth = (int)([UIScreen mainScreen].bounds.size.width);
    int vHeight = (int)([UIScreen mainScreen].bounds.size.height);
    
    CGRect vViewRect = CGRectMake(0, 0, vWidth, vHeight-44-20);
    UIView *vContentView = [[UIView alloc] initWithFrame:vViewRect];
    
    if (mHomeView == nil) {
        mHomeView = [[SKHomeView alloc] initWithFrame: vContentView.frame];
    }
    
    [vContentView addSubview:mHomeView];
    self.view = vContentView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"列表页"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [MobClick endLogPageView:@"列表页"];
}

- (void)initIntroduction
{
    // Init the pages texts, and pictures.
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"tutorial_background_00@2x.jpg"
                                                            duration:3.0];
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"tutorial_background_01@2x.jpg"
                                                            duration:3.0];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"tutorial_background_02@2x.jpg"
                                                            duration:3.0];
    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"tutorial_background_03@2x.jpg"
                                                            duration:3.0];
    ICETutorialPage *layer5 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"tutorial_background_04@2x.jpg"
                                                            duration:3.0];
    NSArray *tutorialLayers = @[layer1,layer2,layer3,layer4,layer5];

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
    
    [self.view addSubview:self.viewController.view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self initIntroduction];
    
   
}

@end
