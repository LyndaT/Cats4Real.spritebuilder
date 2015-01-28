#import "MainScene.h"
#import "Globals.h"

@implementation MainScene
{
    CCButton *_levelSelectButton;
    BOOL firstTime;
    Globals *_globals;
}

- (id)init {
    if (self = [super init]) {
        _globals = [Globals globalManager];
        firstTime=YES;
    }
    return self;
}

- (void)didLoadFromCCB {
    NSUInteger highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"highestlevel"];
    if (highestLevel == nil || highestLevel == 1) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"highestlevel"];
        firstTime=YES;
    }else
    {
        firstTime=NO;
    }
    
    // play background sound
    [_globals.audio playBg:@"assets/music/MenuMusic.mp3" loop:TRUE];
}

- (void)play {
    [_globals.audio playEffect:@"assets/music/ding.mp3"];
    if (firstTime)
    {
        CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
    }else
    {
        CCLOG(@"LevelSelect");
        CCScene *gameplayScene = [CCBReader loadAsScene:@"LevelSelect"];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
    }
}

- (void)settings{
    [_globals.audio playEffect:@"assets/music/ding.mp3"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Settings"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}


@end
