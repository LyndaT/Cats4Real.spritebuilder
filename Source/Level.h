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
    int totalCake;
//    NSString *nextLevel;
    CCNode *_door;
}

@property (nonatomic, assign) double catX;
@property (nonatomic, assign) double catY;
@property (nonatomic, assign) double doorX;
@property (nonatomic, assign) double doorY;
@property (nonatomic, assign) double doorAngle;
@property (nonatomic, assign) int totalCake;
@property (nonatomic, assign) int nextLevel;
//@property(assign) NSString *nextLevel;

-(void)putDoorBack;

@end
