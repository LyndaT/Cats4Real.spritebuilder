//
//  Gallery.m
//  Cats4Real
//
//  Created by Lynda Tang on 1/29/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gallery.h"
#import "Globals.h"

@implementation Gallery{
    Globals *_globals;
}

- (void)didLoadFromCCB {
    
    // play background sound
    [_globals.audio playBg:@"assets/music/CutsceneMusic.mp3" loop:TRUE];
    
}

-(void)playCutsceneOne {
    [_globals.audio playEffect:@"assets/music/button.mp3"];
    CCScene *cutScene = [CCBReader loadAsScene:@"assets/Anim/Cutscene1"];
    [[CCDirector sharedDirector] replaceScene:cutScene];
    
}

- (void)returnMenu {
    [_globals.audio playEffect:@"assets/music/button.mp3"];
    CCLOG(@"returnMenu");
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
