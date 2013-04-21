//
//  HelloWorldLayer.m
//  othello
//
//  Created by xiaofeng chen on 11-11-12.
//  Copyright __MyCompanyName__ 2011年. All rights reserved.
//

#define GAME_Bound 10
#define GAME_Len 65
#define MAXV 999
#define MINV -999

// Import the interfaces
#import "GameLayer.h"
#import "GameState.h"
int maxDepth ; 
int nodeNum ;
int minPruning ;
int maxPruning ;



// Othello implementation
@implementation GameLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		self.isTouchEnabled = YES;
        CGSize wins = [[CCDirector sharedDirector] winSize];
         Turn=kStateBlack;
        [CCMenuItemFont  setFontName:@"Marker Felt"];
        [CCMenuItemFont setFontSize:25];
        PlayFirst=[[CCLabelTTF alloc] initWithString:@"Want to skip the first turn?" fontName:@"Marker Felt" fontSize:30];
        [self addChild:PlayFirst z:3];
        [PlayFirst setPosition:ccp(wins.width/2,wins.height/2)];
        
        CCMenuItem* Firstplayer=[CCMenuItemFont itemFromString:@"Yes" target:self selector:@selector(skiptowhite:)];
        CCMenuItem* Secondplayer=[CCMenuItemFont itemFromString:@"No" target:self selector:@selector(skiptoblack:)];
        
         Pmenu=[CCMenu menuWithItems:Firstplayer, Secondplayer,nil];
        [self addChild:Pmenu z:2];
        [Pmenu alignItemsVertically];
        [Pmenu setPosition:ccp(wins.width/2,wins.height/2-45)];
        
        
       

        
        for(int i=0;i<4;i++)
            for(int j=0;j<4;j++)
                saveValue[i][j]=0;
            
        for(int i=0;i<4;i++)
            for(int j=0;j<4;j++){
                checkPostion[i][j]=CGRectMake(98+GAME_Bound+i*GAME_Len, 18+GAME_Bound+j*GAME_Len, GAME_Len, GAME_Len);
                Chessarray[i][j]=[[Chess alloc]initWithPosition:ccp(checkPostion[i][j].origin.x+GAME_Len/2,checkPostion[i][j].origin.y+GAME_Len/2) theGame:self ];
            }
        saveValue[1][1]=1;
        saveValue[2][2]=1;
        saveValue[1][2]=-1;
        saveValue[2][1]=-1;
        
        BlackChessNum=[[CCLabelTTF alloc] initWithString:@"2" fontName:@"Marker Felt" fontSize:25];
      
          WhiteChessNum=[[CCLabelTTF alloc] initWithString:@"2" fontName:@"Marker Felt" fontSize:25];
        WhiteChessNum.color=ccc3(0,0,0); 
        
        BlackChessNum.position=ccp(400,280);
        WhiteChessNum.position=ccp(400,40);
        [self addChild:BlackChessNum z:3];
        [self addChild:WhiteChessNum z:3];

     
        [Chessarray[1][1] setChessType:saveValue[1][1]];
        [Chessarray[1][2] setChessType:saveValue[1][2]];
        [Chessarray[2][2] setChessType:saveValue[2][2]];
        [Chessarray[2][1] setChessType:saveValue[2][1]];
		// create and initialize a Label
        CCSprite *chessboard=[[CCSprite alloc] initWithFile:@"Board.png"];
        [chessboard setPosition:ccp(wins.width/2,wins.height/2)];
        [self addChild:chessboard z:0];
		 [self CheckPutChess];
        
       
        
        
        CCMenuItem* replayGame=[CCMenuItemFont itemFromString:@"Replay" target:self selector:@selector(Replay:)];
        CCMenuItemToggle *DMode = [CCMenuItemToggle itemWithTarget:self selector:@selector(menuCallback:) items:
                                    [CCMenuItemFont itemFromString: @"Nightmare"],
                                      [CCMenuItemFont itemFromString: @"Difficult"],
                                   [CCMenuItemFont itemFromString: @"Easy"],
                                  
                                      nil] ;
        
        CCMenu *Rmenu=[CCMenu menuWithItems:replayGame, nil];
        [self addChild:Rmenu z:2];
        [Rmenu alignItemsVertically];
        [Rmenu setPosition:ccp(35,200)];
        

        CCMenu *Dmenu=[CCMenu menuWithItems:DMode, nil];
        [self addChild:Dmenu z:2];
        [Dmenu alignItemsVertically];
        [Dmenu setPosition:ccp(30,100)];
        
        //[self CheckScore];
        hasmovementHu=YES;
        hasmovementAI=YES;
        
        difficulty=20;
       
		// add all the menus , labels and background as children to this Layer
		
	}
	return self;
}


