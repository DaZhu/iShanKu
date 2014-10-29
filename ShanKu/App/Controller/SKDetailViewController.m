//
//  SKDetailViewController.m
//  ShanKu
//
//  Created by LiangChao on 14-8-22.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import "SKDetailViewController.h"
#import "TOWebViewController.h"
#import "Macros.h"
#import "UIButton+WebCache.h"
#import "RTLabel.h"

@interface SKDetailViewController ()
{
    NSArray *randomGames;
}

@end

@implementation SKDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.randomScroll.bounces = NO; // 重要属性，去除scrollView空间的弹跳
        self.randomScroll.showsHorizontalScrollIndicator = NO;
        self.randomScroll.showsVerticalScrollIndicator = NO;
//        self.randomScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}


- (void)setupNavigationBar
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_more_white"] style:UIBarButtonItemStylePlain target:self action:@selector(operationMore:)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.title = [_currentCell.cellInfo objectForKey:@"name"];
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

- (void)scanAndScan
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ScanAndScan object:nil userInfo:@{@"controller": self.navigationController}];
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self setupNavigationBar];

    self.gameIcon.layer.cornerRadius = 5;
    self.gameIcon.layer.masksToBounds = YES;
    self.startGame.layer.cornerRadius = 5;
    self.startGame.layer.masksToBounds = YES;
    self.detailScrollView.scrollEnabled = YES;
    [self.detailScrollView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.randomScroll.frame.origin.y + 240)];
//    self.detailScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight; // important for 3.5-inch
    self.detailScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.randomScroll.frame.origin.y + 95);
    
    self.gameName.text = [_currentGameInfo objectForKey:@"name"];
    [self.gameIcon sd_setBackgroundImageWithURL:[NSURL URLWithString:[_currentGameInfo objectForKey:@"icon"]] forState:UIControlStateNormal placeholderImage:nil];
    self.gameRecomend.text = [_currentGameInfo objectForKey:@"recomment"];
    self.gameDesc.lineBreakMode = NSLineBreakByWordWrapping;
    self.gameDesc.numberOfLines = 0;
    self.gameDesc.text = [_currentGameInfo objectForKey:@"desc"];
    
    NSString *gameDownLoad = [_currentGameInfo objectForKey:@"downloads"];

    RTLabel *downloadLabel = [[RTLabel alloc] initWithFrame:CGRectMake(102, 43, 182, 20)];
    downloadLabel.lineSpacing = 20.0;
    [downloadLabel setText: [NSString stringWithFormat:@"<font size=12 face=Helvetica><font color=#ff9752>%@</font>人在玩</font>", gameDownLoad]];
    
//    RTLabel *authorLabel = [[RTLabel alloc] initWithFrame:CGRectMake(102, 65, 182, 20)];
//    authorLabel.lineSpacing = 20.0;
//    [authorLabel setText: [NSString stringWithFormat:@"%@", [_currentGameInfo objectForKey:@"author"]]];
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(102, 64, 182, 20)];
    authorLabel.text = [_currentGameInfo objectForKey:@"author"];
    authorLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];

    [self.scrollView addSubview:authorLabel];
    [self.scrollView addSubview:downloadLabel];
    
    [self randomGame];
    [self initWeChatData];
    
}

- (void)initWeChatData
{
    
    
    [Config Instance].weChatobject = [[WeChatObject alloc] initWithParamaters:@{
                                                                                @"title": [_currentGameInfo objectForKey:@"name"],
                                                                                @"description": [_currentGameInfo objectForKey:@"share"],
                                                                                @"image": [_currentGameInfo objectForKey:@"icon"],
                                                                                @"url": [_currentGameInfo objectForKey:@"url"]
                                                                                
                                                                                }];
    
}

- (IBAction)startGame:(UIButton *)sender {
    [self gotoWebView:[_currentGameInfo objectForKey:@"url"]];
}

- (void)runRandomGame:(UIButton *)sender
{
    NSString *url = [randomGames[sender.tag] objectForKey:@"url"];
    [self gotoWebView:url];
}

- (void)gotoWebView:(NSString *) url
{
 
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)randomGame
{

    randomGames = [Tool shuffleArray:self.gameInfo];
    
    int width = 16; int i = 0;
    for (NSDictionary *item in randomGames) {

        
        UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(width, 0, 62, 62)];
        
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.tag = i++;
        [view sd_setBackgroundImageWithURL:[item objectForKey:@"icon"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [view addTarget:self action:@selector(runRandomGame:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(width, 62 + 2, 62, 20)];
        title.text = [item objectForKey:@"name"];
        title.font = [UIFont fontWithName:@"Helvetica Neue" size:12.0f];
        title.textAlignment = NSTextAlignmentCenter;
        
        width = width + 62 + 16;
        
        [self.randomScroll addSubview:title];
        [self.randomScroll addSubview:view];
        
    }
    
    CGSize contentSize = CGSizeMake(width, 62);
    self.randomScroll.bounces = NO;
    self.randomScroll.pagingEnabled = YES;
    self.randomScroll.contentSize = contentSize;
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"详情页"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [MobClick endLogPageView:@"详情页"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
