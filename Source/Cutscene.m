//
//  Cutscene.m
//  Cats4Real
//
//  Created by Lili Sun on 1/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Cutscene.h"
#import "Globals.h"
#import "Level.h"
#import "SingleCutscene.h"

@implementation Cutscene
{
    Globals *_globals;
    CCNode *currentScene;
    SingleCutscene *_currentScene;
    CCNode *_cut;
}

- (id)init {
    if (self = [super init]) {
        _globals = [Globals globalManager];
    }
    return self;
}

- (void)didLoadFromCCB
{
    currentScene = [CCBReader load:_globals.currentLevelName owner:self];
    _currentScene = (SingleCutscene *)currentScene;
    _currentScene.rotation = _currentScene.sceneRotation;
//    CCLOG(@"cutscene rotation supposedly %i, is %i",_currentScene.sceneRotation, _currentScene.rotation);
    [_cut addChild:_currentScene];
    CCLOG(@"loaded cutscene, next %i", _currentScene.nextLevel);
    
    // play background sound
    [_globals.audio playBg:@"assets/music/CutsceneMusic.mp3" loop:TRUE];
}

- (void)continue
{
    [_globals.audio playEffect:@"assets/music/button.mp3"];
    if (!_currentScene.isCutsceneNext)
    {
        CCLOG(@"next lvl: %i", _currentScene.nextLevel);
        [_globals setLevel:_currentScene.nextLevel];
        
        CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
    }else
    {
        [_cut removeChild:currentScene];
        [_globals setCutscene:_currentScene.nextLevel];
        
        currentScene = [CCBReader loadAsScene:_globals.currentLevelName];
        [_cut addChild:currentScene];
    }
}

- (void)returnMenu
{
    [_globals.audio playEffect:@"assets/music/button.mp3"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    
}

@end