//Take Max and Min

-(int) maxInt:(int) a:(int) b{
	if(a>b)return a;
	else return b;
}
-(int) minInt:(int) a:(int) b{
	if(a<b)return a;
    else return b;
}

//Alpha_Beta_Search
-(void) Alpha_Beta_Search:(GameState*)state{
	
	maxDepth  = 0;
	nodeNum = 1;
	minPruning = 0;
	maxPruning = 0;
    state.depth=0;
    valueList=[[NSMutableArray alloc] init];
    GameState *Nowstate=[[GameState alloc] init];
  
   
	int v=[self Max_Value:state a:MINV b:MAXV];
	//NSMutableArray * t=[[NSMutableArray alloc] init];
    for(int i=0;i<4;i++)
        for(int j=0;j<4;j++)
        {
            if(saveValue[i][j]<3){
                [Nowstate CopytoState:saveValue[i][j] atx:i aty:j];
                //NSLog(@"SAVE VALUE[%d][%d]=%d",i,j,saveValue[i][j]);
            }
            else
            {
                saveValue[i][j]=0;
                [Nowstate CopytoState:saveValue[i][j] atx:i aty:j];
                // NSLog(@"SAVE VALUE[%d][%d]=%d",i,j,saveValue[i][j]);
            }
        }
    
    
    
   NSMutableArray *  t=[Nowstate getActionList];
    //NSLog(@"STATE COUNT:%d",[t count]);
    if([t count]==0)
    {
        Turn=kStateBlack;
        hasmovementAI=NO;
        return;
    }
    else
        hasmovementAI=YES;
	for(int i=0;i<[t count];i++){
        //GameState *nState =state;
        NSValue *val=[t objectAtIndex:i];
        CGPoint p=[val CGPointValue];
        int x=p.x;
        int y=p.y;
             // NSLog(@"Utility%d",v);

        [Nowstate SetNextState:x:y];
        for(int j=0;j<[valueList count];j++){
            NSLog(@"Valuelist utility%d",[[valueList objectAtIndex:j] utility]);

        //if([Nowstate isSameState:Nowstate :[valueList objectAtIndex:j]])
		if([[valueList objectAtIndex:j] utility] == v){
			//state.actionList[i];
                       
            saveValue[x][y]=-1;
            [Chessarray[x][y] setChessType:saveValue[x][y]]; 
            current_x=x;
            current_y=y;
            NSLog(@"AI PUT##############################################");
             [Nowstate release];
            
            return ;

		}
        }
	}
    
    NSValue *val=[t objectAtIndex:0];
    CGPoint p=[val CGPointValue];
    int tempx=p.x;
    int tempy=p.y;
    saveValue[tempx][tempy]=-1;
    [Chessarray[tempx][tempy] setChessType:saveValue[tempx][tempy]]; 
    current_x=tempx;
    current_y=tempy;
    [Nowstate release];
     
}
//Max

