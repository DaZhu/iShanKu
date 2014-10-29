//
//  SKCustomTableView.m
//  ShanKu
//
//  Created by LiangChao on 14-8-17.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import "SKCustomTableView.h"
#import "AFAppDotNetAPIClient.h"
#import "SKDetailViewController.h"

@implementation SKCustomTableView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (_homeTableView == nil) {
            _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            _homeTableView.delegate = self;
            _homeTableView.dataSource = self;
            [_homeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [_homeTableView setBackgroundColor:[UIColor clearColor]];
        }
        if (_tableInfoArray == nil) {
            _tableInfoArray = [[NSMutableArray alloc] init];
        }
        [self addSubview:_homeTableView];
        [self createRefreshHeaderView];
        [self createLoadMoreView];
        
    }
    return self;
}

- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
//    NSLog(@"%@",  item.image);
    SKDetailViewController *detailController = [[SKDetailViewController alloc] init];
    detailController.currentGameInfo = item.gameInfo;
    detailController.gameInfo = _tableInfoArray;
    [(UINavigationController *)self.superview.window.rootViewController pushViewController:detailController animated:YES];
}

#pragma mark 添加HeaderView
-(void)addLoopScrollowView:(SKCustomTableView *)aTableView {
    //添加一张默认图片
    SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:@{@"image": [NSString stringWithFormat:@"logo_58_58"]} tag:-1];
    SGFocusImageFrame *bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, -105, 320, 155) delegate:(id)self imageItems:@[item] isAuto:YES];
    bannerView.delegate = self;
    aTableView.homeTableView.tableHeaderView = bannerView;
    
}

- (void)dealloc
{
    [_tableInfoArray removeAllObjects];

}


#pragma mark 创建下拉刷新header
- (void)createRefreshHeaderView
{
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -_homeTableView.bounds.size.height, _homeTableView.bounds.size.width, _homeTableView.bounds.size.height)];
        view.delegate = self;
        [_homeTableView addSubview:view];
        _refreshHeaderView = view;
        
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}

#pragma mark 创建加载更多按钮
- (void)createLoadMoreView
{
    if (_loadingMoreView == nil) {
        EnLoadingMoreView *view = [[EnLoadingMoreView alloc] initWithFrame:CGRectZero];
        view.loadingMoreDelegate = self;
        [_homeTableView addSubview:view];
        _loadingMoreView = view;
        
    }
    isHasMore = NO;
    
}

#pragma mark - 辅助函数
#pragma mark 强制刷新列表
- (void)forceToFreshData:(NSInteger)type
{
    
    currentType = type + 1;
    [_refreshHeaderView setLoadingStateWithScrollView:_homeTableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_delegate respondsToSelector:@selector(numberOfRowsInTableView:Insection:FromView:)]) {
        NSInteger vRows = [_dataSource numberOfRowsInTableView:tableView Insection:section FromView:self];
        mRowCount = vRows;
        return vRows;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(heightForRowAtIndexPath:IndexPath:FromView:)]) {
        float vRowHeight = [_delegate heightForRowAtIndexPath:tableView IndexPath:indexPath FromView:self];
        return vRowHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataSource respondsToSelector:@selector(cellForRowInTableView:IndexPath:FromView:)]) {
        UITableViewCell *vCell = [_dataSource cellForRowInTableView:tableView IndexPath:indexPath FromView:self];
        [vCell setSelectionStyle:UITableViewCellSelectionStyleNone]; // 禁止变色
        return vCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
   
    if ([_delegate respondsToSelector:@selector(didSelectedRowAtIndexPath:IndexPath:FromView:)])
    {
        [_delegate didSelectedRowAtIndexPath:tableView IndexPath:indexPath FromView:self];
    }
    
}

