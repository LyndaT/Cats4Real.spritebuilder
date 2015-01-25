
//
//  Cat.m
//  Cats4Real
//
//  Created by Lynda Tang on 1/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Cat.h"

@implementation Cat
{
    CCAnimationManager* animationManager;
}

- (void)didLoadFromCCB
{
     animationManager = self.animationManager;
}

-(void)stand
{
    [animationManager runAnimationsForSequenceNamed:@"stand"];
}

-(void)blink
{
    [animationManager runAnimationsForSequenceNamed:@"blink"];
}

-(void)walk
{
    [animationManager runAnimationsForSequenceNamed:@"walk"];
}

-(void)cling
{
    [animationManager runAnimationsForSequenceNamed:@"cling"];
}

-(void)openDoor
{
    [animationManager runAnimationsForSequenceNamed:@"doorOpen"];
}

/*
 * Moves the cat
 *
 * delta: CCTime
 * direction: current direction to orient the cat the right way
 * speed: speed of the cat
 * hold: whether the cat is holding
 */
- (void)moveSelf:(CCTime)delta :(int)direction :(int)speed :(BOOL)hold
{
    if (hold)
    {
        
    }
    else if (direction == 0)
    {
        self.position = ccp( self.position.x+speed*delta, self.position.y );
        self.rotation = 0;
    }
    else if (direction == 1)
    {
        self.position = ccp( self.position.x, self.position.y+speed*delta );
        self.rotation = -90;
    }
    else if (direction == 2)
    {
        self.position = ccp( self.position.x+speed*-1*delta, self.position.y );
        self.rotation = 180;
    }
    else if (direction == 3)
    {
        self.position = ccp( self.position.x, self.position.y+speed*-1*delta );
        self.rotation = 90;
    }
    
}


@end