-(int) Max_Value:(GameState*)state a:(int)alpha b:(int) beta{
	if([state testTerminate] == true){
             NSLog(@"DEPTH **************************%d",state.depth);
       
        
		return [state getStateValue];
        
	}
    if([self cutOnDifficulty])
    {
        return [state getStateValue];
        NSLog(@"D leverl changed!!!!!!!!");
    }
    
	
	int v = MINV;
	
   NSMutableArray * tmax=[state getActionList];

	for(int i=0;i<[tmax count];i++){
        NSValue *val=[tmax objectAtIndex:i];
        CGPoint p=[val CGPointValue];
        int x=p.x;
        int y=p.y;
        GameState *nState=[[GameState alloc] init]; 
        [nState Copytostate:state :nState];
        [nState SetNextState:(int)x:(int)y];
        //[state getNextState:x:y];
        NSLog(@"CHOOSE NEXT SATE FOR MAX {%d,%d:%d}",x,y,[nState returnArrayValue:x :y]);
    
		nodeNum++;
        //NSLog(@"Node Number in MAX:%d",nodeNum);
		v = [self maxInt:v:[self Min_Value:nState a:alpha b:beta]];
        if(state.depth==1){
            for(int i=0;i<4;i++)
                for(int j=0;j<4;j++)
                    NSLog(@"STATE VLUE temp[%d][%d]=%d",i,j,[state returnArrayValue:i :j]);
            GameState *tempstate=[[GameState alloc] init]; 
            [tempstate Copytostate:state :tempstate];
            tempstate.utility=v;
            [valueList addObject:tempstate];
            NSLog(@"UTILITY  %d!!!!!!!!!!!!!!!!",[state getStateValue]);
            
        }
		if(v>=beta){
			maxPruning+=([tmax count] - i-1);
			return v;
		}
		alpha = [self maxInt:alpha:v];
	}
    if(state.depth==1){
       
        GameState *tempstate=[[GameState alloc] init]; 
        [tempstate Copytostate:state :tempstate];
        tempstate.utility=v;
        [valueList addObject:tempstate];
        NSLog(@"UTILITY  %d!!!!!!!!!!!!!!!!",[state getStateValue]);
        
    }

	return v;
}
//Min
-(int) Min_Value:(GameState*)state a:(int)alpha b:(int) beta{
	if([state testTerminate] == true){
                
        NSLog(@"DEPTH **************************%d",state.depth);
        return [state getStateValue];
	}
    if([self cutOnDifficulty])
    {
        return [state getStateValue];
        NSLog(@"D leverl changed!!!!!!!!");
	}
    
	//NSMutableArray * tmin=[[NSMutableArray alloc] init];
    NSMutableArray * tmin=[state getActionList];
     NSLog(@"min action list number !!!! %d",[tmin count]);

	int v = MAXV;
	for(int i=0;i<[tmin count];i++){
        NSValue *val=[tmin objectAtIndex:i];
        CGPoint p=[val CGPointValue];
        int x=p.x;
        int y=p.y;
		GameState *nState =[[GameState alloc] init];
        [nState Copytostate:state :nState];
        [nState SetNextState:(int)x:(int)y];
        maxDepth = [self maxInt:nState.depth :maxDepth];

          NSLog(@"CHOSE NEXT SATE FOR MIN {%d,%d:%d}",x,y,[nState returnArrayValue:x :y]);

		nodeNum++;
        //NSLog(@"Node Number In Min :%d",nodeNum);
       
        
		v = [self minInt:v: [self Max_Value:nState a:alpha b:beta]];
        if(state.depth==1){
            for(int i=0;i<4;i++)
                for(int j=0;j<4;j++)
                    NSLog(@"STATE VLUE temp[%d][%d]=%d",i,j,[state returnArrayValue:i :j]);
            //state.utility=[state getStateValue];
            GameState *tempstate=[[GameState alloc] init]; 
            [tempstate Copytostate:state :tempstate];
            tempstate.utility=v;
            [valueList addObject:tempstate];
            NSLog(@"UTILITY  %d!!!!!!!!!!!!!!!!",[state getStateValue]);
            
        }
		if(v<=alpha){
			minPruning+=([tmin count] - i-1);
			return v;
		}
		beta = [self minInt:beta :v ];
        
	}
    if(state.depth==1){
       
        GameState *tempstate=[[GameState alloc] init]; 
        [tempstate Copytostate:state :tempstate];
        tempstate.utility=v;
        [valueList addObject:tempstate];
        NSLog(@"UTILITY  %d!!!!!!!!!!!!!!!!",[state getStateValue]);
        
    }

	return v;
}


//END
//Touch Event
-(void) onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
	
}

- (void)onExit {
	
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self]; 
	[super onExit];
}




- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView: [touch view]]; 
	//CGSize wins = [[CCDirector sharedDirector] winSize];
    
	location = [[CCDirector sharedDirector] convertToGL: location];
	
    //Human player's Turn.
    for(int i=0;i<4;i++)
        for(int j=0;j<4;j++){
            if(CGRectContainsPoint(checkPostion[i][j], location) ){
               
                
                if(Turn==kStateBlack&&saveValue[i][j]==3)
                {
                saveValue[i][j]=1;
               [Chessarray[i][j] setChessType:saveValue[i][j]];
                    current_x=i;
                    current_y=j;
                           
                    //  Put Chess!
                    [self clearPutPostion];
                    [self Checkswollow];
                    [self CheckScore];
                    [self schedule:@selector(ChangeTurn) interval:2];
                    
                }
                
               

            }
        }
    
           
    
    
                         
          
      //AI player's turn 
    
    if(Turn==kStateWhite){
        GameState *CurrentState=[[GameState alloc] init];
            for(int i=0;i<4;i++)
                for(int j=0;j<4;j++)
                {
                    if(saveValue[i][j]<3){
                    [CurrentState CopytoState:saveValue[i][j] atx:i aty:j];
                        //NSLog(@"SAVE VALUE[%d][%d]=%d",i,j,saveValue[i][j]);
                    }
                    else
                    {
                       // saveValue[i][j]=0;
                         [CurrentState CopytoState:0 atx:i aty:j];
                       // NSLog(@"SAVE VALUE[%d][%d]=%d",i,j,saveValue[i][j]);
                    }
                }
            
        [self Alpha_Beta_Search:CurrentState];
            
            //OutPut The Nodes ,Depth and pruning number in the log.
            NSLog(@"Total Number of Nodes:%d. of Deepth%d. of Max pruning%d. of Min pruning%d.", nodeNum,maxDepth,maxPruning,minPruning);
        [self clearPutPostion];
        [self Checkswollow];
        [self CheckScore];
        [self CheckPutChess];
               Turn=kStateBlack;
               
       
        NSArray *temp=[self getHumanActionList];
        if ([temp count]==0) {
            Turn=kStateWhite;
            hasmovementHu=NO;
        }
        else
            hasmovementHu=YES;
        
    }
            
        
  
}

-(void)ChangeTurn{
    Turn=kStateWhite;
    [self unschedule:@selector(ChangeTurn)];
    
}
//Clear the Dots!
-(void)clearPutPostion{
    for(int i=0;i<4;i++)
        for(int j=0;j<4;j++)
            if(saveValue[i][j]==3)
            {
                saveValue[i][j]=0;
                [Chessarray[i][j] setChessType:0];
            }   

}

//Get Action List for human player.
-(NSMutableArray *)getHumanActionList{
    //[self CheckPutChess];
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    CGPoint tp=CGPointZero;
    for(int i=0;i<4;i++)
        for(int j=0;j<4;j++)
            if( saveValue[i][j]==3){
                tp=CGPointMake(i, j);
                
                [temp addObject:[NSValue valueWithCGPoint:tp]];
                
                //NSLog(@"TEMP ARRAY COUNT For White:%d",[temp count]);
            }
         
    
    // [temp release];
    return temp;
}

