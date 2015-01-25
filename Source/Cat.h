//
//  Cat.h
//  Cats4Real
//
//  Created by Lynda Tang on 1/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"



@interface Cat : CCSprite {
    CCTime _immuneCountdown;
    CCTimer* _immuneTimer;
    BOOL _isImmune;
}

@property (nonatomic, assign) CCTime immuneCountdown;
@property (nonatomic, retain) CCTimer* immuneTimer;
@property (nonatomic, assign) BOOL isImmune;

- (void) startImmuneTimer;
- (void) endImmuneTimer;

- (void)moveSelf:(CCTime)delta :(int)direction :(int)speed :(BOOL)hold;

- (void)walk;
- (void)stand;
- (void)cling;
- (void)openDoor;

@end
