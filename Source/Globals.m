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

@synthesize currentLevelName;
@synthesize currentLevelNumber;

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
- (void)setLevel:(int)levelNumber {
    currentLevelName = [NSString stringWithFormat:@"Levels/Level%d", levelNumber];
    currentLevelNumber = levelNumber;
}

- (id)init {
    if (self = [super init]) {
        currentLevelName = @"Levels/Level2";
        currentLevelNumber = 2;
    }
    return self;
}


@end
