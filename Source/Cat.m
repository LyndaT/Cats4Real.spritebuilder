
//
//  Cat.m
//  Cats4Real
//
//  Created by Lynda Tang on 1/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Cat.h"

@implementation Cat

- (void)moveSelf:(CCTime)delta :(int)direction :(int)speed
{
    if (direction == 0)
    {
        self.position = ccp( self.position.x+speed*delta, self.position.y );
        self.rotation = 0;
    }
    if (direction == 1)
    {
        self.position = ccp( self.position.x, self.position.y+speed*delta );
        self.rotation = -90;
    }
    if (direction == 2)
    {
        self.position = ccp( self.position.x+speed*-1*delta, self.position.y );
        self.rotation = 180;
    }
    if (direction == 3)
    {
        self.position = ccp( self.position.x, self.position.y+speed*-1*delta );
        self.rotation = 90;
    }
    CCLOG(@"cat moved");
    
}


@end
