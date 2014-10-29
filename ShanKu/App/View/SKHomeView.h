//
//  SKHomeView.h
//  ShanKu
//
//  Created by LiangChao on 14-8-17.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKMenuHrizontal.h"
#import "SKScrollPageView.h"

@interface SKHomeView : UIView<MenuHrizontalDelegate, ScrollPageViewDelegate>
{
    SKMenuHrizontal *mMenuHrizontal;
    SKScrollPageView *mScrollPageView;
}

@end
