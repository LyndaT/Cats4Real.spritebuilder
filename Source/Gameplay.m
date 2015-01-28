//
//  Gameplay.m
//  Cats4Real
//
//  Created by Lili Sun on 1/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>
#import <CCAction.h>
#import "Cat.h"
#import "Door.h"
#import "Level.h"
#import "Cake.h"
#import "Door.h"
#import "Globals.h"
#import "GameOver.h"
#import "CakeDial.h"

CGFloat gravitystrength = 3000;
CGFloat direction = 0;
CGFloat speed = 30;
CGFloat immuneTime = 3.0f;
BOOL hold = NO;
BOOL onground = NO;
BOOL atDoor = NO;
BOOL isDead = NO;
BOOL isImmune = YES;
BOOL hasCake = NO;
int numCake = 0;
BOOL isPaused = NO;
BOOL isOpeningDoor = NO; //for the anim of the cat opening the door
int rotation = 0; //a number 1-4, phone is at (rotation) degrees
CGSize screenSize;
float oldCatX; //used for camera mvt
float oldCatY;
BOOL hasClung = NO;


@implementation Gameplay
{
    //taken from Spritebuilder
    CCNode *_levelNode;
    Globals *_globals;
    CCPhysicsNode *_physNode;
//    CCLabelTTF *_cakeScore;
    CCNode *_menus;
    CCButton *_pause;
    
    CakeDial *_dial;
    GameOver *_gameOverMenu;
    CCNode *_levelDoneMenu;
    CCNode *_noClingStar;
    CCNode *_pauseMenu;
    Level *_currentLevel;
    CCScene *currentLevel;
    Door *_door;
    Cat *_cat;
    CMMotionManager *_motionManager; //instance of the motion manager, please ONLY create one
}

- (id)init
{
    if (self = [super init])
    {
        // activate touches on this scene
        self.userInteractionEnabled = TRUE;
        _motionManager = [[CMMotionManager alloc] init];//initiate the MotionManager
        _globals = [Globals globalManager];
    }
    return self;
}

- (void)didLoadFromCCB
{
    screenSize = [CCDirector sharedDirector].viewSize;
    
    _gameOverMenu = (GameOver *)[CCBReader load:@"GameOver" owner:self];
    _levelDoneMenu = [CCBReader load:@"NextLevel" owner:self];
    _noClingStar = [CCBReader load:@"Star" owner:self];
    _pauseMenu = [CCBReader load:@"Pause" owner:self];
    
    currentLevel = [CCBReader load:_globals.currentLevelName];
    _currentLevel = (Level *)currentLevel;
    
    [_levelNode addChild:currentLevel];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];//unlock level in loader
    [defaults setInteger:_globals.currentLevelNumber forKey:_globals.currentLevelName];
    CCLOG(@"Finished loading level %i", _globals.currentLevelNumber);
    
    _dial = (CakeDial *)[CCBReader load:@"Sprites/CakeDial" owner:self];
    _door = (Door *)[CCBReader load:@"Sprites/Door" owner:self];
    _cat = (Cat *)[CCBReader load:@"Sprites/Cat" owner:self];
    [_levelNode addChild:_door];
    [_levelNode addChild:_cat];
    
    _dial.position = ccp(0,screenSize.height);
    _dial.scale = 0.8;
    [self addChild:_dial];
    
    [self resetLevel];
    
    _physNode.collisionDelegate = self;
    _cat.physicsBody.collisionType = @"cat";
    
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio playBg:@"assets/music/CreditsMusic.mp3" loop:TRUE];
    [[OALSimpleAudio sharedInstance] setBgVolume:_globals.musicVolume];
}

- (void)update:(CCTime)delta
{
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    
    [self adjustLayer];
    
    if(!hold && !isOpeningDoor && !isImmune)
    {
        [self changeGravity:acceleration.x :acceleration.y];
        [_cat moveSelf:delta :direction :speed :hold];
    }
    if (atDoor)
    {
        if (numCake>=_currentLevel.totalCake && ![self isCatNyooming] && !isOpeningDoor)
        {
            [_door hover];
        }
    }
}

