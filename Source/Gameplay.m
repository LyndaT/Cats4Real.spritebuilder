//
//  Gameplay.m
//  Cats4Real
//
//  Created by Lili Sun on 1/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay
{
    CCNode *_levelNode;
}

- (void)didLoadFromCCB {
    CCScene *level = [CCBReader load:@"Level1"];
    [_levelNode addChild:level];
}

@end
