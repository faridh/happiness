//
//  KarmaController.h
//  karma
//
//  Created by Faridh Mendoza on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface KarmaController : NSObject

@property(readwrite,retain) User *user;
@property(readwrite,retain) NSMutableDictionary *rewardData;
@property(readwrite,retain) NSMutableDictionary *levelUpData;

+(KarmaController*) sharedController;
-(void) loadUserState;
-(void) saveState;

@end
