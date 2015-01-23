//
//  Ground.m
//  Cats4Real
//
//  Created by Lynda Tang on 1/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Ground.h"

@implementation Ground{
    
}

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"ground";
//    self.physicsBody.sensor = TRUE;
}

@end
