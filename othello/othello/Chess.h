//
//  Chess.h
//  othello
//
//  Created by xiaofeng chen on 11-11-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
// UI for Chess

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"

@class GameLayer;
@interface Chess : CCNode {
    CCSprite * mySprite;
    GameLayer *theGame;
}
@property(nonatomic,retain) CCSprite * mySprite;
@property(nonatomic,retain) GameLayer *theGame;


-(void)setChessType:(int)ballT;
-(id) initWithPosition:(CGPoint)pos theGame:(GameLayer*) game ;

@end
