//
//  Level.h
//  Cats4Real
//
//  Created by Lili Sun on 1/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCNode.h"

@interface Level : CCNode

-(NSString*)getNextLevel;

-(double*)getCatX;

-(double*)getCatY;

@end
