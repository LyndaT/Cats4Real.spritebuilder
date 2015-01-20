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
}

@synthesize catX;
@synthesize catY;
@synthesize doorX;
@synthesize doorY;
@synthesize doorAngle;
@synthesize totalCake;
@synthesize nextLevel;


- (id)init
{
    self = [super init];
    if (self) {
        CCLOG(@"Level created");
    }
    return self;
}

-(void)didLoadFromCCB
{
}
@end
