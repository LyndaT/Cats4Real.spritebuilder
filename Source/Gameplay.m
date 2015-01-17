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
#import "Cake.h"

CGFloat gravitystrength = 3000;
CGFloat direction = 0;
CGFloat speed = 50;
BOOL hold = NO;
BOOL onground = NO;
BOOL atDoor = NO;
BOOL isDead = NO;
BOOL hasCake = NO;
int numCake = 0;

@implementation Gameplay
{
    //taken from Spritebuilder
    CCNode *_levelNode;
    Cat *_cat;
    CCPhysicsNode *_physNode;
    CCLabelTTF *_cakeScore;
    
    
    Level *_currentLevel;
    NSString *currentLevelName;
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
    
    gameOverScreen = [CCBReader load:@"GameOver"];
    
    currentLevelName=@"Levels/Level2";
    currentLevel = [CCBReader load:currentLevelName];
    _currentLevel = (Level *)currentLevel;
    
    [_levelNode addChild:currentLevel];
    CCLOG(@"Finished loading level");
    
    [self resetLevel];
    
    _physNode.collisionDelegate = self;
    _cat.physicsBody.collisionType = @"cat";
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


/**----------------Collisions Begin Here----------------
 */

/*
 * Colliding with Cake
 * Checks to see if the cat crashes into the cake
 */
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair cat:(CCNode *)Cat cake:(CCNode *)Cake
{
    //only interact w/cake if it's visible
    if (Cake.visible==true){
        if ([self isCatNyooming])
        {
            //if you're nyooming, you smash it and DIE
            CCLOG(@"smoosh!");
            [self died];
        }
        else
        {
            //if you're not nyooming, you collect the cake
            numCake++;
            [self updateCakeScore];
            Cake.visible=false;
            
            if (numCake >= _currentLevel.totalCake)
            {
                //show the door unlocked or smth
            }
        }
    }
    return TRUE;
}

/*
 * Colliding with Water
 * Checks to see if the cat crashes into the cake
 */
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair cat:(CCNode *)Cat water:(CCNode *)Water
{
    [self died];
    return TRUE;
}


/*
 * Colliding with door
 * Checks to see if the cat is at the door
 */
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


/*
 * Colliding with ground
 * Checks to see if the cat is on the ground and can cling onto this
 */
//-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair cat:(CCNode *)Cat ground:(CCNode *)Ground
//{
//    onground = YES;
//    return TRUE;
//}

-(BOOL)ccPhysicsCollisionSeparate:(CCPhysicsCollisionPair *)pair cat:(CCNode *)Cat ground:(CCNode *)Ground
{
    onground = NO;
    return TRUE;
}

-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair cat:(CCNode *)Cat ground:(CCNode *)Ground {
    //CCLOG(@"catonground");
    onground = YES;
    return YES;
}

//-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair cat:(CCNode *)Cat ground:(CCNode *)Ground {
//    CCLOG(@"off ground");
//    onground = NO;
//}



-(void)died
{
    isDead=YES;
    //to pause scene
    [[CCDirector sharedDirector] pause];
    
    [_levelNode addChild:gameOverScreen];
}

-(void)retry
{
    [[CCDirector sharedDirector] resume];
    
    [self resetLevel];
    
    if (isDead)
    {
        isDead = NO;
        [_levelNode removeChild:gameOverScreen];
    }
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
    numCake=0;
    [_levelNode removeChild:currentLevel];
    
    currentLevelName = [@"Levels/" stringByAppendingString:_currentLevel.nextLevel];
    currentLevel = [CCBReader load:currentLevelName];
    _currentLevel = (Level *)currentLevel;
    
    NSLog(@"next level %@", _currentLevel.nextLevel);
    
    [_levelNode addChild:currentLevel];
    
    [self resetLevel];
}

-(void)resetLevel
{
    [_levelNode removeChild:currentLevel];
    currentLevel = [CCBReader load:currentLevelName];
    [_levelNode addChild:currentLevel];
    numCake=0;
    [self updateCakeScore];
    _cat.position = ccp(_currentLevel.catX, _currentLevel.catY);}

-(void)updateCakeScore
{
    _cakeScore.string = [NSString stringWithFormat:@"%i/%i cake", numCake, _currentLevel.totalCake];
}

-(BOOL)isCatNyooming
{
    return (sqrt(pow(_cat.physicsBody.velocity.x,2) + pow(_cat.physicsBody.velocity.y,2)) > 100);
}


/*
 * Handling tap/hold/clench using touches
 */
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if (onground)
    {
        hold = YES;
        [_cat cling];
    }
    if (atDoor && (numCake>=_currentLevel.totalCake) && ![self isCatNyooming])
    {
        [self toNextLevel];
    }
    //CCLOG(@"Touches began");
    
}
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    hold = NO;
    [_cat walk];
    //CCLOG(@"Touches ended");
}
- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    hold = NO;
    [_cat walk];
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
