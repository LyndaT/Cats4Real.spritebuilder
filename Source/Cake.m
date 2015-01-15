//
//  Cake.m
//  Cats4Real
//
//  Created by Lynda Tang on 1/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Cake.h"

@implementation Cake

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"cake";
    self.physicsBody.sensor = TRUE;
}

@end