//Check which position can put and show it as a dot for human player!
-(void)CheckPutChess{
    for(int i=0;i<4;i++)
        for(int j=0;j<4;j++)
           
            if(saveValue[i][j]==1){
                if(i<2){
                    for(int t=i+1;t<3;t++)
                        if(saveValue[t][j]==-1&&saveValue[t+1][j]==0)
                        {
                            NSLog(@"X:%d,Y:%d h<2",t+1,j);
                            saveValue[t+1][j]=3;
                              //Chessarray[t+1][j]=[[Chess alloc]initWithPosition:ccp(checkPostion[t+1][j].origin.x+GAME_Len/2,checkPostion[t+1][j].origin.y+GAME_Len/2) theGame:self ];
                           
                            [Chessarray[t+1][j] setChessType:saveValue[t+1][j]];
                            //hasmovement=YES;
                        }
                    
                }
                if(i>=2) {
                    for(int t=i-1;t>=1;t--)
                        if(saveValue[t][j]==-1&&saveValue[t-1][j]==0)
                        {
                           NSLog(@"X:%d,Y:%d h>2",t-1,j); 
                    saveValue[t-1][j]=3;
                          // Chessarray[t-1][j]=[[Chess alloc]initWithPosition:ccp(checkPostion[t-1][j].origin.x+GAME_Len/2,checkPostion[t-1][j].origin.y+GAME_Len/2) theGame:self ];
                            
                    [Chessarray[t-1][j] setChessType:saveValue[t-1][j]];
                           //hasmovement=YES;
                        }
                    
                }
                if(j<2){
                    for(int t=j+1;t<3;t++)
                        if(saveValue[i][t]==-1&&saveValue[i][t+1]==0)
                        {
                            NSLog(@"X:%d,Y:%d v<2",i,t+1);
                            saveValue[i][t+1]=3;
                           //  Chessarray[i][t+1]=[[Chess alloc]initWithPosition:ccp(checkPostion[i][t+1].origin.x+GAME_Len/2,checkPostion[i][t+1].origin.y+GAME_Len/2) theGame:self ];
                            
                            [Chessarray[i][t+1] setChessType:saveValue[i][t+1]];
                        
                          // hasmovement=YES;
                        }
                }
                if(j>=2) {
                    for(int t=j-1;t>=1;t--)
                        if(saveValue[i][t]==-1&&saveValue[i][t-1]==0)
                        {
                            NSLog(@"X:%d,Y:%d v>2",i,t-1);
                            saveValue[i][t-1]=3;
                         //    Chessarray[i][t-1]=[[Chess alloc]initWithPosition:ccp(checkPostion[i][t-1].origin.x+GAME_Len/2,checkPostion[i][t-1].origin.y+GAME_Len/2) theGame:self ];
                            

                            [Chessarray[i][t-1] setChessType:saveValue[i][t-1]];
                           //hasmovement=YES;
                        }
                }
                if(i<2&&j<2){
                    int n=j+1;
                    for(int m=i+1;m<3;m++)
                    {
                        
                        while(n<3)
                        {
                            if(saveValue[m][n]==-1&&saveValue[m+1][n+1]==0)
                            {
                                NSLog(@"save[%d][%d]=%d",i,j,saveValue[i][j]);
                                NSLog(@"X:%d,Y:%d v<2,h<2",m+1,n+1);
                                saveValue[m+1][n+1]=3;
                            //      Chessarray[m+1][n+1]=[[Chess alloc]initWithPosition:ccp(checkPostion[m+1][n+1].origin.x+GAME_Len/2,checkPostion[m+1][n+1].origin.y+GAME_Len/2) theGame:self ];
                               

                                [Chessarray[m+1][n+1] setChessType:saveValue[m+1][n+1]];
                              //  hasmovement=YES;
                            }
                        n++;
                        }
                    }
                }
                if(i>=2&&j>=2){
                    int n=j-1;
                    for(int m=i-1;m>=1;m--)
                    {
                        while(n>=1)
                        {
                            if(saveValue[m][n]==-1&&saveValue[m-1][n-1]==0)
                            {
                                NSLog(@"X:%d,Y:%d v>=2,h>=2",m-1,n-1);
                                saveValue[m-1][n-1]=3;
                              //    Chessarray[m-1][n-1]=[[Chess alloc]initWithPosition:ccp(checkPostion[m-1][n-1].origin.x+GAME_Len/2,checkPostion[m-1][n-1].origin.y+GAME_Len/2) theGame:self ];
                              
                                [Chessarray[m-1][n-1] setChessType:saveValue[m-1][n-1]];
                           //   hasmovement=YES;
                            }
                        n--;
                        }
                    }
                }
                if(i<2&&j>=2){
                    int n=j-1;
                    
                    for(int m=i+1;m<3;m++)
                    {
                        while(n>=1) {
                            if(saveValue[m][n]==-1&&saveValue[m+1][n-1]==0)
                            {
                                NSLog(@"X:%d,Y:%d h<2 v>=2",m+1,n-1);
                                saveValue[m+1][n-1]=3;
                          //        Chessarray[m+1][n-1]=[[Chess alloc]initWithPosition:ccp(checkPostion[m+1][n-1].origin.x+GAME_Len/2,checkPostion[m+1][n-1].origin.y+GAME_Len/2) theGame:self ];
                               
                                [Chessarray[m+1][n-1] setChessType:saveValue[m+1][n-1]];
                             //  hasmovement=YES;
                            }
                        n--;
                    }
                    }
                }
                if(i>=2&&j<2){
                    int n=j+1;
                        for(int m=i-1;m>=1;m--)
                            while(n<3) {
                            if(saveValue[m][n]==-1&&saveValue[m-1][n+1]==0)
                            {
                                NSLog(@"X:%d,Y:%d h>=2 v<2",m-1,n+1);
                                saveValue[m-1][n+1]=3;
                            //      Chessarray[m-1][n+1]=[[Chess alloc]initWithPosition:ccp(checkPostion[m-1][n+1].origin.x+GAME_Len/2,checkPostion[m-1][n+1].origin.y+GAME_Len/2) theGame:self ];
                                
                                     
                                [Chessarray[m-1][n+1] setChessType:saveValue[m-1][n+1]];
                           //    hasmovement=YES;
                            }
                    n++;
                            }
                    
                }
                    
            }
            
    
}

