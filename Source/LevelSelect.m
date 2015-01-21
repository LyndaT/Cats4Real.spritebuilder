//
//  LevelSelect.m
//  Cats4Real
//
//  Created by Jenny Lin on 1/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LevelSelect.h"
#import "LevelSelectCake.h"


@implementation LevelSelect {
    //NSMutableArray *_levelArray;
    float _cakeWidth;
    int _totalLevels;
}

//Setting up the level select screen with the right amount of cake
- (void)setTable {
    //Grabbing highest lvl cleared so far from NSUserDefaults
    NSUInteger highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"highestlevel"];
    for (int i = 1; i < highestLevel; i++) {
        //smack down plate with cake
    }
    //smack down plate without cake
    
    for (int j = highestLevel+1; j < _totalLevels; j++) {
        //smack down empty placemat
    }
}

- (void)returnMenu {
    CCLOG(@"returnMenu");
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
