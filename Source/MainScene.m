#import "MainScene.h"

@implementation MainScene
{
    CCButton *_levelSelectButton;
}

- (void)didLoadFromCCB {
    NSUInteger highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"highestlevel"];
    if (highestLevel == nil || highestLevel == 1) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"highestlevel"];
        _levelSelectButton.enabled = NO;
    }
    
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio playBg:@"assets/music/MenuMusic.mp3" loop:TRUE];
}

- (void)play {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

- (void)levelSelect {
    CCLOG(@"LevelSelect");
    CCScene *gameplayScene = [CCBReader loadAsScene:@"LevelSelect"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

- (void)playCutscene {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Anim/CutsceneScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

- (void)settings{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Settings"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}


@end
