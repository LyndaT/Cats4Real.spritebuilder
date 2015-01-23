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
}

@property (nonatomic, retain) NSString *currentLevelName;
@property (nonatomic, assign) int currentLevelNumber;
@property (nonatomic, assign) BOOL isCurrentCutscene;

+ (id)globalManager;
- (void)setLevel:(int)levelNumber;
- (void)setCutscene:(int)cutNumber;

@end