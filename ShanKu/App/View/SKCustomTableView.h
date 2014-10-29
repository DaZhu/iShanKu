//
//  SKCustomTableView.h
//  ShanKu
//
//  Created by LiangChao on 14-8-17.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EnLoadingMoreView.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

@class SKCustomTableView;
@protocol CustomTableViewDelegate <NSObject>

@required
- (float)heightForRowAtIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SKCustomTableView *)aView;
- (void)didSelectedRowAtIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView: (SKCustomTableView *)aView;


@end

@protocol CustomTableViewDataSource <NSObject>

@required
- (NSInteger)numberOfRowsInTableView:(UITableView *)aTableView Insection:(NSInteger)section FromView:(SKCustomTableView *)aView;

- (UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView: (SKCustomTableView *)aView;
@end



@interface SKCustomTableView : UIView<UITableViewDelegate, UITableViewDataSource, EGORefreshTableHeaderDelegate, EnLoadingMoreViewDelegate, SGFocusImageFrameDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    NSInteger mRowCount;
    NSInteger startIndex;
    NSInteger currentType;
    NSInteger recordNum;
    BOOL isHasMore;
    BOOL isLoadingData;
    BOOL isLoaded;
    EnLoadingMoreView *_loadingMoreView;
    
}

@property (nonatomic, assign) BOOL reloading;

@property (nonatomic, retain) UITableView *homeTableView;
@property (nonatomic, retain) NSMutableArray *tableInfoArray;
@property (nonatomic, assign) id<CustomTableViewDataSource> dataSource;
@property (nonatomic, assign) id<CustomTableViewDelegate> delegate;

- (void)reloadTableViewDataSource;

#pragma mark 强制列表刷新
- (void)forceToFreshData:(NSInteger)type;

//- (void)backButtonAction: (id)sender;
@end
