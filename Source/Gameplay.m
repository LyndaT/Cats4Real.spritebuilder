//
//  Gameplay.m
//  Cats4Real
//
//  Created by Lili Sun on 1/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import <CoreMotion/CoreMotion.h>
#import "Cat.h"
#import "Level.h"

CGFloat gravitystrength = 5000;
CGFloat direction = 0;
CGFloat speed = 50;
BOOL hold = NO;
BOOL onground = NO;
BOOL atDoor = NO;

@implementation Gameplay
{
    //taken from Spritebuilder
    CCNode *_levelNode;
    Cat *_cat;
    CCPhysicsNode *_physNode;
    Level *_currentLevel; //<--this doesnt' actually work. im gonna punch it o:<
    
    CCScene *gameOverScreen;
    CCScene *currentLevel;
    CMMotionManager *_motionManager; //instance of the motion manager, please ONLY create one
    
    
}

- (id)init
{
    if (self = [super init])
    {
        // activate touches on this scene
        self.userInteractionEnabled = TRUE;
        _motionManager = [[CMMotionManager alloc] init];//initiate the MotionManager
    }
    return self;
}

- (void)didLoadFromCCB {
    CCLOG(@"Loading Level1");
    gameOverScreen = [CCBReader load:@"GameOver"];
    currentLevel = [CCBReader load:@"Levels/Level1"];
    [_levelNode addChild:currentLevel];
    CCLOG(@"Finished loading level");
    
//    _cat.position = ccp(*[_currentLevel getCatX], *[_currentLevel getCatY]);
    
    _physNode.collisionDelegate = self;
    _cat.physicsBody.collisionType = @"cat";
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair cat:(CCNode *)Cat cake:(CCNode *)Cake
{
    if (sqrt(pow(_cat.physicsBody.velocity.x,2) + pow(_cat.physicsBody.velocity.y,2)) > 100 )
    {
        //Replace following line of code with what happens when the cat squishes the cake
        CCLOG(@"smoosh!");
        hold=YES; //to stop player movement
        [_levelNode addChild:gameOverScreen];
    }
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair cat:(CCNode *)Cat door:(CCNode *)Door
{
    CCLOG(@"hit door");
    atDoor = YES;
    return TRUE;
}

-(BOOL)ccPhysicsCollisionSeparate:(CCPhysicsCollisionPair *)pair cat:(CCNode *)Cat door:(CCNode *)Door
{
    CCLOG(@"leaves door");
    atDoor = NO;
    return TRUE;
}


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair cat:(CCNode *)Cat ground:(CCNode *)Ground
{
    onground = YES;
    return TRUE;
}

-(BOOL)ccPhysicsCollisionSeparate:(CCPhysicsCollisionPair *)pair cat:(CCNode *)Cat ground:(CCNode *)Ground
{
    onground = NO;
    return TRUE;
}


- (void)update:(CCTime)delta
{
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;

    if(!hold)
    {
        [self changeGravity:acceleration.x :acceleration.y];
        [_cat moveSelf:delta :direction :speed :hold];
    }
}

-(void)retry
{
    hold=NO;
    [_levelNode removeChild:gameOverScreen];
}


/*
 * Rotates and moves the cat based on the current direction of the screen
 *
 */
- (void)moveCat:(CCTime)delta
{
    if (direction == 0)
    {
        _cat.position = ccp( _cat.position.x+speed*delta, _cat.position.y );
        _cat.rotation = 0;
    }
    if (direction == 1)
    {
        _cat.position = ccp( _cat.position.x, _cat.position.y+speed*delta );
        _cat.rotation = -90;
    }
    if (direction == 2)
    {
        _cat.position = ccp( _cat.position.x+speed*-1*delta, _cat.position.y );
        _cat.rotation = 180;
    }
    if (direction == 3)
    {
        _cat.position = ccp( _cat.position.x, _cat.position.y+speed*-1*delta );
        _cat.rotation = 90;
    }
}

/*
 * changeGravity takes in accelerometer values and changes gravity accordingly
 *
 * xaccel: the accelerometer.x value
 * yaccel: the accelerometer.y value
 *
 * gravityleft: -0.5 < accel.x < 0.5 && accel.y < -0.5
 * gravitydown: 0.5 < accel.x && -0.5 < accel.y < 0.5
 * gravityright: -0.5 < accel.x < 0.5 && 0.5 < accel.y
 * gravityup: accel.x < -0.5 && -0.5 < accel.y <0.5
 */

-(void)changeGravity:(CGFloat)xaccel :(CGFloat)yaccel
{
    
    if (xaccel < 0.5 && xaccel > -0.5 && yaccel < -0.5)
    {
        [self changeGravityLeft];
    }
    if (yaccel < 0.5 && yaccel > -0.5 && xaccel >0.5)
    {
        [self changeGravityDown];
    }
    if (xaccel < 0.5 && xaccel > -0.5 && yaccel> 0.5)
    {
        [self changeGravityRight];
    }
    if (yaccel < 0.5 && yaccel > -0.5 && xaccel<-0.5)
    {
        [self changeGravityUp];
    }
    
}

/*
 * the changeGravity[direction] methods change the gravity of the physicsNode
 * to the direction of the orientation of the screen
 */
- (void)changeGravityLeft
{
    direction = 3;
    _physNode.gravity= ccp(-1*gravitystrength,0);
    //CCLOG(@"Gravity changed left");
    
}
- (void)changeGravityRight
{
    direction = 1;
    _physNode.gravity= ccp(1*gravitystrength,0);
    //CCLOG(@"Gravity changed right");
    
}
- (void)changeGravityUp
{
    direction = 2;
    _physNode.gravity= ccp(0,1*gravitystrength);
    //CCLOG(@"Gravity changed up");
    
}
- (void)changeGravityDown
{
    direction = 0;
    _physNode.gravity= ccp(0,-1*gravitystrength);
    //CCLOG(@"Gravity changed down");
    
}

-(void)toNextLevel
{
    [_levelNode removeChild:currentLevel];
    
    
//    currentLevel = [CCBReader load:[_currentLevel getNextLevel]]; //NOT CURRENTLY WORKING
    currentLevel = [CCBReader load:@"Level2"];
    [_levelNode addChild:currentLevel];
    
//    _cat.position = ccp(*[_currentLevel getCatX], *[_currentLevel getCatY]);
}

/*
 * Handling tap/hold/clench using touches
 */
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if (onground)
    {
        hold = YES;
    }
    if (atDoor)
    {
        [self toNextLevel];
    }
    //CCLOG(@"Touches began");
    
}
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    hold = NO;
    //CCLOG(@"Touches ended");
}
- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    hold = NO;
    //CCLOG(@"Touches ended");
}



/*
 * onEnter and onExit call to start and stop the accelerometer on the phone
 * Accelerometer updates whoo!
 */
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
