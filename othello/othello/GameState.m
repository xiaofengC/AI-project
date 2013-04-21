//
//  GameState.m
//  othello
//
//  Created by xiaofeng chen on 11-11-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"



@implementation GameState
//static GameState * _shareGamestate=nil;
@synthesize current_x;
@synthesize current_y;
@synthesize ismyturn;
@synthesize depth;
@synthesize utility;




- (id)init {
	if((self = [super init])) {
		//for(int i=0;i<4;i++)
        //    for(int j=0;j<4 ;j++)
         //       tempArray[i][j]=0;
		
        
        current_x=0;
        current_y=0;
        depth=0;
        utility=0;
        ismyturn=YES;
        hasMoveAI=YES;
        hasMoveHu=YES;
        
	}
	return self;
}
-(void)CopytoState:(int)newState atx:(int)x aty:(int)y{
    tempArray[x][y]=newState;
    
}
-(int)getStateValue{
    int tempsum=0;
    for(int i=0;i<4;i++)
        for(int j=0;j<4;j++){
            if(tempArray[i][j]<2)
                tempsum+=tempArray[i][j];
                }
    return tempsum;
}

-(BOOL)testTerminate{
    NSMutableArray*temp=[self getActionList];
    if([temp count]==0)
        return YES;
    else 
        return NO;
        
}

-(GameState* )getNextState: (int)x: (int)y{
   
    GameState*NextState=self;
    
    
        if(NextState.ismyturn)
            [NextState setArrayValue:x :y :-1];
        else
            [NextState setArrayValue:x :y :1];
       
        NextState.current_x=x;
        NextState.current_y=y;
         [NextState CheckAiswollow];
    
    NextState.ismyturn=!NextState.ismyturn;
    //[self clearActionList];
    return NextState;
    
}

-(void)SetNextState:(int)x:(int)y{
    
        if(ismyturn)
            [self setArrayValue:x :y :-1];
        else
            [self setArrayValue:x :y :1];
        
        current_x=x;
        current_y=y;
        [self CheckAiswollow];
        
       // NSLog(@"%d--------",[self returnArrayValue:x :y]);
    self.depth++;
    ismyturn=!ismyturn;
}

-(int)returnArrayValue:(int)x:(int)y{
    return tempArray[x][y];
}
-(void)setArrayValue:(int)x:(int)y:(int)val{
    tempArray[x][y]=val;

    
}
-(void)Copytostate:(GameState *)state :(GameState*)tostate{
    tostate.ismyturn=state.ismyturn;
    for(int i=0;i<4;i++)
        for(int j=0;j<4;j++)
            [tostate setArrayValue:i :j :[state returnArrayValue:i :j]];
            
    tostate.current_x=state.current_x;
    tostate.current_y=state.current_y;
    tostate.depth=state.depth;
    tostate.utility=state.utility;
    
    //NSLog(@"Depth**********************************%d",depth);
    
            }

-(BOOL)isSameState:(GameState *)state :(GameState*)tostate{
    for(int i=0;i<4;i++)
        for(int j=0;j<4;j++)
            if([tostate returnArrayValue:i :j]!=[state returnArrayValue:i :j]){
                return NO;
            }
    
    return YES;
}



-(void)clearActionList{
    for(int i=0;i<4;i++)
        for(int j=0;j<4;j++)
            if(tempArray[i][j]==4||tempArray[i][j]==-4)
                tempArray[i][j]=0;
            
}
-(NSMutableArray *)getActionList{
    [self CheckPutChessAi];
    NSMutableArray *temp=[[NSMutableArray alloc] init];
  
    
    CGPoint tp=CGPointZero;
    for(int i=0;i<4;i++){
        for(int j=0;j<4;j++){
            if(self.ismyturn&& tempArray[i][j]==4){
                tp=CGPointMake(i, j);
                
                [temp addObject:[NSValue valueWithCGPoint:tp]];
                tempArray[i][j]=0;
                // NSLog(@"TEMP ARRAY COUNT For White:%d",[temp count]);
            }
            if(!self.ismyturn&&tempArray[i][j]==-4){
                tp=CGPointMake(i, j);
                
                [temp addObject:[NSValue valueWithCGPoint:tp]];
                 tempArray[i][j]=0;
                // NSLog(@"TEMP ARRAY COUNT For Black:%d",[temp count]);
            }
        }
                
    }
    if([temp count]==0&&self.ismyturn)
    {
        hasMoveHu=NO;
        self.ismyturn=NO;
    }
    else
        hasMoveHu=YES;
    if([temp count]==0&&!self.ismyturn)
    {
        hasMoveAI=NO;
        self.ismyturn=YES;
    }
    else
        hasMoveAI=YES;
    
    
   // [temp release];
    return temp;
}

