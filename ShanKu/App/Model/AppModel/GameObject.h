//
//  GameObject.h
//  ShanKu
//
//  Created by LiangChao on 14-8-27.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameObject : NSObject

@property (copy, nonatomic) NSArray *gameInfo;

- (id)initWithParameters: (NSArray *) info;
@end
