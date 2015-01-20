#import "MainScene.h"

@implementation MainScene

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


@end