- (void)changeHeaderContentWithCustomTable
{

    NSDictionary *parameters = @{@"ver": @"1.0", @"fmt": @"json"};
    
    [[AFAppDotNetAPIClient sharedClient] GET:@"index/slide" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *slidesFromResponse = [responseObject valueForKeyPath:@"data.slides"];
        int length = (int)slidesFromResponse.count;
        NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length + 2];
        // 添加最后一张图用于循环
        if (length > 1) {
            NSDictionary *dict = [slidesFromResponse objectAtIndex:length - 1];
            SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:-1];
            [itemArray addObject:item];
        }
        
        for (int i = 0; i < length; i++) {
            NSDictionary *dict = [slidesFromResponse objectAtIndex:i];
            SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:i];
            [itemArray addObject:item];
        }
        
        // 添加第一张图用于循环
        if (length > 1) {
            NSDictionary *dict = [slidesFromResponse objectAtIndex:0];
            SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:length];
            [itemArray addObject:item];
        }
        
        SGFocusImageFrame *vFocusFrame = (SGFocusImageFrame *)_homeTableView.tableHeaderView;
        [vFocusFrame changeImageViewsContent:itemArray];
        
        isLoadingData = YES;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)getDataInBackground
{
    
    NSDictionary *parameters = @{@"type": [NSNumber numberWithInteger:currentType], @"ver": @"1.0", @"pageno": [NSNumber numberWithInteger:startIndex], @"rowcnt": @"10", @"fmt": @"json"};
    
    [[AFAppDotNetAPIClient sharedClient] GET:@"index/index" parameters:parameters success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *postsFromResponse = [JSON valueForKeyPath:@"data.games"];

        if (postsFromResponse != nil && postsFromResponse.count > 0) {
            if (startIndex == 1) {
                [self.tableInfoArray removeAllObjects];
                [self.tableInfoArray addObjectsFromArray:postsFromResponse];
            } else {
                [self.tableInfoArray addObjectsFromArray:postsFromResponse];
            }
            startIndex++;            
        }
        
        if ([postsFromResponse count] == 0) {
            isHasMore = NO;
        } else {
            isHasMore = YES;
        }
        
        isLoaded = YES;
        
        
        // 注册Model模型
        [Config Instance].gameObject = [[GameObject alloc] initWithParameters: self.tableInfoArray];

        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:.3];

 
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [self doneLoadingTableViewData];

    }];
    
}

#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource
{

    _reloading = YES;
    [self getDataInBackground];

    if (currentType == 1 && !isLoadingData) {
        
        [self addLoopScrollowView:self];
        [self changeHeaderContentWithCustomTable];
    }

}

- (void)doneLoadingTableViewData
{
    
    [self.homeTableView reloadData];
    
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.homeTableView];
    [_loadingMoreView enLoadingMoreScrollViewDataSourceDidFinishedLoading:self.homeTableView];
     _reloading = NO;
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    [_refreshHeaderView egoRefreshScrollViewWillBeginScroll:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_loadingMoreView enLoadingMoreScrollViewDidEndDragging:scrollView];
}

#pragma mark - EGORefreshTableHeaderDelgate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    _reloading = YES;
    startIndex = 1;
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    //	if ([_delegate respondsToSelector:@selector(tableViewEgoRefreshTableHeaderDataSourceIsLoading:FromView:)]) {
    //        BOOL vIsLoading = [_delegate tableViewEgoRefreshTableHeaderDataSourceIsLoading:view FromView:self];
    //        return vIsLoading;
    //    }
	return _reloading; // should return if data source model is reloading
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoaded:(EGORefreshTableHeaderView *)view
{
    return isLoaded;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - EnloadMoreViewDelegate Methods
- (BOOL)enLoadingMoreViewDataSourceHasMore:(EnLoadingMoreView *)view
{
    return isHasMore;
}

- (BOOL)enLoadingMoreViewDataSourceIsLoading:(EnLoadingMoreView *)view
{
    return _reloading;
}


- (void)enLoadingMoreViewTriggerRefresh:(EnLoadingMoreView *)view
{
    _reloading = YES;
    [self reloadTableViewDataSource];
    
}

@end
