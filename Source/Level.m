//
//  Level.m
//  Cats4Real
//
//  Created by Lili Sun on 1/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Level.h"
#import "CCNode.h"

@implementation Level{
//    CCNode *_door;
}

@synthesize catX;
@synthesize catY;
@synthesize totalCake;
@synthesize nextLevel;

- (id)init
{
    self = [super init];
    if (self) {
        _door.zOrder=-10;
        CCLOG(@"Level created");
        _door.zOrder=-10;
    }
    return self;
}

-(void)didLoadFromCCB
{
    _door.zOrder=-10;
}
@end
