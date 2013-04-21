//
//  Chess.m
//  othello
//
//  Created by xiaofeng chen on 11-11-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Chess.h"


@implementation Chess
@synthesize theGame;
@synthesize mySprite;

-(id) initWithPosition:(CGPoint)pos theGame:(GameLayer*) game 
{
	if ((self = [super init])) 
	{
		
		self.theGame = game; 
		[game addChild:self z:1];
	
		mySprite = [CCSprite spriteWithFile:@"transparent.png"]; 
		[game addChild:mySprite z:1]; 
		[mySprite setPosition:pos];
        
		
	
	} 
	return (self);
}

-(void)setChessType:(int)ballT {
	//self.ballType = ballT;
		
	
	switch (ballT) {
			
      
        case 0:
              [mySprite setTexture:[[CCTextureCache sharedTextureCache]addImage:@"transparent.png"]];
            break;
            
		case -1:
			
			[mySprite setTexture:[[CCTextureCache sharedTextureCache]addImage:@"chess_white.png"]];
		
			break;
            
        case 1:
            [mySprite setTexture:[[CCTextureCache sharedTextureCache]addImage:@"chess_black.png"]];
            break;
            
        case 3:
            [mySprite setTexture:[[CCTextureCache sharedTextureCache]addImage:@"Dot.png"]];
            
        case 4:
            [mySprite setTexture:[[CCTextureCache sharedTextureCache]addImage:@"Dot.png"]];

            
		default:
            
            break;
	}
	
	
	
}


@end