/**----------------Level moving stuff----------------
 *
 */

-(void) adjustLayer
{
    CGSize screenSize = [CCDirector sharedDirector].viewSize;
    
    float halfOfScreenX = screenSize.width/2.0f;
    float halfOfScreenY = screenSize.height/2.0f;
    
    CGSize levelSize = _currentLevel.contentSize;
    
    //only move if lvl is bigger than screen size
    if (screenSize.width < levelSize.width || screenSize.height < levelSize.height)
    {
        float changeX = 0;
        float changeY = 0;
        
        CCLOG(@"%f %f %f",_cat.position.x, halfOfScreenX, screenSize.width);
        
        if ((_cat.position.x + halfOfScreenX) < levelSize.width && (_cat.position.x - halfOfScreenX) > 0)
        {
            changeX = oldCatX - _cat.position.x;
        }
        
        if ((_cat.position.y + halfOfScreenY) < levelSize.height && (_cat.position.y - halfOfScreenY) > 0)
        {
            changeY = oldCatY - _cat.position.y;
        }
        
        oldCatX = _cat.position.x;
        oldCatY = _cat.position.y;
        
        [_physNode runAction:[CCActionMoveBy actionWithDuration:0.3 position:ccp(changeX,changeY) ]];
    }
    
    
}

/**----------------Collisions Begin Here----------------
 */

