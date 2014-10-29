//
//  SKMenuHrizontal.m
//  ShanKu
//
//  Created by LiangChao on 14-8-17.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import "SKMenuHrizontal.h"

#define BUTTONITEMWIDTH 70

@interface SKMenuHrizontal()
{
    UIView *navBg;
    float vButtonWidth;
}

@end

@implementation SKMenuHrizontal

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)aItemsArray
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (mButtonArray == nil) {
            mButtonArray = [[NSMutableArray alloc] init];
        }
        
        if (mScrollView == nil) {
            mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            mScrollView.showsHorizontalScrollIndicator = NO;
        }
        
        if (mItemInfoArray == nil) {
            mItemInfoArray = [[NSMutableArray alloc] init];
        }
        
        // 清除所有选项，重置菜单项
        [mItemInfoArray removeAllObjects];
        [self createdMenuItems: aItemsArray];
        
    }
    return self;
}

- (void)createdMenuItems:(NSArray *)aItemsArray
{
    int i = 0;
    float menuWidth = 0.0;
    for (NSDictionary *dic in aItemsArray) {
        NSString *vTitleStr = [dic objectForKey:TITLEKEY];
        vButtonWidth = [[dic objectForKey:TITLEWIDTH] floatValue];
        
        // 循环创建菜单项
        UIButton *vButton = [UIButton buttonWithType:UIButtonTypeCustom];
        vButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [vButton setTitle:vTitleStr forState:UIControlStateNormal];
        [vButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [vButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [vButton setTag:i];
        [vButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [vButton setFrame:CGRectMake(menuWidth, 0, vButtonWidth, self.frame.size.height)];
        
        [mScrollView addSubview:vButton];
        
        [mButtonArray addObject:vButton];
        
        menuWidth += vButtonWidth;
        i++;
        
        // 保存button的信息
        NSMutableDictionary *vNewDic = [dic mutableCopy];
        [vNewDic setObject:[NSNumber numberWithFloat:menuWidth] forKey:TOTALWIDTH];
        [mItemInfoArray addObject:vNewDic];
    
    }
    
    // 添加背景项
    navBg = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2, vButtonWidth, 2)];
    navBg.backgroundColor = [UIColor colorWithRed:34/255.0 green:151/255.0 blue:89/255.0 alpha:1.0];
    
    [mScrollView addSubview:navBg];
    
    [mScrollView setContentSize:CGSizeMake(menuWidth, self.frame.size.height)];
    [self addSubview:mScrollView];
    
    // 保存menu总长度，如果小于320则不需要移动
    mTotalWidth = menuWidth;

}

#pragma mark - 辅助函数
#pragma mark 取消所有菜单的点击状态
- (void)changeButtonsToNormalState
{
    for (UIButton *vButton in mButtonArray) {
        vButton.selected = NO;
    }
}

#pragma mark 模拟点击对应索引的button
- (void)clickButtonAtIndex:(NSInteger)aIndex
{
    UIButton *vButton = [mButtonArray objectAtIndex:aIndex];
    [self menuButtonClicked:vButton];
}

#pragma mark 置索引按钮为选中状态
- (void)changeButtonStateAtIndex:(NSInteger)aIndex
{
    UIButton *vButton = [mButtonArray objectAtIndex:aIndex];
    [self changeButtonsToNormalState];
    vButton.selected = YES;
    
}

- (void)scrollPageViewCurrentOffset: (float)x
{
    float xx = x *(vButtonWidth / self.frame.size.width);
    [navBg setFrame:CGRectMake(xx, navBg.frame.origin.y, navBg.frame.size.width, navBg.frame.size.height)];
    
}

#pragma mark 移动菜单项到可视区域
- (void)moveScrollViewWithIndex:(NSInteger)aIndex
{
    if (mItemInfoArray.count < aIndex) {
        return;
    }
    
    // 宽度小于320不需要移动
    if (mTotalWidth <= 320) {
        return;
    }
    
    NSDictionary *vDic = [mItemInfoArray objectAtIndex:aIndex];
    float vButtonOrigin = [[vDic objectForKey:TOTALWIDTH] floatValue];
    if (vButtonOrigin >= 300) {
        if ((vButtonOrigin + 180) >= mScrollView.contentSize.width) {
            [mScrollView setContentOffset:CGPointMake(mScrollView.contentSize.width - 320, mScrollView.contentOffset.y) animated:YES];
            return;
        }
        
        float vMoveToContentOffset = vButtonOrigin - 180;
        if (vMoveToContentOffset > 0) {
            [mScrollView setContentOffset:CGPointMake(vMoveToContentOffset, mScrollView.contentOffset.y) animated:YES];
        }
    } else {
        [mScrollView setContentOffset:CGPointMake(0, mScrollView.contentOffset.y) animated: YES];
        return;
    }
}


#pragma mark - 发送模拟点击事件
- (void)menuButtonClicked: (UIButton *)aButton
{
    [self changeButtonStateAtIndex: aButton.tag];
    if ([_delegate respondsToSelector:@selector(didMenuHrizontalClickedButtonAtIndex:)]) {
        [_delegate didMenuHrizontalClickedButtonAtIndex:aButton.tag];
    }
}

- (void)dealloc
{
    [mButtonArray removeAllObjects];
    mButtonArray = nil;

}


@end
