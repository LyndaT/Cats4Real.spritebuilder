//
//  LevelSelectCake.m
//  Cats4Real
//
//  Created by Jenny Lin on 1/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LevelSelectCake.h"
#import "Globals.h"

//The special cake button that takes us to the appropriate level
//Assumes levels follow the naming convention of "Level num"
@implementation LevelSelectCake {
    Globals *_globals;
    NSString *_name;
    int _level;
}

- (id)init{
    self = [super init];
    
    if (self) {
        _name = [NSString stringWithFormat:@"Level%d", 1];
        _globals = [Globals globalManager];
    }
    
    return self;
}

-(void)setLevel:(int)lvl
{
    _level=lvl;
    _name = [NSString stringWithFormat:@"Level%d", lvl];
}

- (void)play {
    CCLOG(_name);
    [_globals.audio playEffect:@"assets/music/ding.mp3"];
    [_globals setLevel:_level];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
