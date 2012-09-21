//
//  User.h
//  karma
//
//  Created by Faridh Mendoza on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (readwrite) BOOL twitterEnabled;
@property (readwrite) BOOL facebookEnabled;
@property (readwrite) BOOL foursquareEnabled;
@property (readwrite) BOOL hasRated;

@property (readwrite, retain) NSString * fbid;
@property (readwrite) int karmaPoints;
@property (readwrite) int socialKarma;
@property (readwrite) int healthKarma;
@property (readwrite) int beautyKarma;
@property (readwrite) int greenKarma;
@property (readwrite) int totalKarma;
@property (readwrite) int level;
@property (readwrite, retain) NSMutableArray *badges;
@property (strong) NSMutableArray *userLikes;
@property (strong) NSMutableArray *nearbyLocations;

@end