-(void)CheckPutChessAi{
    for(int i=0;i<4;i++)
        for(int j=0;j<4;j++)
        {
            if(ismyturn)
            {
            
            if(tempArray[i][j]==-1){
                if(i<2){
                    for(int t=i+1;t<3;t++)
                        if(tempArray[t][j]==1&&tempArray[t+1][j]==0)
                        {
                        //   NSLog(@"X:%d,Y:%d Horizontal<2",t+1,j);
                            tempArray[t+1][j]=4;
                            
                            
                        }
                    
                }
                else {
                    for(int t=i-1;t>=1;t--)
                        if(tempArray[t][j]==1&&tempArray[t-1][j]==0)
                        {
                         //  NSLog(@"X:%d,Y:%d Horizontal>2",t-1,j); 
                            tempArray[t-1][j]=4;
                            
                        }
                    
                }
                if(j<2){
                    for(int t=j+1;t<3;t++)
                        if(tempArray[i][t]==1&&tempArray[i][t+1]==0)
                        {
                         //   NSLog(@"X:%d,Y:%d Vertical <2",i,t+1);
                            tempArray[i][t+1]=4;
                            //  Chessarray[i][t+1]=[[Chess alloc]initWithPosition:ccp(checkPostion[i][t+1].origin.x+GAME_Len/2,checkPostion[i][t+1].origin.y+GAME_Len/2) theGame:self ];
                            
                        }
                }
                else {
                    for(int t=j-1;t>=1;t--)
                        if(tempArray[i][t]==1&&tempArray[i][t-1]==0)
                        {
                          // NSLog(@"X:%d,Y:%d Vetical >2",i,t-1);
                            tempArray[i][t-1]=4;
                            //    Chessarray[i][t-1]=[[Chess alloc]initWithPosition:ccp(checkPostion[i][t-1].origin.x+GAME_Len/2,checkPostion[i][t-1].origin.y+GAME_Len/2) theGame:self ];
                            
                        }
                }
                if(i<2&&j<2){
                    int n=j+1;
                    for(int m=i+1;m<3;m++)
                    {
                        while(n<3){
                            if(tempArray[m][n]==1&&tempArray[m+1][n+1]==0)
                            {
                          //      NSLog(@"X:%d,Y:%d Diagonal",m+1,n+1);
                                tempArray[m+1][n+1]=4;
                                
                            }
                        n++;
                        }
                    }
                }
                if(i>=2&&j>2){
                    int n=j-1;
                    for(int m=i-1;m>=1;m--)
                    {
                        while(n>=1)
                        {
                            if(tempArray[m][n]==1&&tempArray[m-1][n-1]==0)
                            {
                           //     NSLog(@"X:%d,Y:%d Diagonal",m-1,n-1);
                                tempArray[m-1][n-1]=4;
                                
                            }
                    n--;
                        }
                    }
                }
                if(i<2&&j>=2){
                    int n=j-1;
                    for(int m=i+1;m<3;m++)
                    {
                        while(n>=1)
                        {
                            if(tempArray[m][n]==1&&tempArray[m+1][n-1]==0)
                            {
                           //    NSLog(@"X:%d,Y:%d Diagonal",m+1,n-1);
                                tempArray[m+1][n-1]=4;
                                
                            }
                    n--;
                        }
                    }
                }
                if(i>=2&&j<2){
                   int n=j+1;
                    for(int m=i-1;m>=1;m--)
                    {
                        while(n<3)
                        {
                            if(tempArray[m][n]==1&&tempArray[m-1][n+1]==0)
                            {
                           //    NSLog(@"X:%d,Y:%d Diagonal",m-1,n+1);
                                tempArray[m-1][n+1]=4;
                                
                            }
                    n++;
                        }
                    }
                }
                
            }
            }
           if(!ismyturn){
                if(tempArray[i][j]==1){
                    if(i<2){
                        for(int t=i+1;t<3;t++)
                            if(tempArray[t][j]==-1&&tempArray[t+1][j]==0)
                            {
                                // NSLog(@"X:%d,Y:%d",t+1,j);
                                tempArray[t+1][j]=-4;
                                
                                
                            }
                        
                    }
                    else {
                        for(int t=i-1;t>=1;t--)
                            if(tempArray[t][j]==-1&&tempArray[t-1][j]==0)
                            {
                                // NSLog(@"X:%d,Y:%d",t-1,j); 
                                tempArray[t-1][j]=-4;
                                
                            }
                        
                    }
                    if(j<2){
                        for(int t=j+1;t<3;t++)
                            if(tempArray[i][t]==-1&&tempArray[i][t+1]==0)
                            {
                                //  NSLog(@"X:%d,Y:%d",i,t+1);
                                tempArray[i][t+1]=-4;
                                //  Chessarray[i][t+1]=[[Chess alloc]initWithPosition:ccp(checkPostion[i][t+1].origin.x+GAME_Len/2,checkPostion[i][t+1].origin.y+GAME_Len/2) theGame:self ];
                                
                            }
                    }
                    else {
                        for(int t=j-1;t>=1;t--)
                            if(tempArray[i][t]==-1&&tempArray[i][t-1]==0)
                            {
                                // NSLog(@"X:%d,Y:%d",i,t-1);
                                tempArray[i][t-1]=-4;
                                //    Chessarray[i][t-1]=[[Chess alloc]initWithPosition:ccp(checkPostion[i][t-1].origin.x+GAME_Len/2,checkPostion[i][t-1].origin.y+GAME_Len/2) theGame:self ];
                                
                            }
                    }
                    if(i<2&&j<2){
                        int n=j+1;
                        for(int m=i+1;m<3;m++)
                        {
                            while(n<3){
                                if(tempArray[m][n]==-1&&tempArray[m+1][n+1]==0)
                                {
                                    //      NSLog(@"X:%d,Y:%d Diagonal",m+1,n+1);
                                    tempArray[m+1][n+1]=4;
                                    
                                }
                                n++;
                            }
                        }
                    }
                    if(i>=2&&j>2){
                        int n=j-1;
                        for(int m=i-1;m>=1;m--)
                        {
                            while(n>=1)
                            {
                                if(tempArray[m][n]==-1&&tempArray[m-1][n-1]==0)
                                {
                                    //     NSLog(@"X:%d,Y:%d Diagonal",m-1,n-1);
                                    tempArray[m-1][n-1]=4;
                                    
                                }
                                n--;
                            }
                        }
                    }
                    if(i<2&&j>=2){
                        int n=j-1;
                        for(int m=i+1;m<3;m++)
                        {
                            while(n>=1)
                            {
                                if(tempArray[m][n]==-1&&tempArray[m+1][n-1]==0)
                                {
                                    //    NSLog(@"X:%d,Y:%d Diagonal",m+1,n-1);
                                    tempArray[m+1][n-1]=4;
                                    
                                }
                                n--;
                            }
                        }
                    }
                    if(i>=2&&j<2){
                        int n=j+1;
                        for(int m=i-1;m>=1;m--)
                        {
                            while(n<3)
                            {
                                if(tempArray[m][n]==-1&&tempArray[m-1][n+1]==0)
                                {
                                    //    NSLog(@"X:%d,Y:%d Diagonal",m-1,n+1);
                                    tempArray[m-1][n+1]=4;
                                    
                                }
                                n++;
                            }
                        }
                    }

            
            
            }
        }
    
    
}
}
    
    
-(void)CheckAiswollow{
    if(current_x<2){
        if(tempArray[current_x][current_y]==tempArray[current_x+2][current_y]&& tempArray[current_x+1][current_y]!=0)
        {
            tempArray[current_x+1][current_y]=tempArray[current_x][current_y];
                   }
        else if(current_x+3<4&&tempArray[current_x][current_y]==tempArray[current_x+3][current_y]&&tempArray[current_x+1][current_y]!=tempArray[current_x][current_y])
        {
            tempArray[current_x+1][current_y]=tempArray[current_x][current_y];
            tempArray[current_x+2][current_y]=tempArray[current_x][current_y];
        }
        
    }
    if(current_x>=2)
    {
        if(tempArray[current_x][current_y]==tempArray[current_x-2][current_y]&&tempArray[current_x-1][current_y]!=0)
        {
            tempArray[current_x-1][current_y]=tempArray[current_x][current_y];
        }
        else if(current_x-3>=0&&tempArray[current_x][current_y]==tempArray[current_x-3][current_y]&&tempArray[current_x-1][current_y]!=tempArray[current_x][current_y])
        {
            tempArray[current_x-1][current_y]=tempArray[current_x][current_y];
            tempArray[current_x-2][current_y]=tempArray[current_x][current_y];
        }
        
    }
    if(current_y<2){
        if(tempArray[current_x][current_y]==tempArray[current_x][current_y+2]&&tempArray[current_x][current_y+1]!=0)
        {
            tempArray[current_x][current_y+1]=tempArray[current_x][current_y];
        }
        else if(current_y+3<4&&tempArray[current_x][current_y]==tempArray[current_x][current_y+3]&&tempArray[current_x][current_y+1]!=tempArray[current_x][current_y])
        {
            tempArray[current_x][current_y+1]=tempArray[current_x][current_y];
            tempArray[current_x][current_y+2]=tempArray[current_x][current_y];
        }
        
    }
    if(current_y>=2)
    {
        if(tempArray[current_x][current_y]==tempArray[current_x][current_y-2]&&tempArray[current_x][current_y-1]!=0)
        {
            tempArray[current_x][current_y-1]=tempArray[current_x][current_y];
        }
        else if(current_y-3>=0&&tempArray[current_x][current_y]==tempArray[current_x][current_y-3]&&tempArray[current_x][current_y-1]!=tempArray[current_x][current_y])
        {
            tempArray[current_x][current_y-1]=tempArray[current_x][current_y];
            tempArray[current_x][current_y-2]=tempArray[current_x][current_y];
        }
        
    }
    if(current_x>=2&&current_y>=2)
    {
        if(tempArray[current_x][current_y]==tempArray[current_x-2][current_y-2]&& tempArray[current_x-1][current_y-1]!=0)
        {
            tempArray[current_x-1][current_y-1]=tempArray[current_x][current_y];
        }
        else if(current_y-3>=0&&current_y-3>0&& tempArray[current_x][current_y]==tempArray[current_x-3][current_y-3]&&tempArray[current_x-1][current_y-1]!=tempArray[current_x][current_y])
        {
            tempArray[current_x-1][current_y-1]=tempArray[current_x][current_y];
            tempArray[current_x-2][current_y-2]=tempArray[current_x][current_y];
        }
        
    }
    
    if(current_x<2&&current_y<2)
    {
        if(tempArray[current_x][current_y]==tempArray[current_x+2][current_y+2]&& tempArray[current_x+1][current_y+1]!=0)
        {
            tempArray[current_x+1][current_y+1]=tempArray[current_x][current_y];
        }
        else if(tempArray[current_x][current_y]==tempArray[current_x+3][current_y+3]&&tempArray[current_x+1][current_y+1]!=tempArray[current_x][current_y])
        {
            tempArray[current_x+1][current_y+1]=tempArray[current_x][current_y];
            tempArray[current_x+2][current_y+2]=tempArray[current_x][current_y];
        }
        
    }
    
    if(current_x>=2&&current_y<2)
    {
        if(tempArray[current_x][current_y]==tempArray[current_x-2][current_y+2]&& tempArray[current_x-1][current_y+1]!=0)
        {
            tempArray[current_x-1][current_y+1]=tempArray[current_x][current_y];
        }
        else if(tempArray[current_x][current_y]==tempArray[current_x-3][current_y+3]&&tempArray[current_x-1][current_y+1]!=tempArray[current_x][current_y])
        {
            tempArray[current_x-1][current_y+1]=tempArray[current_x][current_y];
            tempArray[current_x-2][current_y+2]=tempArray[current_x][current_y];
        }
        
    }
    
    if(current_x<2&&current_y>=2)
    {
        if(tempArray[current_x][current_y]==tempArray[current_x+2][current_y-2]&&tempArray[current_x+1][current_y-1]!=0)
        {
            tempArray[current_x+1][current_y-1]=tempArray[current_x][current_y];
        }
        else if(tempArray[current_x][current_y]==tempArray[current_x+3][current_y-3]&&tempArray[current_x+1][current_y-1]!=tempArray[current_x][current_y])
        {
            tempArray[current_x+1][current_y-1]=tempArray[current_x][current_y];
            tempArray[current_x+2][current_y-2]=tempArray[current_x][current_y];
        }
        
    }
    
    
}

@end
