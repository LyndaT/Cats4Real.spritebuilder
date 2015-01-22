//
//  Settings.m
//  Cats4Real
//
//  Created by Lili Sun on 1/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Settings.h"
#import "Globals.h"

@implementation Settings
{
    Globals *_globals;
}

- (void)didLoadFromCCB {
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio playBg:@"assets/music/CutsceneMusic.mp3" loop:TRUE];
}


-(void)returnMenu
{
    CCLOG(@"returnMenu");
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)resetProgress
{
    [_globals setLevel:1];
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"highestlevel"];
    int temp = [[NSUserDefaults standardUserDefaults] integerForKey:@"highestlevel"];
    CCLOG(@"reset progress to lvl%i, global %i",temp, _globals.currentLevelNumber);
}

- (id)init{
    self = [super init];
    
    if (self) {
        _globals = [Globals globalManager];
    }
    
    return self;
}

@end
