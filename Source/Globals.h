//
//  Globals.h
//  Cats4Real
//
//  Created by Jenny Lin on 1/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Globals : NSObject {
    NSString *currentLevelName;
    int currentLevelNumber;
    BOOL isCurrentCutscene;
    float musicVolume;
}

@property (nonatomic, retain) NSString *currentLevelName;
@property (nonatomic, assign) int currentLevelNumber;
@property (nonatomic, assign) BOOL isCurrentCutscene;
@property (nonatomic, assign) float musicVolume;
@property (nonatomic, assign) float SFXVolume;
@property (nonatomic, assign) BOOL isMusicOn;
@property (nonatomic, assign) BOOL isSFXOn;
@property (nonatomic, assign) OALSimpleAudio *audio;
@property (nonatomic, assign) int totalLevels;


+ (id)globalManager;
- (void)setLevel:(int)levelNumber;
- (void)setCutscene:(int)cutNumber;
- (void)setMusicVolume:(float)volume;
- (void)setSFXVolume:(float)volume;
- (void)setClingStars: (int)currLevel: (int)noCling;
- (int)getClingStar: (int)currLevel;

@end
