//
//  Cake.m
//  Cats4Real
//
//  Created by Lynda Tang on 1/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Cake.h"

@implementation Cake
{
    CCAnimationManager* animationManager;
}

-(id)init{
    self = [super init];
    
    if(self){
        CCLOG(@"Cake created");
    }
    
    return self;
}

- (void)didLoadFromCCB {
    animationManager = self.animationManager;
    self.physicsBody.collisionType = @"cake";
    self.physicsBody.sensor = TRUE;
}

-(void)collected
{
    [animationManager runAnimationsForSequenceNamed:@"collected"];
}

-(void)gone
{
    CCLOG(@"cake gone");
    self.visible=false;
}

-(void)pulse
{
    [animationManager runAnimationsForSequenceNamed:@"pulse"];
}

@end
