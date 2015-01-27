//
//  CakeDial.h
//  Cats4Real
//
//  Created by Lili Sun on 1/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface CakeDial : CCNode

-(void)setNumSlices:(int)slices;
-(void)increaseCake;
-(void)resetDial;
-(void)pulse;

@end
