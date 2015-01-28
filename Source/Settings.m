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
    CCButton *_musicButton;
    CCButton *_SFXButton;
}

- (id)init{
    self = [super init];
    
    if (self) {
        _globals = [Globals globalManager];
    }
    
    return self;
}

- (void)didLoadFromCCB {
    if (_globals.isMusicOn)
    {
        [_musicButton setTitle:@"ON"];
    }else
    {
        [_musicButton setTitle:@"OFF"];
    }
    
    if (_globals.isSFXOn)
    {
        [_SFXButton setTitle:@"ON"];
    }else
    {
        [_SFXButton setTitle:@"OFF"];
    }
    
    // play background sound
    [_globals.audio playBg:@"assets/music/CutsceneMusic.mp3" loop:TRUE];
}


-(void)returnMenu
{
    [_globals.audio playEffect:@"assets/music/button.mp3"];
    CCLOG(@"returnMenu");
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)resetProgress
{
    [_globals.audio playEffect:@"assets/music/button.mp3"];
    [_globals setLevel:1];
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"highestlevel"];
    int temp = [[NSUserDefaults standardUserDefaults] integerForKey:@"highestlevel"];
    CCLOG(@"reset progress to lvl%i, global %i",temp, _globals.currentLevelNumber);
}

-(void)musicToggle
{
    [_globals.audio playEffect:@"assets/music/button.mp3"];
    _globals.isMusicOn = !_globals.isMusicOn;
    if (_globals.isMusicOn)
    {
        [_globals setMusicVolume:1];
        [_musicButton setTitle:@"ON"];
    }else
    {
        [_globals setMusicVolume:0];
        [_musicButton setTitle:@"OFF"];
    }
}

-(void)sfxToggle
{
    [_globals.audio playEffect:@"assets/music/button.mp3"];
    _globals.isSFXOn = !_globals.isSFXOn;
    if (_globals.isSFXOn)
    {
        [_globals setSFXVolume:1];
        [_SFXButton setTitle:@"ON"];
    }else
    {
        [_globals setSFXVolume:0];
        [_SFXButton setTitle:@"OFF"];
    }
}

-(void)credits
{
    CCLOG(@"to credits");
    [_globals.audio playEffect:@"assets/music/button.mp3"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Credits"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
