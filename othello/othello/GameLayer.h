//
//  HelloWorldLayer.h
//  othello
//
//  Created by xiaofeng chen on 11-11-12.
//  Copyright __MyCompanyName__ 2011年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Chess.h"
#import "GameState.h"
typedef enum tagState { 
	kStateBlack, 
	kStateWhite
} turnState;


@class Chess;
// HelloWorldLayer
@interface GameLayer : CCLayer
{
    int saveValue[4][4]; //value for each square
    BOOL hasmovementHu;
    BOOL hasmovementAI;
    CGRect checkPostion[4][4];// rectangle for each position
    //int Score_black;
   // int Score_white;
    int current_x;//x for the chosen point.
    int current_y;//y for the chosen point.
    int difficulty;
    turnState Turn;
    CCLabelTTF *BlackChessNum;
    CCLabelTTF *WhiteChessNum;
    CCMenu *Pmenu;
    Chess *Chessarray[4][4];// Chess object
    CCLabelTTF*PlayFirst;
    NSMutableArray *valueList;
    
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void)CheckPutChess;
-(void)Checkswollow;
-(void)CheckScore;
-(void)clearPutPostion;
-(void)ChangeTurn;
-(NSMutableArray *)getHumanActionList;
-(int) maxInt:(int) a:(int) b;
-(int) minInt:(int) a:(int) b;
-(int) Max_Value:(GameState*)state a:(int)alpha b:(int) beta;
-(int) Min_Value:(GameState*)state a:(int)alpha b:(int) beta;
-(void) Alpha_Beta_Search:(GameState*)state;
-(BOOL) cutOnDifficulty;


@end
