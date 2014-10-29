//
//  SKMenuHrizontal.h
//  ShanKu
//
//  Created by LiangChao on 14-8-17.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NORMALKEY   @"normalKey"
#define HILIGHTKEY   @"hilightKey"
#define TITLEKEY    @"titleKey"
#define TITLEWIDTH  @"titleWidth"
#define TOTALWIDTH  @"totalWidth"


// 协议接口
@protocol MenuHrizontalDelegate <NSObject>

@optional
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex;

@end

@interface SKMenuHrizontal : UIView
{
    NSMutableArray      *mButtonArray;
    NSMutableArray      *mItemInfoArray;
    UIScrollView        *mScrollView;
    float               mTotalWidth;
}

@property (nonatomic, weak) id <MenuHrizontalDelegate> delegate;

#pragma mark 初始化菜单栏
- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)aItemsArray;

#pragma mark 选中菜单项
- (void)clickButtonAtIndex:(NSInteger)aIndex;

#pragma mark 改变选中按钮状态
- (void)changeButtonStateAtIndex:(NSInteger)aIndex;

#pragma mark scrollView移动到的坐标
- (void)scrollPageViewCurrentOffset:(float)x;


@end