//Check Swollow chess with the reversi rule
-(void)Checkswollow{
    
    if(current_x<2){
        if(saveValue[current_x][current_y]==saveValue[current_x+2][current_y]&&saveValue[current_x+1][current_y]!=0)
        {
            saveValue[current_x+1][current_y]=saveValue[current_x][current_y];
           // NSLog(@"Swallow to vlaue%d",saveValue[current_x+1][current_y]);
        }
        else if(current_x+3<4&&saveValue[current_x][current_y]==saveValue[current_x+3][current_y]&&saveValue[current_x+1][current_y]!=saveValue[current_x][current_y])
        {
            saveValue[current_x+1][current_y]=saveValue[current_x][current_y];
            saveValue[current_x+2][current_y]=saveValue[current_x][current_y];
        }
        
    }
    if(current_x>=2)
    {
        if(saveValue[current_x][current_y]==saveValue[current_x-2][current_y]&&saveValue[current_x-1][current_y]!=0)
        {
            saveValue[current_x-1][current_y]=saveValue[current_x][current_y];
        }
        else if(current_x-3>=0&&saveValue[current_x][current_y]==saveValue[current_x-3][current_y]&&saveValue[current_x-1][current_y]!=saveValue[current_x][current_y])
        {
            saveValue[current_x-1][current_y]=saveValue[current_x][current_y];
            saveValue[current_x-2][current_y]=saveValue[current_x][current_y];
        }
        
    }
    if(current_y<2){
        if(saveValue[current_x][current_y]==saveValue[current_x][current_y+2]&&saveValue[current_x][current_y+1]!=0)
        {
            saveValue[current_x][current_y+1]=saveValue[current_x][current_y];
        }
        else if(current_y+3<4&&saveValue[current_x][current_y]==saveValue[current_x][current_y+3]&&saveValue[current_x][current_y+1]!=saveValue[current_x][current_y])
        {
            saveValue[current_x][current_y+1]=saveValue[current_x][current_y];
            saveValue[current_x][current_y+2]=saveValue[current_x][current_y];
        }

    }
    if(current_y>=2)
    {
        if(saveValue[current_x][current_y]==saveValue[current_x][current_y-2]&&saveValue[current_x][current_y-1]!=0)
        {
            saveValue[current_x][current_y-1]=saveValue[current_x][current_y];
        }
        else if(current_y-3>=0&&saveValue[current_x][current_y]==saveValue[current_x][current_y-3]&&saveValue[current_x][current_y-1]!=saveValue[current_x][current_y])
        {
            saveValue[current_x][current_y-1]=saveValue[current_x][current_y];
            saveValue[current_x][current_y-2]=saveValue[current_x][current_y];
        }
        
    }
    
    if(current_x>=2&&current_y>=2&&saveValue[current_x-1][current_y-1]!=0)
    {
        if(saveValue[current_x][current_y]==saveValue[current_x-2][current_y-2])
        {
            saveValue[current_x-1][current_y-1]=saveValue[current_x][current_y];
        }
        else if(saveValue[current_x][current_y]==saveValue[current_x-3][current_y-3]&&saveValue[current_x-1][current_y-1]!=saveValue[current_x][current_y])
        {
            saveValue[current_x-1][current_y-1]=saveValue[current_x][current_y];
            saveValue[current_x-2][current_y-2]=saveValue[current_x][current_y];
        }
        
    }
    
    if(current_x<2&&current_y<2&&saveValue[current_x+1][current_y+1]!=0)
    {
        if(saveValue[current_x][current_y]==saveValue[current_x+2][current_y+2])
        {
            saveValue[current_x+1][current_y+1]=saveValue[current_x][current_y];
        }
        else if(saveValue[current_x][current_y]==saveValue[current_x+3][current_y+3]&&saveValue[current_x+1][current_y+1]!=saveValue[current_x][current_y])
        {
            saveValue[current_x+1][current_y+1]=saveValue[current_x][current_y];
            saveValue[current_x+2][current_y+2]=saveValue[current_x][current_y];
        }
        
    }
    
    if(current_x>=2&&current_y<2&&saveValue[current_x-1][current_y+1]!=0)
    {
        if(saveValue[current_x][current_y]==saveValue[current_x-2][current_y+2])
        {
            saveValue[current_x-1][current_y+1]=saveValue[current_x][current_y];
        }
        else if(saveValue[current_x][current_y]==saveValue[current_x-3][current_y+3]&&saveValue[current_x-1][current_y+1]!=saveValue[current_x][current_y])
        {
            saveValue[current_x-1][current_y+1]=saveValue[current_x][current_y];
            saveValue[current_x-2][current_y+2]=saveValue[current_x][current_y];
        }
        
    }
    
    if(current_x<2&&current_y>=2)
    {
        if(saveValue[current_x][current_y]==saveValue[current_x+2][current_y-2]&&saveValue[current_x+1][current_y-1]!=0)
        {
            saveValue[current_x+1][current_y-1]=saveValue[current_x][current_y];
        }
        else if(saveValue[current_x][current_y]==saveValue[current_x+3][current_y-3]&&saveValue[current_x+1][current_y-1]!=saveValue[current_x][current_y])
        {
            saveValue[current_x+1][current_y-1]=saveValue[current_x][current_y];
            saveValue[current_x+2][current_y-2]=saveValue[current_x][current_y];
        }
        
    }
    
    //Check_horiziontal
    for(int i=0;i<4;i++)
        for(int j=0;j<4;j++)
        {
                           
            [Chessarray[i][j] setChessType:saveValue[i][j]];
        
 //   NSLog(@"check for value %d",saveValue[i][j]);
        }
    //Check_verticall
    //Check_diagnol
}


