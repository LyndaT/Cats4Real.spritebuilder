//
//  LevelSelect.m
//  Cats4Real
//
//  Created by Jenny Lin on 1/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LevelSelect.h"
#import "LevelSelectCake.h"
#import "Globals.h"


@implementation LevelSelect {
    //NSMutableArray *_levelArray;
    float _cakeWidth;
    int _totalLevels;
    Globals *_globals;
    int _currTable;
    CCButton *_nextTable;
    CCButton *_prevTable;
    CCNode *_plateHolder;
}

@synthesize _cakeWidth;
@synthesize _totalLevels;


- (id)init {
    if (self = [super init]) {
        _globals = [Globals globalManager];
    }
    _currTable = 0;
    return self;
}

- (void)didLoadFromCCB {
    //Sets up the first table
    [self setTable];
    [self setButtonMenus];
    _prevTable.visible = false;
    
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio playBg:@"assets/music/MenuMusic.mp3" loop:TRUE];
    
}

/* setButtonMenus sets up the nextTable and prevTable buttons for the current Table
 *
 * currTable: the integer of the currentTable
 */
-(void)setButtonMenus
{
    if (_currTable == 0)
    {
        _prevTable.visible = false;
    }else
    {
        _prevTable.visible = true;
    }
    if (_currTable >= (_totalLevels/8))
    {
        _nextTable.visible = false;
    }
    else
    {
        _nextTable.visible = true;
    }
    
}

/*Setting up the level select screen with the right amount of cake
 *
 * currTable: the integer of the currentTable
 */
- (void)setTable
{
    //Grabbing highest lvl cleared so far from NSUserDefaults
    NSUInteger highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"highestlevel"];
    if (highestLevel == nil) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"highestlevel"];
        highestLevel = 1;
    }
    highestLevel = 8;
    int tempY=0;
    int tempX=0;
    for (int j = 1; j <=8; j++) {
        //placemats
        if (j+8*_currTable<=_totalLevels)
        {
            CCNode *placemat = [CCBReader load:@"assets/levelSelect/plateTag"];
            placemat.position = ccp(100 + (_cakeWidth+12.5)*tempX,210 - tempY);
            [_plateHolder addChild:placemat];
            
            CCLabelTTF *lvlText = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"level %i",j+8*_currTable]
                                                     fontName:@"Playtime With Hot Toddies" fontSize:16];
            lvlText.color = [CCColor colorWithCcColor3b:ccBLACK];
            lvlText.position = ccp(100 + (_cakeWidth+12.5)*tempX,205 - tempY);
            [_plateHolder addChild:lvlText];
        }
        
        //plates w/cake
        if (j+8*_currTable<highestLevel)
        {
            LevelSelectCake *tempCake = (LevelSelectCake *)[CCBReader load:@"assets/levelSelect/cakePlate"];
            tempCake.position = ccp(98 + (_cakeWidth+13)*tempX,250 - tempY);
            [tempCake setLevel:j+8*_currTable];
            [_plateHolder addChild:tempCake];
        }
        
        tempY = (floor((j)/4) * 120);
        tempX = (j) - (floor((j)/4) * 4);
    }
    
    //empty plate
    
    tempY = (floor((highestLevel-1)/4) * 120);
    tempX = (highestLevel-1) - (floor((highestLevel-1)/4) * 4);
    LevelSelectCake *tempPlate = (LevelSelectCake *)[CCBReader load:@"assets/levelSelect/emptyPlate"];
    tempPlate.position = ccp(98 + (_cakeWidth+13)*tempX,245 - tempY);
    [tempPlate setLevel:0]; //set to 0 for testing, set to highestLevel for normal behavior
    if ((8*_currTable)+1 < highestLevel){
        [_plateHolder addChild:tempPlate];
    }
}

//Loads the previous table
-(void)loadPrevTable
{
    _currTable = _currTable-1;
    [self resetTable];
    [self setTable];
    [self setButtonMenus];
    CCLOG(@"curr table %i", _currTable);
}

-(void)loadNextTable
{
    _currTable = _currTable+1;
    [self resetTable];
    [self setTable];
    [self setButtonMenus];
    CCLOG(@"curr table %i", _currTable);
}

-(void)resetTable{
    [_plateHolder removeAllChildren];
    
}

- (void)returnMenu {
    CCLOG(@"returnMenu");
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