/*
 * Colliding with Cake
 * Checks to see if the cat crashes into the cake
 */
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair cat:(CCNode *)Cat cake:(Cake *)Cake
{
    //only interact w/cake if it's visible
    if (Cake.visible==true){
        if ([self isCatNyooming])
        {
            //if you're nyooming, you smash it and DIE
            OALSimpleAudio *effect = [OALSimpleAudio sharedInstance];
            [effect playEffect:@"assets/music/splat.mp3"];
            CCLOG(@"smoosh!");
            [_gameOverMenu cake];
            [self died];
        }
        else
        {
            //if you're not nyooming, you collect the cake
            numCake++;
            [_dial increaseCake];
            OALSimpleAudio *effect = [OALSimpleAudio sharedInstance];
            [effect playEffect:@"assets/music/ding.mp3"];
            [self updateCakeScore];
            [Cake collected];
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
    OALSimpleAudio *effect = [OALSimpleAudio sharedInstance];
    [effect playEffect:@"assets/music/splash.mp3"];
    [_gameOverMenu water];
    [self died];
    return TRUE;
}


/*
 * Colliding with door
 * Checks to see if the cat is at the door
 */
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair
                                *)pair cat:(CCNode *)Cat door:(CCNode *)Door
{
    CCLOG(@"hit door");
    if (_globals.currentLevelNumber==1)
    {
        CCLabelTTF *doorInstruc = [CCLabelTTF labelWithString:@"Tap the screen to go through!" fontName:@"PlaytimeWithHotToddies" fontSize:20];
        doorInstruc.position = ccp(367,52.5);
        [currentLevel addChild:doorInstruc];
    }
    atDoor = YES;
    return TRUE;
}

-(BOOL)ccPhysicsCollisionSeparate:(CCPhysicsCollisionPair *)pair cat:(CCNode *)Cat door:(CCNode *)Door
{
    CCLOG(@"leaves door");
    atDoor = NO;
    [self updateCakeScore];
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
    
    _gameOverMenu.rotation = rotation;
    [_menus addChild:_gameOverMenu];
    _pause.enabled=false;
    _pause.visible=false;
}

-(void)pause
{
    if (!isDead && !isOpeningDoor){
        if (!isPaused){
            //to pause scene
            [[CCDirector sharedDirector] pause];
            isPaused=YES;
            CCLOG(@"rotation: %i",rotation);
            _pauseMenu.rotation = rotation;
            [_menus addChild:_pauseMenu];
        }
        else{
            [self unpause];
        }
    }
}

-(void)unpause
{
    isPaused=NO;
    [[CCDirector sharedDirector] resume];
    [_menus removeChild:_pauseMenu];
    CCLOG(@"resumed game");
}

-(void)retry
{
    [self unpause];
    
    [self resetLevel];
    
    if (isDead)
    {
        isDead = NO;
        _pause.enabled=true;
        _pause.visible=true;
        [_menus removeChild:_gameOverMenu];
    }
}

-(void)retryFromDeath
{
    isDead = NO;
    _pause.enabled=true;
    _pause.visible=true;
    [_menus removeChild:_gameOverMenu];
    [[CCDirector sharedDirector] resume];
    [self resetLevel];
}

//from pause menu or gameover menu
-(void)returnMenu
{
    CCLOG(@"returnMenu");
    [self unpause];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

//from death menu
-(void)returnMenuFromDied
{
    CCLOG(@"returnMenu");
    _pause.enabled=true;
    _pause.visible=true;
    [_menus removeChild:_gameOverMenu];
    [[CCDirector sharedDirector] resume];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

//from nextlevel menu
-(void)returnMenuFromLevelEnd
{
    isOpeningDoor=NO;
    _pause.enabled=true;
    _pause.visible=true;
    [_menus removeChild:_levelDoneMenu];
    [_menus removeChild:_noClingStar];
    [[CCDirector sharedDirector] resume];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

//continue to next level
-(void)cont
{
    isOpeningDoor=NO;
    [_cat walk];
    [_door close];
    [_menus removeChild:_levelDoneMenu];
    [_menus removeChild:_noClingStar];
    _pause.enabled=true;
    _pause.visible=true;
    [[CCDirector sharedDirector] resume];
    [self toNextLevel];
}

-(void)catThroughDoor
{
    CCLOG(@"cat thru door");
    [[CCDirector sharedDirector] pause];
    _levelDoneMenu.rotation = rotation;
    [_menus addChild:_levelDoneMenu];
    _pause.enabled=false;
    _pause.visible=false;
    _noClingStar.rotation = rotation;
    [_menus addChild:_noClingStar];
    if(!hasClung)
    {
        CCLOG(@"cling star!");
        _noClingStar.visible=true;
        [_globals setClingStars:_globals.currentLevelNumber :1];
    }else
    {
        CCLOG(@"no cling star");
        _noClingStar.visible=false;
        [_globals setClingStars:_globals.currentLevelNumber :0];
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
    if (![self isCatNyooming]) {
        int prevDirection = direction;
        if (xaccel < 0.5 && xaccel > -0.5 && yaccel < -0.5)
        {
            direction = 3;
        }
        if (yaccel < 0.5 && yaccel > -0.5 && xaccel >0.5)
        {
            direction = 0;
        }
        if (xaccel < 0.5 && xaccel > -0.5 && yaccel> 0.5)
        {
            direction = 1;
        }
        if (yaccel < 0.5 && yaccel > -0.5 && xaccel<-0.5)
        {
            direction = 2;
        }
        [self updateGravity:direction];
        if (prevDirection != direction) {
            //CCLOG(@"gravity Changed");
            _cat.physicsBody.velocity = ccp(0,0);
            
        }
    }
    
}

/*
 * General updateGravity method
 * Changes gravity depending on current direction
 */
- (void)updateGravity:(int)dir
{
    if (dir == 1) { //gravity right
        rotation = 270;
        _physNode.gravity= ccp(1*gravitystrength,0);
    }
    else if (dir == 2) { //gravity up
        rotation = 180;
        _physNode.gravity= ccp(0,1*gravitystrength);
    }
    else if (dir == 3) { //gravity left
        rotation = 90;
        _physNode.gravity= ccp(-1*gravitystrength,0);
    }
    else { //gravity down
        rotation = 0;
        _physNode.gravity= ccp(0,-1*gravitystrength);
    }
}

/*
 * the changeGravity[direction] methods change the gravity of the physicsNode
 * to the direction of the orientation of the screen
 * DEPRECATED
 */
//- (void)changeGravityLeft
//{
//    direction = 3;
//    _physNode.gravity= ccp(-1*gravitystrength,0);
//    //CCLOG(@"Gravity changed left");
//    
//}
//- (void)changeGravityRight
//{
//    direction = 1;
//    _physNode.gravity= ccp(1*gravitystrength,0);
//    //CCLOG(@"Gravity changed right");
//    
//}
//- (void)changeGravityUp
//{
//    direction = 2;
//    _physNode.gravity= ccp(0,1*gravitystrength);
//    //CCLOG(@"Gravity changed up");
//    
//}
//- (void)changeGravityDown
//{
//    direction = 0;
//    _physNode.gravity= ccp(0,-1*gravitystrength);
//    //CCLOG(@"Gravity changed down");
//    
//}

-(void)toNextLevel
{
    numCake=0;
    [_levelNode removeChild:currentLevel];
    
    int nextLvl = _currentLevel.nextLevel;
    BOOL isCutsceneNext = _currentLevel.isCutsceneNext;
    if (!isCutsceneNext)
    {
        [_globals setLevel:nextLvl];
        
        //check to see if next level is highest level so far, and store if so
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"highestlevel"] < nextLvl) {
            [[NSUserDefaults standardUserDefaults] setInteger:nextLvl forKey:@"highestlevel"];
        }
        
        currentLevel = [CCBReader load:[[Globals globalManager] currentLevelName]];
        _currentLevel = (Level *)currentLevel;
        
        NSLog(@"next level %d", _currentLevel.nextLevel);
        NSLog(@"highest level so far: %ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"highestlevel"]);
        
        [_levelNode addChild:currentLevel];
        
        [self resetLevel];
    }else
    {
        [_globals setCutscene:nextLvl];
        CCScene *cutscene = [CCBReader loadAsScene:@"Anim/CutsceneScene"];
        [[CCDirector sharedDirector] replaceScene:cutscene];    }
}

-(void)resetLevel
{
//    [currentLevel removeChild:_door];
    [_levelNode removeChild:currentLevel];
    currentLevel = [CCBReader load:[[Globals globalManager] currentLevelName]];
    _currentLevel = (Level *)currentLevel;
    [_levelNode addChild:currentLevel];
    
    _physNode.position=ccp(0,0);
    
    hasClung=NO;
    
    numCake=0;
    [_dial setNumSlices:_currentLevel.totalCake];
    
    //reposition cake dial and pause btn
    if (_currentLevel.defaultOrientation == 1) { //screen right
        _dial.position = ccp(0,0);
        _dial.rotation = 270;
        _pause.position = ccp(0.96,0.06);
        _pause.rotation = 90;
    }
    else if (_currentLevel.defaultOrientation == 2) { //screen up
        _dial.position = ccp(screenSize.width,0);
        _dial.rotation = 180;
        _pause.position = ccp(0.04,0.06);
        _pause.rotation = 0;
    }
    else if (_currentLevel.defaultOrientation == 3) { //screen left
        _dial.position = ccp(screenSize.width, screenSize.height);
        _dial.rotation = 90;
        _pause.position = ccp(0.04,0.94);
        _pause.rotation = 270;
    }
    else { //screen down
        _dial.position = ccp(0,screenSize.height);
        _dial.rotation = 0;
        _pause.position = ccp(0.96, 0.94);
        _pause.rotation = 180;
    }
    
    [self updateCakeScore];
    _cat.position = ccp(_currentLevel.catX, _currentLevel.catY);
    _cat.physicsBody.velocity = ccp(0,0);
    oldCatX = _cat.position.x;
    oldCatY = _cat.position.y;
//    CCLOG(@"cat added, %d, %d, supposedly %d, %d",_cat.position.x,_cat.position.y, _currentLevel.catX, _currentLevel.catY);
//    [currentLevel addChild:_door];
    _door.position = ccp(_currentLevel.doorX, _currentLevel.doorY);
    _door.rotation = _currentLevel.doorAngle;
//    CCLOG(@"door pos %d, %d",_door.position.x, _door.position.y);
    
    [self startImmunity];
    [self scheduleOnce:@selector(endImmunity) delay:immuneTime];

//    [currentLevel stopAllActions];
//    currentLevel.position=ccp(0,0);
//    CGRect worldBoundary = CGRectMake(0, 0, _currentLevel.contentSize.width, _currentLevel.contentSize.height);
//    id camMove =[CCActionFollow actionWithTarget:_cat worldBoundary:worldBoundary];
//    [currentLevel runAction:[CCActionFollow actionWithTarget:_cat worldBoundary:worldBoundary]];
}

//Sets the cat in a frozen 'immune' state
-(void)startImmunity
{
    [_cat moveSelf:0 :_currentLevel.defaultOrientation :0 :NO];
    _physNode.gravity= ccp(0,0);
    isImmune = YES;
    _cat.physicsBody.velocity = ccp(0,0);
    _cat.physicsBody.angularVelocity = 0;
    [_cat blink];
    CCLOG(@"starting immune");
}

//Ends cat's immune state
//called automatically after time passes, or after screen is tapped
-(void)endImmunity
{
    if (isImmune) {
        isImmune = NO;
        [_cat walk];
        [_cat moveSelf:0 :direction :speed :NO];
        direction = _currentLevel.defaultOrientation;
        [self updateGravity:_currentLevel.defaultOrientation];
        CCLOG(@"ending immune");
    }
}

-(void)updateCakeScore
{
//    _cakeScore.string = [NSString stringWithFormat:@"%i/%i cake", numCake, _currentLevel.totalCake];
    if (numCake>=_currentLevel.totalCake)
    {
        CCLOG(@"door open");
        [_door open];
    }else
    {
        CCLOG(@"door close");
        [_door close];
    }
}

-(BOOL)isCatNyooming
{
    return (sqrt(pow(_cat.physicsBody.velocity.x,2) + pow(_cat.physicsBody.velocity.y,2)) > 150);
}


/*
 * Handling tap/hold/clench using touches
 */
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if (isImmune) {
        [self endImmunity];
    }
    if (onground && !isOpeningDoor)
    {
        hold = YES;
        if (!atDoor)
        {
            CCLOG(@"oh no you clung ):");
            hasClung = YES;
        }
        [_cat cling];
    }
    if (atDoor && (numCake>=_currentLevel.totalCake) && ![self isCatNyooming] && !isOpeningDoor)
    {
        CCLOG(@"Cat rotation %f", _cat.rotation);
        CCLOG(@"Door rotation %f", _door.rotation);
        if (_cat.rotation!=_door.rotation) {
            CCLOG(@"wrong rotation!");
        }
        else {
            //knock sound
            OALSimpleAudio *effect = [OALSimpleAudio sharedInstance];
            [effect playEffect:@"assets/music/knock.mp3"];
            CCLOG(@"audioplayed");
            
//            int currLevel = _globals.currentLevelNumber;
//            CCLOG(@"has not clung: %i", !hasClung);
//            [_globals setClingStars: currLevel :(int)(!hasClung)];
            isOpeningDoor=YES;
            [_cat openDoor];
            [_door fade];
        }
    }else if (atDoor && (numCake<_currentLevel.totalCake) && ![self isCatNyooming] && !isOpeningDoor)
    {
        [_currentLevel pulseCakes];
        [_dial pulse];
    }
    //CCLOG(@"Touches began");
    
}
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!isOpeningDoor && hold)
    {
        [_cat walk];
    }
    hold = NO;
    [self adjustLayer];
    //CCLOG(@"Touches ended");
}
- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!isOpeningDoor && hold)
    {
        [_cat walk];
    }
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
