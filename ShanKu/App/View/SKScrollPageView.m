//
//  SKScrollPageView.m
//  ShanKu
//
//  Created by LiangChao on 14-8-17.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import "SKScrollPageView.h"
#import "TOWebViewController.h"
#import "AFAppDotNetAPIClient.h"
#import "SKDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "AMRatingControl.h"
#import "RTLabel.h"
@implementation SKScrollPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        mNeedUseDelegate = YES;
        [self commInit];
    }
    return self;
}

-(void)initData{
    [self freshContentTableAtIndex:0];
}

- (void)commInit
{
    if (_contentItems == nil) {
        _contentItems = [[NSMutableArray alloc] init];
    }
    
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO; // 重要属性，去除scrollView空间的弹跳
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        _scrollView.delegate = self;
    }
    
    [self addSubview:_scrollView];
}

#pragma mark -辅助函数
#pragma mark 添加ScrollView的ContentView
- (void)setContentOfTables:(NSInteger)aNumberOfTables
{
    for (int i = 0; i < aNumberOfTables; i++) {
        SKCustomTableView *vCustomTableView = [[SKCustomTableView alloc] initWithFrame:CGRectMake(320 * i, 0, 320, self.frame.size.height)];
        vCustomTableView.delegate = self;
        vCustomTableView.dataSource = self;
        vCustomTableView.tag = i + 1;
        [_scrollView addSubview:vCustomTableView];
        [_contentItems addObject:vCustomTableView];
    }
    [_scrollView setContentSize:CGSizeMake(320 * aNumberOfTables, self.frame.size.height)];
}

#pragma mark 移动ScrollView到某个页面
- (void)moveScrollViewAtIndex:(NSInteger)aIndex
{
    mNeedUseDelegate = NO;
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width *aIndex, 0) animated:YES];
    mCurrentPage = aIndex;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)]) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }

}

#pragma mark 刷新某个页面
- (void)freshContentTableAtIndex:(NSInteger)aIndex
{
    if (_contentItems.count < aIndex) {
        return;
    }
    
    SKCustomTableView *vTableContentView = (SKCustomTableView *)[_contentItems objectAtIndex:aIndex];
    [vTableContentView forceToFreshData:aIndex];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    mNeedUseDelegate = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 滚动Tab动画
    if ([_delegate respondsToSelector:@selector(scrollPageViewCurrentOffset:)]) {
        [_delegate scrollPageViewCurrentOffset:_scrollView.contentOffset.x];
    }
   
    int page = (_scrollView.contentOffset.x + 320/2.0) / 320;
    
    if (mCurrentPage == page) {
        return;
    }
    mCurrentPage = page;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)] && mNeedUseDelegate) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
    

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        
    }
}

- (void)didTableViewCellClickedButton:(UIButton *)button
{

    SKHomeViewCell *vCell = (SKHomeViewCell*)button.superview.superview.superview;
    
    NSURL *url = [NSURL URLWithString: [vCell.cellInfo objectForKey:@"url"]];

    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    
    [vCell.controller pushViewController:webViewController animated:YES];

}

// build每一个cell的UI
- (void)buildCellUI:(SKHomeViewCell *)cell fromData:(NSDictionary *)data
{
    
    NSString *gameName = [data objectForKey:@"name"];
    
    
    cell.gameNameLabel.text = gameName;
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[data objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    

}

#pragma mark - CustomTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(UITableView *)aTableView Insection:(NSInteger)section FromView:(SKCustomTableView *)aView
{
    return aView.tableInfoArray.count;
}

- (UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SKCustomTableView *)aView
{
    static NSString *vCellIdentify = @"homeCell";
    SKHomeViewCell *vCell = [aTableView dequeueReusableCellWithIdentifier:vCellIdentify];
    NSDictionary *responseInfo = [aView.tableInfoArray objectAtIndex:aIndexPath.row];
    if (vCell == nil) {
        vCell = [[[NSBundle mainBundle] loadNibNamed:@"SKHomeViewCell" owner:self options:nil] lastObject];
        
        NSString *gameDownLoad = [responseInfo objectForKey:@"downloads"];
        RTLabel *downloadLabel = [[RTLabel alloc] initWithFrame:CGRectMake(88, 64, 142, 20)];
        downloadLabel.lineSpacing = 20.0;
        [downloadLabel setText: [NSString stringWithFormat:@"<font size=12 face=Helvetica>已有<font color='#ff9752'>%@</font>人在玩</font>", gameDownLoad]];
        
        [vCell addSubview:downloadLabel];
        
        AMRatingControl *colorRatingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(88, 42) emptyColor:[UIColor clearColor] solidColor:[UIColor redColor] andMaxRating:5];
        [colorRatingControl setStarFontSize:12];
        [colorRatingControl setUserInteractionEnabled:NO];
        [colorRatingControl setStarWidthAndHeight:15];
        [colorRatingControl setRating: ([[responseInfo objectForKey:@"score"] intValue]/2)];
        
        [vCell addSubview: colorRatingControl];
    }
    
    [self buildCellUI: vCell fromData: responseInfo];
    vCell.cellButton.tag = aIndexPath.row;
    vCell.delegate = self;
    vCell.cellInfo = responseInfo;
    vCell.controller =  (UINavigationController *)self.superview.window.rootViewController; // 比较纠结的指针引用方式,待重构
    
    return vCell;
}

#pragma mark CustomTableViewDelegate
- (float)heightForRowAtIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SKCustomTableView *)aView
{
    SKHomeViewCell *vCell = [[[NSBundle mainBundle] loadNibNamed:@"SKHomeViewCell" owner:self options:nil] lastObject];
    return vCell.frame.size.height;
}

- (void)didSelectedRowAtIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SKCustomTableView *)aView
{
    SKHomeViewCell *vCell = (SKHomeViewCell *)[aTableView cellForRowAtIndexPath:aIndexPath];

    SKDetailViewController *detailController = [[SKDetailViewController alloc] init];
    detailController.currentGameInfo = vCell.cellInfo;
    detailController.gameInfo = aView.tableInfoArray;
    
    [vCell.controller pushViewController:detailController animated:YES];
}


- (BOOL)tableViewEgoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view FromView:(SKCustomTableView *)aView{
    return  aView.reloading;
}


@end
