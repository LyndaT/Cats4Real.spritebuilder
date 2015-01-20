//
//  LevelSelect.m
//  Cats4Real
//
//  Created by Lynda Tang on 1/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LevelSelect.h"

@implementation LevelSelect

- (void)returnMenu {
    CCLOG(@"returnMenu");
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
