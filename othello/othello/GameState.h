//
//  GameState.h
//  othello
//
//  Created by xiaofeng chen on 11-11-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
// Vitual State for Computation

#import <Foundation/Foundation.h>


@interface GameState : NSObject {
    int tempArray[4][4];
    int current_x;
    int current_y;
    BOOL ismyturn;
    BOOL hasMoveAI;
    BOOL hasMoveHu;
    int depth;
    int utility;
}

//+(GameState *)sharedGameState;
-(void)CheckPutChessAi;
-(NSMutableArray *)getActionList;
-(GameState *)getNextState: (int)x: (int)y;

-(BOOL)testTerminate;
-(int)getStateValue;
-(void)CheckAiswollow;

-(void)clearActionList;
-(int)returnArrayValue:(int)x:(int)y;
-(void)setArrayValue:(int)x:(int)y:(int)val;
-(void)SetNextState:(int)x:(int)y;
-(void)Copytostate:(GameState *)state :(GameState*)tostate;
-(void)CopytoState:(int)newState atx:(int)x aty:(int)y;
-(BOOL)isSameState:(GameState *)state :(GameState*)tostate;

@property (nonatomic) int current_x;
@property (nonatomic) int current_y;
@property (nonatomic) BOOL ismyturn;
@property (nonatomic) int depth;
@property (readwrite) int utility;


@end
