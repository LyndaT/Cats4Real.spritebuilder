//
//  Door.m
//  Cats4Real
//
//  Created by Lili Sun on 1/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Door.h"

@implementation Door{
    CCAnimationManager* animationManager;}

- (void)didLoadFromCCB
{
    animationManager = self.animationManager;
    self.physicsBody.collisionType = @"door";
    self.physicsBody.sensor = TRUE;
}

- (void)open
{
    [animationManager runAnimationsForSequenceNamed:@"open"];
}

- (void)close
{
    [animationManager runAnimationsForSequenceNamed:@"closed"];
}

- (void)fade
{
    [animationManager runAnimationsForSequenceNamed:@"fade"];
}

- (void)hover
{
    [animationManager runAnimationsForSequenceNamed:@"hover"];
}

@end