//keep update the number of black chess and white chess each turn

-(void)CheckScore{
    int Score_black=0;
    int Score_white=0;
    for(int i=0;i<4;i++)
        for(int j=0;j<4;j++)
        {
            if(saveValue[i][j]==1)
            {
                Score_black++;
            [BlackChessNum setString:[NSString stringWithFormat:@"%d",Score_black]];
            }
            else if(saveValue[i][j]==-1)
            {
                Score_white++;
                [WhiteChessNum setString:[NSString stringWithFormat:@"%d",Score_white]];
            }
            }

    //When the there is no movement for both players, check who is the winner.
    if(hasmovementHu==NO&&hasmovementAI==NO){
        CGSize wins = [[CCDirector sharedDirector] winSize];

        if(Score_black>Score_white)
        {
          CCLabelTTF* Result=[[CCLabelTTF alloc] initWithString:@"Black Win" fontName:@"Marker Felt" fontSize:30];
            Result.color=ccc3(0, 0, 0);
        [self addChild:Result z:3];
        [Result setPosition:ccp(wins.width/2,wins.height/2)];
            [Result release];
        }
        if(Score_black<Score_white)
        {
        
            CCLabelTTF* Result=[[CCLabelTTF alloc] initWithString:@"White Win" fontName:@"Marker Felt" fontSize:30];
            [self addChild:Result z:3];
            [Result setPosition:ccp(wins.width/2,wins.height/2)];
            [Result release];
        }
        else{
            CCLabelTTF* Result=[[CCLabelTTF alloc] initWithString:@"Tie Game" fontName:@"Marker Felt" fontSize:30];
            [self addChild:Result z:3];
            [Result setPosition:ccp(wins.width/2,wins.height/2)];
            [Result release];
        }
              
            }
    
    
}




//replay menu

-(void)Replay:(id)sender{
    CCScene *sc = [CCScene node];
	[sc addChild:[GameLayer node]];
	
	[[CCDirector sharedDirector] replaceScene: sc];

    
}
//Set difficulty menu
-(void) menuCallback: (id) sender
{
	NSLog(@"selected item: %@ index:%d", [sender selectedItem], [sender selectedIndex] );
    int tempd= [sender selectedIndex];
    switch (tempd) {
        case 0:
            difficulty=20;
            break;
        case 1:
            difficulty=5;
            break;
        case 2:
            difficulty=2;
            break;
        default:
            break;
    }
}

//
-(BOOL) cutOnDifficulty{
	if(maxDepth>=difficulty){
		return true;
	}else{
		return false;
	}
}

// Let the AI play First

-(void) skiptowhite: (id) sender
{
	Turn=kStateWhite;
    PlayFirst.visible=NO;
    [self removeChild:Pmenu cleanup:YES];
    
}

//Let Human play First
-(void) skiptoblack: (id) sender
{
	//Turn=kStateWhite;
     PlayFirst.visible=NO;
    [self removeChild:Pmenu cleanup:YES];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
