//
//  CakeDial.m
//  Cats4Real
//
//  Created by Lili Sun on 1/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CakeDial.h"

@implementation CakeDial
{
    CCAnimationManager* animationManager;
    CCSprite *_plate;
    CCNode *_cherryNode;
    CCNode *_lineNode;
    int _numSlices;
    int _numFound;
}

-(id)init{
    self = [super init];
    
    if(self){
        CCLOG(@"cake dial created");
    }
    
    return self;
}

- (void)didLoadFromCCB
{
    animationManager = self.animationManager;
    _numSlices=2;
    [self resetDial];
}

-(void)setNumSlices:(int)slices
{
    _numSlices = slices;
    [self resetDial];
}

//+1 cake
-(void)increaseCake
{
    _numFound++;
    _plate.rotation = _numFound * (90 / _numSlices);
}

-(void)clearCake
{
    _plate.rotation = 0;
    
    [_cherryNode removeAllChildren];
    [_lineNode removeAllChildren];
}

//sends it back to 0 cakes with proper numver of slices
-(void)resetDial
{
    [self clearCake];
    
    for (int i = 0; i<_numSlices; i++)
    {
        CCNode *tempCherry = [CCBReader load:@"Sprites/CakeDialCherry" owner:self];
        tempCherry.rotation = i * (90 / _numSlices) + (0.5 * (90 / _numSlices));
        [_cherryNode addChild:tempCherry];
        
        CCNode *tempLine = [CCBReader load:@"Sprites/CakeDialLine" owner:self];
        tempLine.rotation = i * (90 / _numSlices);
        [_lineNode addChild:tempLine];
    }
    
    if (_numSlices !=0)
    {
        CCNode *tempLine = [CCBReader load:@"Sprites/CakeDialLine" owner:self];
        tempLine.rotation =  90;
        [_lineNode addChild:tempLine];
    }
}

-(void)pulse
{
    [animationManager runAnimationsForSequenceNamed:@"pulse"];
}

@end
