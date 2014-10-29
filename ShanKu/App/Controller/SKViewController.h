//
//  SKViewController.h
//  ShanKu
//
//  Created by LiangChao on 14-8-17.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICETutorialController.h"
#import "UMFeedback.h"
#import "SKAboutViewController.h"
#import "SKShakeViewController.h"
#import "WXApiObject.h"

@protocol sendMsgToWeChatViewDelegate <NSObject>

- (void) changeScene:(NSInteger)scene;
- (void) sendLinkContent;

@end

@interface SKViewController : UIViewController<ICETutorialControllerDelegate, UMFeedbackDataDelegate>
{
    UMFeedback *_umFeedback;
}
@property (strong, nonatomic) ICETutorialController *viewController;
@property (nonatomic, assign) id<sendMsgToWeChatViewDelegate, NSObject> delegate;
- (void)operationMore:(id)sender;
@end
