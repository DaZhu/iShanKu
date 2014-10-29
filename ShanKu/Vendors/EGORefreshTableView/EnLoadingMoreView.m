//
//  EnLoadingMoreView.m
//  imeeta
//
//  Created by Jason Li on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnLoadingMoreView.h"
//#import "LoginResult.h"
//#import "NetworkUtility.h"
//#import "VIPDbManager.h"

#define BOTTOM_INSET_HEIGHT 40.f

@implementation EnLoadingMoreView

@synthesize loadingMoreDelegate = _loadingMoreDelegate;
@synthesize userStateString = _userStateString;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor= [UIColor clearColor];
        self.clipsToBounds = YES;
        
        [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIActivityIndicatorView * indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.frame = CGRectMake(150, 10, 20, 20);
        [indicatorView startAnimating];
        [self addSubview:indicatorView];
        _activityIndicatorView = indicatorView;
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 20)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor lightGrayColor];
        _textLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_textLabel];
        
        coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        coverView.hidden = YES;
        coverView.backgroundColor = [UIColor clearColor];
        coverView.userInteractionEnabled = NO;
        [self addSubview:coverView];
        
        UIImageView * coverImageView = [[UIImageView alloc] initWithFrame:coverView.frame];
        coverImageView.image = [[UIImage imageNamed:@"UserCardRiseVip.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        [coverView addSubview:coverImageView];
        
        coverLabel = [[UILabel alloc] initWithFrame:CGRectMake(90-20, 5, 140+40, 30)];
        coverLabel.backgroundColor = [UIColor clearColor];
        coverLabel.textColor = [UIColor whiteColor];
        coverLabel.numberOfLines = 0;
        coverLabel.textAlignment = NSTextAlignmentCenter;
        [coverLabel setFont:[UIFont systemFontOfSize:12]];

//        LoginResult *loginResult = [NetworkUtility sharedNetworkUtility].loginResult;
//        NSString *alertMessaqe = [[VIPDbManager sharedInstance] getAlertMessageWithType:kResourceVipLimitTypeSmallPhoto andLoginResult:loginResult];
//        coverLabel.text = alertMessaqe; // @"您好，您现在还不是会员，点击升级为会员，查看更多靓图";
        [coverView addSubview:coverLabel];
        
        [self setState:EnLoadingMoreViewNormalState];
    }
    return self;
}

- (void)setState:(EnLoadingMoreViewState)aState
{
    switch (aState) {
        case EnLoadingMoreViewNormalState:{
            [_activityIndicatorView stopAnimating];
            _textLabel.hidden = NO;
            _textLabel.text = NSLocalizedString(@"加载更多...", nil);
            self.userInteractionEnabled = YES;
            coverView.hidden = YES;
            break;
        }
        case EnLoadingMoreViewLoadingState:{
            [_activityIndicatorView startAnimating];
            _textLabel.hidden = YES;
            _textLabel.text = nil;
            self.userInteractionEnabled = NO;
            coverView.hidden = YES;
            break;
        }
        case EnLoadingMoreViewNoreMoreState:{
            [_activityIndicatorView stopAnimating];
            _textLabel.hidden = NO;
            _textLabel.text = NSLocalizedString(@"没有更多...", nil);
            self.userInteractionEnabled = NO;
            coverView.hidden = YES;
            break;
        }
        case EnLoadingMoreViewUserState:{
            [_activityIndicatorView stopAnimating];
            _textLabel.hidden = NO;
            coverLabel.text = _userStateString;
            self.userInteractionEnabled = YES;
            coverView.hidden = NO;
        }
        default:
            break;
    }
    _state = aState;
}

- (void)enLoadingMoreScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    BOOL reloading = YES;
    BOOL isHasMore =  NO;
    
    if ([_loadingMoreDelegate respondsToSelector:@selector(enLoadingMoreViewDataSourceIsLoading:)]) {
        reloading = [_loadingMoreDelegate enLoadingMoreViewDataSourceIsLoading:self];
    }
    
    if ([_loadingMoreDelegate respondsToSelector:@selector(enLoadingMoreViewDataSourceHasMore:)]) {
        isHasMore = [_loadingMoreDelegate enLoadingMoreViewDataSourceHasMore:self];
    }
    
    if ((scrollView.contentOffset.y + scrollView.bounds.size.height - BOTTOM_INSET_HEIGHT > scrollView.contentSize.height) && (reloading == NO) && (isHasMore == YES)) {
        [self setState:EnLoadingMoreViewLoadingState];
        
        if ([_loadingMoreDelegate respondsToSelector:@selector(enLoadingMoreViewTriggerRefresh:)]) {
            [_loadingMoreDelegate enLoadingMoreViewTriggerRefresh:self];
        }
    }
}

- (void)enLoadingMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    BOOL isHasMore = NO;
    if ([_loadingMoreDelegate respondsToSelector:@selector(enLoadingMoreViewDataSourceHasMore:)]) {
        isHasMore = [_loadingMoreDelegate enLoadingMoreViewDataSourceHasMore:self];
    }
    if (isHasMore) {
        [self setState:EnLoadingMoreViewNormalState];
    } else {
        [self setState:EnLoadingMoreViewNoreMoreState];
    }
    
//    CGFloat height = (scrollView.contentSize.height < scrollView.frame.size.height) ? scrollView.frame.size.height:scrollView.contentSize.height;
    
    self.frame = CGRectMake(0, scrollView.contentSize.height, 320, BOTTOM_INSET_HEIGHT);
	UIEdgeInsets insets =  scrollView.contentInset;
    insets.bottom = BOTTOM_INSET_HEIGHT;
//    insets.bottom = insets.bottom - 1;
    scrollView.contentInset = insets;
}

- (void)clickAction:(id)sender
{
    BOOL reloading = YES;
    if ([_loadingMoreDelegate respondsToSelector:@selector(enLoadingMoreViewDataSourceIsLoading:)]) {
        reloading = [_loadingMoreDelegate enLoadingMoreViewDataSourceIsLoading:self];
    }
    if (reloading) {
        return;
    }
    
    if (_state == EnLoadingMoreViewUserState) {
        if ([_loadingMoreDelegate respondsToSelector:@selector(enLoadingMoreViewUserStateButtonAction:)]) {
            [_loadingMoreDelegate enLoadingMoreViewUserStateButtonAction:self];
        }
    }else {
        [self setState:EnLoadingMoreViewLoadingState];
        if ([_loadingMoreDelegate respondsToSelector:@selector(enLoadingMoreViewTriggerRefresh:)]) {
            [_loadingMoreDelegate enLoadingMoreViewTriggerRefresh:self];
        }
    }
    
}

+ (CGFloat)enLoadingMoreViewBottomContentInset
{
    return BOTTOM_INSET_HEIGHT;
}

@end
