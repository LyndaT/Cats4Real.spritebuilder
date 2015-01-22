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
}

@synthesize _cakeWidth;
@synthesize _totalLevels;

//Setting up the level select screen with the right amount of cake
- (void)setTable {
    //Grabbing highest lvl cleared so far from NSUserDefaults
    NSUInteger highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"highestlevel"];
    if (highestLevel == nil) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"highestlevel"];
        highestLevel = 1;
    }
    
    int tempY=0;
    int tempX=0;
    for (int j = 1; j <= _totalLevels; j++) {
        //placemats
        CCNode *placemat = [CCBReader load:@"assets/levelSelect/plateTag"];
        placemat.position = ccp(100 + (_cakeWidth+12.5)*tempX,210 - tempY);
        [self addChild:placemat];
        
        //plates w/cake
        if (j<highestLevel)
        {
            LevelSelectCake *tempCake = (LevelSelectCake *)[CCBReader load:@"assets/levelSelect/cakePlate"];
            tempCake.position = ccp(98 + (_cakeWidth+13)*tempX,250 - tempY);
            [tempCake setLevel:j];
            [self addChild:tempCake];
        }
        
        CCLabelTTF *lvlText = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"level %i",j]
                                                 fontName:@"Lao Sangam MN" fontSize:16];
        lvlText.color = [CCColor colorWithCcColor3b:ccBLACK];
        lvlText.position = ccp(100 + (_cakeWidth+12.5)*tempX,205 - tempY);
        [self addChild:lvlText];
        
        tempY = (floor((j)/4) * 120);
        tempX = (j) - (floor((j)/4) * 4);
    }
    
    //empty plate
    tempY = (floor((highestLevel-1)/4) * 120);
    tempX = (highestLevel-1) - (floor((highestLevel-1)/4) * 4);
    LevelSelectCake *tempPlate = (LevelSelectCake *)[CCBReader load:@"assets/levelSelect/emptyPlate"];
    tempPlate.position = ccp(98 + (_cakeWidth+13)*tempX,250 - tempY);
    [tempPlate setLevel:highestLevel];
    [self addChild:tempPlate];
}

- (void)returnMenu {
    CCLOG(@"returnMenu");
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

- (id)init {
    if (self = [super init]) {
        _globals = [Globals globalManager];
    }
    return self;
}

- (void)didLoadFromCCB {
    [self setTable];
}
@end
