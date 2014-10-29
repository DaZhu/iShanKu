//
//  SKDetailViewController.h
//  ShanKu
//
//  Created by LiangChao on 14-8-22.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKHomeViewCell.h"

@interface SKDetailViewController : UIViewController
{
//    UIImageView *image;
}

//@property (retain, nonatomic) IBOutlet UIImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UIButton *gameIcon;
@property (retain, nonatomic) IBOutlet UILabel *gameName;
@property (retain, nonatomic) IBOutlet UILabel *gameRecomend;
@property (retain, nonatomic) IBOutlet UILabel *gameDesc;
@property (retain, nonatomic) IBOutlet UIButton *startGame;
@property (strong, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *randomScroll;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *image;
@property (nonatomic, assign) SKHomeViewCell *currentCell;
@property (nonatomic, assign) NSArray *gameInfo;
@property (nonatomic, weak) NSDictionary *currentGameInfo;
@end
