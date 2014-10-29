//
//  SKHomeView.m
//  ShanKu
//
//  Created by LiangChao on 14-8-17.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import "SKHomeView.h"
#import "SKHomeViewCell.h"
#define MENUHEIGHT 35

@implementation SKHomeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self renderUI];
    }
    return self;
}


#pragma mark UI渲染
- (void)renderUI
{
    float menuWidth = self.frame.size.width / 3.0f;
    NSArray *vButtonItemArray = @[@{NORMALKEY: @"normal.png",
                                    HILIGHTKEY: @"hilight.png",
                                    TITLEKEY: @"精选",
                                    TITLEWIDTH: [NSNumber numberWithFloat:menuWidth]},
                                  @{NORMALKEY: @"normal.png",
                                    HILIGHTKEY: @"hilight.png",
                                    TITLEKEY: @"最新",
                                    TITLEWIDTH: [NSNumber numberWithFloat:menuWidth]},
                                  @{NORMALKEY: @"normal.png",
                                    HILIGHTKEY: @"hilight.png",
                                    TITLEKEY: @"排行",
                                    TITLEWIDTH: [NSNumber numberWithFloat:menuWidth]}
                                  ];
    if (mMenuHrizontal == nil) {
        mMenuHrizontal = [[SKMenuHrizontal alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, MENUHEIGHT) ButtonItems:vButtonItemArray];
        mMenuHrizontal.delegate = self;

    }
    
    if (mScrollPageView == nil) {
        mScrollPageView = [[SKScrollPageView alloc] initWithFrame:CGRectMake(0, MENUHEIGHT, self.frame.size.width, self.frame.size.height - MENUHEIGHT)];
        mScrollPageView.delegate = self;
    }
    [mScrollPageView setContentOfTables:vButtonItemArray.count];
    [mMenuHrizontal clickButtonAtIndex:0];
    [self addSubview:mScrollPageView];
    [self addSubview:mMenuHrizontal];
    
}

#pragma mark - 辅助函数
- (void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex
{
        [mScrollPageView moveScrollViewAtIndex:aIndex];
}

#pragma mark ScrollPageViewDelegate
- (void)didScrollPageViewChangedPage:(NSInteger)aPage
{
    [mMenuHrizontal changeButtonStateAtIndex:aPage];
    [mScrollPageView freshContentTableAtIndex:aPage];
}

- (void)scrollPageViewCurrentOffset:(float)x
{
    [mMenuHrizontal scrollPageViewCurrentOffset: x];
}


- (void)dealloc
{

    mMenuHrizontal = nil;
    mScrollPageView = nil;

}

@end
