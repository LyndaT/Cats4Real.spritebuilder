//
//  Level.m
//  Cats4Real
//
//  Created by Lili Sun on 1/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Level.h"
#import "CCNode.h"
#import "Cake.h"

@implementation Level{
    CCNode *_cakes;
}

@synthesize catX;
@synthesize catY;
@synthesize doorX;
@synthesize doorY;
@synthesize doorAngle;
@synthesize defaultOrientation;
@synthesize totalCake;
@synthesize nextLevel;
@synthesize isCutsceneNext;


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

-(void)pulseCakes
{
    for (CCNode *cake in _cakes.children)
    {
        if (cake.visible)
        {
            [(Cake *)cake pulse];
        }
    }
}
@end
