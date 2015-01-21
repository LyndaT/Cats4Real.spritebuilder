//
//  LevelSelectCake.m
//  Cats4Real
//
//  Created by Jenny Lin on 1/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LevelSelectCake.h"

//The special cake button that takes us to the appropriate level
//Assumes levels follow the naming convention of "Level num"
@implementation LevelSelectCake

- (id)init:(int)level {
    self = [super init];
    
    if (self) {
        self.name = [NSString stringWithFormat:@"Level %d", level];
    }
    
    return self;
}

- (void)play {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
