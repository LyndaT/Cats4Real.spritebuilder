#import "MainScene.h"

@implementation MainScene
{
    CCButton *_levelScreenButton;
}

- (void)didLoadFromCCB {
    NSUInteger highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"highestlevel"];
    if (highestLevel == nil) {
        _levelScreenButton.enabled = NO;
    }
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
