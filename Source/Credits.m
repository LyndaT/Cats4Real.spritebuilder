//
//  Credits.m
//  Cats4Real
//
//  Created by Lili Sun on 1/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Credits.h"

@implementation Credits

-(void)back
{
    CCLOG(@"back to settings");
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Settings"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
