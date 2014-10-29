//
//  GameObject.m
//  ShanKu
//
//  Created by LiangChao on 14-8-27.
//  Copyright (c) 2014年 LiangChao. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject
@synthesize gameInfo;

- (id)initWithParameters:(NSArray *)info
{
    GameObject *g = [[GameObject alloc] init];
    g.gameInfo = info;
    return g;
}
@end
