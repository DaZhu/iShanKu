//
//  SKShakeViewController.m
//  ShanKu
//
//  Created by LiangChao on 14-8-26.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import "SKShakeViewController.h"
#import "Tool.h"
#import "TOWebViewController.h"
@interface SKShakeViewController ()

@end

@implementation SKShakeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        self.navigationItem.backBarButtonItem = backItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"glass" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)randomGame
{

    if ([Config Instance].gameObject) {
        NSArray *games = [Tool shuffleArray:[Config Instance].gameObject.gameInfo];
        NSString *url = [[games firstObject] objectForKey:@"url"];
        TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
        [self.navigationController pushViewController:webViewController animated:YES];
        
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        AudioServicesPlaySystemSound(soundID);
        [self randomGame];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"摇一摇"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [MobClick endLogPageView:@"摇一摇"];
}

@end
