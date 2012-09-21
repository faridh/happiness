//
//  User.m
//  karma
//
//  Created by Faridh Mendoza on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@implementation User

@synthesize twitterEnabled, facebookEnabled, foursquareEnabled, hasRated;
@synthesize fbid, karmaPoints, socialKarma, beautyKarma, healthKarma, greenKarma, totalKarma, level, badges, userLikes, nearbyLocations;

-(id) init
{
    if(self = [super init]) 
    {
        self.twitterEnabled = false;
        self.facebookEnabled = false;
        self.foursquareEnabled = false;
        self.hasRated = false;
        
        self.fbid = @"";
        self.karmaPoints = 0;
        self.socialKarma = 0;
        self.greenKarma = 0;
        self.beautyKarma = 0;
        self.healthKarma = 0;
        self.totalKarma = self.karmaPoints + self.socialKarma + self.beautyKarma + self.healthKarma + self.greenKarma;
        self.level = 1;
        
        self.badges = [NSMutableArray alloc];
        self.nearbyLocations = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
