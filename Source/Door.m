//
//  Door.m
//  Cats4Real
//
//  Created by Lili Sun on 1/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Door.h"

@implementation Door{
    
}

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"door";
    self.physicsBody.sensor = TRUE;
}

@end
