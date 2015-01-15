//
//  Level.h
//  Cats4Real
//
//  Created by Lili Sun on 1/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCNode.h"

@interface Level : CCNode{
    double catX;
    double catY;
//    NSString *nextLevel;
}

@property (nonatomic, assign) double catX;
@property (nonatomic, assign) double catY;
@property (nonatomic, assign) NSString *nextLevel;
//@property(assign) NSString *nextLevel;

@end
