//
//  Credits.m
//  Cats4Real
//
//  Created by Lili Sun on 1/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Credits.h"
#import "Globals.h"

@implementation Credits{
    Globals *_globals;
}

- (id)init{
    self = [super init];
    
    if (self) {
        _globals = [Globals globalManager];
    }
    
    return self;
}

- (void)didLoadFromCCB
{
    [_globals.audio playBg:@"assets/music/CreditsMusic.mp3" loop:TRUE];
}

-(void)back
{
    [_globals.audio playEffect:@"assets/music/button.mp3"];
    CCLOG(@"back to settings");
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Settings"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
