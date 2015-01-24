//
//  GameOver.m
//  Cats4Real
//
//  Created by Lili Sun on 1/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameOver.h"

@implementation GameOver{
    CCAnimationManager* animationManager;
}

- (void)didLoadFromCCB
{
    animationManager = self.animationManager;
}

- (void)cake
{
    [animationManager runAnimationsForSequenceNamed:@"cake"];
}

- (void)water
{
    [animationManager runAnimationsForSequenceNamed:@"water"];
}

@end
