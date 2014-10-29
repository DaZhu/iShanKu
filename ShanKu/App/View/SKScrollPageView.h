//
//  SKScrollPageView.h
//  ShanKu
//
//  Created by LiangChao on 14-8-17.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKCustomTableView.h"
#import "SKHomeViewCell.h"

@protocol ScrollPageViewDelegate <NSObject>

- (void)didScrollPageViewChangedPage:(NSInteger)aPage;
- (void)scrollPageViewCurrentOffset:(float)x;

@end

@interface SKScrollPageView : UIView<UIScrollViewDelegate, CustomTableViewDataSource, CustomTableViewDelegate, UITableViewCellDelegate>
{
    NSInteger mCurrentPage;
    BOOL mNeedUseDelegate;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *contentItems;

@property (nonatomic, weak) id<ScrollPageViewDelegate> delegate;

#pragma mark 添加ScrollView的ContentView
- (void)setContentOfTables:(NSInteger)aNumberOfTables;
#pragma mark 滑动到某个页面
- (void)moveScrollViewAtIndex:(NSInteger)aIndex;
#pragma mark 刷新某个页面
- (void)freshContentTableAtIndex:(NSInteger)aIndex;
#pragma mark 改变TableView上面滚动栏的内容
//- (void)changeHeaderContentWithCustomTable:(SKCustomTableView *)aTableContent;

@end
