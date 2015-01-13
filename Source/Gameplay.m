//
//  Gameplay.m
//  Cats4Real
//
//  Created by Lili Sun on 1/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import <CoreMotion/CoreMotion.h>

CGFloat gravitystrength = 5000;

@implementation Gameplay
{
    CCNode *_levelNode;
    CCPhysicsNode *_physNode;
    CMMotionManager *_motionManager; //instance of the motion manager, please ONLY create one

}

- (id)init
{
    if (self = [super init])
    {
        // activate touches on this scene probably won't need it
        self.userInteractionEnabled = TRUE;
        _motionManager = [[CMMotionManager alloc] init];//initiate the MotionManager
    }
    return self;
}

- (void)didLoadFromCCB {
    CCScene *level = [CCBReader load:@"Level1"];
    [_levelNode addChild:level];
}


//NSLog(@" double %f",acceleration.y);
//gravityleft -0.5 < accel.x < 0.5
//accel.y < -0.5
//gravitydown 0.5 < accel.x
//-0.5 < accel.y < 0.5
//gravityright -0.5 < accel.x < 0.5
//0.5 < accel.y
//gravityup accel.x < -0.5
//-0.5 < accel.y <0.5
- (void)update:(CCTime)delta
{

    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
  
    if (acceleration.x < 0.5 && acceleration.x > -0.5 && acceleration.y < -0.5)
    {
        [self changeGravityLeft];
    }
    if (acceleration.y < 0.5 && acceleration.y > -0.5 && acceleration.x >0.5)
    {
        [self changeGravityDown];
    }
    if (acceleration.x < 0.5 && acceleration.x > -0.5 && acceleration.y > 0.5)
    {
        [self changeGravityRight];
    }
    if (acceleration.y < 0.5 && acceleration.y > -0.5 && acceleration.x <-0.5)
    {
        [self changeGravityUp];
    }
    
}

//Changes the Gravity direction in the game
- (void)changeGravityLeft
{
    _physNode.gravity= ccp(-1*gravitystrength,0);
    CCLOG(@"Gravity changed");
    
}
- (void)changeGravityRight
{
    _physNode.gravity= ccp(1*gravitystrength,0);
    CCLOG(@"Gravity changed");
    
}
- (void)changeGravityUp
{
    _physNode.gravity= ccp(0,1*gravitystrength);
    CCLOG(@"Gravity changed");
    
}
- (void)changeGravityDown
{
    _physNode.gravity= ccp(0,-1*gravitystrength);
    CCLOG(@"Gravity changed");
    
}

//onEnter and onExit call the startAccelerometerUpdates

- (void)onEnter
{
    [super onEnter];
    
    [_motionManager startAccelerometerUpdates];
}

- (void)onExit
{
    [super onExit];
    
    [_motionManager stopAccelerometerUpdates];
}

@end
