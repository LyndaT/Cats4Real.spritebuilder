#import "MainScene.h"

@implementation MainScene
{
    CCButton *_levelSelectButton;
    BOOL firstTime;
}

- (id)init {
    if (self = [super init]) {
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
    
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio playBg:@"assets/music/MenuMusic.mp3" loop:TRUE];
}

- (void)play {
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

- (void)playCutscene {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Anim/CutsceneScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

- (void)settings{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Settings"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}


@end
