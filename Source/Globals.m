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

+ (id)globalManager {
    static Globals *sharedGlobals = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGlobals = [[self alloc] init];
    });
    return sharedGlobals;
}

-(BOOL) test
{
    return true;
}


//set Level, assumes just giving an int will let us determine the level name
- (void)setLevel:(int)levelNumber {
    Globals *manager = [Globals globalManager];
    manager.currentLevelName = [NSString stringWithFormat:@"Levels/Level%d", levelNumber];
    manager.currentLevelNumber = levelNumber;
}

- (id)init {
    if (self = [super init]) {
        currentLevelName = @"Levels/Level2";
        currentLevelNumber = 2;
    }
    return self;
}


@end
