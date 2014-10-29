//
//  SKHomeViewCell.h
//  ShanKu
//
//  Created by LiangChao on 14-8-17.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UITableViewCellDelegate <NSObject>

@optional
- (void)didTableViewCellClickedButton: (UIButton *)button;

@end

@interface SKHomeViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *headerImageView;
@property (retain, nonatomic) IBOutlet UIButton *cellButton;
@property (strong, nonatomic) UINavigationController *controller;
@property (strong, nonatomic) IBOutlet UILabel *gameNameLabel;
@property (strong, nonatomic) NSDictionary *cellInfo;


@property (nonatomic, assign) id <UITableViewCellDelegate> delegate;

@end
