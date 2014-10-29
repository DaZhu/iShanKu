//
//  SKHomeViewCell.m
//  ShanKu
//
//  Created by LiangChao on 14-8-17.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import "SKHomeViewCell.h"

@implementation SKHomeViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}
- (IBAction)startGame:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(didTableViewCellClickedButton:)]) {
        [_delegate didTableViewCellClickedButton:sender];
    }
    
}


- (void)awakeFromNib
{
    // Initialization code
    self.headerImageView.layer.cornerRadius = 5;
    self.headerImageView.layer.masksToBounds = YES;
    
    self.cellButton.layer.cornerRadius = 3;
    self.cellButton.layer.masksToBounds = YES;
    [self.cellButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
