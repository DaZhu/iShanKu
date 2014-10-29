//
//  SKAboutViewController.m
//  ShanKu
//
//  Created by LiangChao on 14-8-25.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import "SKAboutViewController.h"

@interface SKAboutViewController ()

@end

@implementation SKAboutViewController

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
    self.navigationItem.title = @"关于闪酷";
    self.lblVersion.text = [NSString stringWithFormat:@"版本：%@", [Tool getBundleVersion]];
    if (IS_IPHONE_5) {
        self.lblVersion.center = CGPointMake(self.lblVersion.center.x, self.lblVersion.center.y + 88);
        self.lblCopyright.center = CGPointMake(self.lblCopyright.center.x, self.lblCopyright.center.y + 88);
        self.lblTitle.center = CGPointMake(self.lblTitle.center.x, self.lblTitle.center.y + 88);
    }
    
    //适配iOS7uinavigationbar遮挡tableView的问题
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
