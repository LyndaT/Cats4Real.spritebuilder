//
//  Level.m
//  Cats4Real
//
//  Created by Lili Sun on 1/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Level.h"

@implementation Level{
    double *catX;
    double *catY;
    NSString *nextLevel;
}

-(double*)getCatX
{
    return catX;
}

-(double*)getCatY
{
    return catY;
}

-(NSString*)getNextLevel
{
    CCLOG(nextLevel);
    return nextLevel;
}

@end
