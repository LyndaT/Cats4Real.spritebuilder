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

- (void)didLoadFromCCB {
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio playBg:@"assets/music/CutsceneMusic.mp3" loop:TRUE];
    [[OALSimpleAudio sharedInstance] setBgVolume:_globals.musicVolume];
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

-(void)changeMusic:(CCSlider *)musicVol
{
    [_globals setMusicVolume:musicVol.sliderValue];
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playBg:@"assets/music/CutsceneMusic.mp3" loop:TRUE];
    [[OALSimpleAudio sharedInstance] setBgVolume:_globals.musicVolume];
    CCLOG(@"%f", musicVol.sliderValue);
}

-(void)musicToggle
{
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
    [[OALSimpleAudio sharedInstance] setBgVolume:_globals.musicVolume];
}

-(void)sfxToggle
{
    CCLOG(@"sfx tggle");
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
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Credits"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
