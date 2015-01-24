//
//  SingleCutscene.h
//  Cats4Real
//
//  Created by Lili Sun on 1/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface SingleCutscene : CCNode

@property (nonatomic, assign) int nextLevel;
@property (nonatomic, assign) BOOL isCutsceneNext;
@property (nonatomic, assign) int sceneRotation;

@end
