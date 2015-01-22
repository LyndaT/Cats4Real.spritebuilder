//
//  Settings.m
//  Cats4Real
//
//  Created by Lili Sun on 1/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Settings.h"

@implementation Settings

-(void)returnMenu
{
    CCLOG(@"returnMenu");
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)resetProgress
{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"highestlevel"];
    int temp = [[NSUserDefaults standardUserDefaults] integerForKey:@"highestlevel"];
    CCLOG(@"reset progress to lvl%i",temp);
}

@end
