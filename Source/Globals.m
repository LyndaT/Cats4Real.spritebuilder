//
//  Globals.m
//  Cats4Real
//
//  A place for global values
//  Trying to use singleton pattern, hope it works…
//
//  Created by Jenny Lin on 1/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Globals.h"

@implementation Globals
{
    NSInteger clingStar[20];
}

@synthesize currentLevelName;
@synthesize currentLevelNumber;
@synthesize isCurrentCutscene;
@synthesize musicVolume;
@synthesize SFXVolume;
@synthesize isMusicOn;
@synthesize isSFXOn;
@synthesize audio;

- (id)init {
    if (self = [super init]) {
        currentLevelName = @"Levels/Level1";
        currentLevelNumber = 1;
        musicVolume = 1.0;
        SFXVolume = 1.0;
        isMusicOn=YES;
        isSFXOn=YES;
        audio = [OALSimpleAudio sharedInstance];
    }
    CCLOG(@"vol from globals %f", musicVolume);
    return self;
}

#pragma mark Singleton Methods

//call this inside the init for any class that is touching globals
+ (id)globalManager {
    static Globals *sharedGlobals = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGlobals = [[self alloc] init];
    });
    return sharedGlobals;
}

//set Level, assumes just giving an int will let us determine the level name
- (void)setLevel:(int)levelNumber{
    isCurrentCutscene=NO;
    currentLevelName = [NSString stringWithFormat:@"Levels/Level%d", levelNumber];
    currentLevelNumber = levelNumber;
    CCLOG(@"level set to %d",currentLevelNumber);
}

- (void)setCutscene:(int)cutNumber{
    isCurrentCutscene=YES;
    currentLevelName = [NSString stringWithFormat:@"Anim/Cutscene%d", cutNumber];
    currentLevelNumber = cutNumber;
}

- (void)setMusicVolume:(float)volume{
    musicVolume = volume;
    [audio setBgVolume:musicVolume];
}

- (void)setSFXVolume:(float)volume{
    SFXVolume = volume;
    [audio setEffectsVolume:SFXVolume];
}

/* sets the value of the clingstar of the current level
 * 
 * 0 = cling used
 * 1 = no cling used
 */
- (void)setClingStars: (int)currLevel : (int)noCling
{
    if (clingStar[currLevel]!=1){
        if (noCling == 1)
        {
            clingStar[currLevel]=(NSInteger)noCling;//[NSNumber numberWithInteger:1];
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:[NSString stringWithFormat:@"clingLevel%i",currLevel]];
            CCLOG(@"current level %i set cling %li", currLevel, (long)clingStar[currLevel]);
        }
        else
        {
            clingStar[currLevel]=(NSInteger)0;
        }
    }
}

- (int)getClingStar: (int)currLevel
{
    return (int)clingStar[currLevel];
}

@end
