//
//  EnLoadingMoreView.h
//  imeeta
//
//  Created by Jason Li on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  enum{
    EnLoadingMoreViewNormalState = 0,
    EnLoadingMoreViewLoadingState,
    EnLoadingMoreViewNoreMoreState,
    EnLoadingMoreViewUserState
}EnLoadingMoreViewState;

@protocol EnLoadingMoreViewDelegate;

@interface EnLoadingMoreView : UIButton {
    UIActivityIndicatorView * _activityIndicatorView;
    UILabel * _textLabel;
    EnLoadingMoreViewState _state;
    UIView * coverView;
    UILabel * coverLabel;
}

@property (nonatomic, weak) id <EnLoadingMoreViewDelegate> loadingMoreDelegate;
@property (nonatomic, strong) NSString * userStateString;

- (void)enLoadingMoreScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)enLoadingMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)clickAction:(id)sender;
+ (CGFloat)enLoadingMoreViewBottomContentInset;
- (void)setState:(EnLoadingMoreViewState)aState;

@end

@protocol EnLoadingMoreViewDelegate <NSObject>

- (void)enLoadingMoreViewTriggerRefresh:(EnLoadingMoreView *)view;
- (BOOL)enLoadingMoreViewDataSourceIsLoading:(EnLoadingMoreView * )view;
- (BOOL)enLoadingMoreViewDataSourceHasMore:(EnLoadingMoreView * )view;

@optional
- (void)enLoadingMoreViewUserStateButtonAction:(EnLoadingMoreView *)view;

@end
