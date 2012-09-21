//
//  KarmaController.m
//  karma
//
//  Created by Faridh Mendoza on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KarmaController.h"
#import "User.h"
#import "SBJSON.h"

@implementation KarmaController

@synthesize user;
@synthesize rewardData;
@synthesize levelUpData;

static KarmaController* _sharedKarmaController = nil;

+(KarmaController*)sharedController
{
	@synchronized([KarmaController class])
	{
    if (!_sharedKarmaController)
        [[self alloc] init];
    
    return _sharedKarmaController;
	}
	return nil;
}

+(id)alloc
{
	@synchronized([KarmaController class])
	{
        NSAssert(_sharedKarmaController == nil, @"[KarmaController] Attempted to allocate a second instance of a singleton.");
        _sharedKarmaController = [super alloc];
        return _sharedKarmaController;
	}
	return nil;
}

-(id) init
{
    if(self = [super init]) 
    {
        // USER BLOCK
        self.user = [[User alloc] init];
        [self loadUserState];
        [self saveState];
    
        NSLog(@"Initializing dataSource");
    
        // REWARDS BLOCK
        //LOAD THE JSON
        NSError *error = nil;
        SBJsonParser * parser = [[SBJsonParser alloc] init];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"rewards" ofType:@"json" inDirectory:@""];
        NSString * platformsJson = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        self.rewardData = [parser objectWithString:platformsJson];
        
        if(self.rewardData == nil)
        {
            NSLog(@"Error parsing JSON file %@", [error localizedDescription]);
            NSException *exception = [NSException exceptionWithName:@"JSONException"
                                    reason:[NSString stringWithFormat:@"Info: %@",
                                            [error localizedDescription]]
                                                           userInfo:nil];
            [exception raise];
        }
    
        // LEVELUP BLOCK
        //LOAD THE JSON
        error = nil;
        parser = [[SBJsonParser alloc] init];
        filePath = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"json" inDirectory:@""];
        platformsJson = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        self.levelUpData = [parser objectWithString:platformsJson];
    
        if(self.levelUpData == nil)
        {
            NSLog(@"Error parsing JSON file %@", [error localizedDescription]);
            NSException *exception = [NSException exceptionWithName:@"JSONException"
                                                             reason:[NSString stringWithFormat:@"Info: %@",
                                                                     [error localizedDescription]]
                                                           userInfo:nil];
            [exception raise];
        }
    
        NSLog(@"-- dataSource ready --");
    }
    return self;
}

-(void) loadUserState
{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    
    if([prefs boolForKey:@"userFlag"] == NO) return;
    
    self.user.fbid              = [prefs stringForKey:@"fbid"];
    self.user.hasRated          = [prefs boolForKey:@"hasRated"];
    self.user.twitterEnabled    = [prefs boolForKey:@"twitterEnabled"];
    self.user.facebookEnabled   = [prefs boolForKey:@"facebookEnabled"];
    self.user.foursquareEnabled = [prefs boolForKey:@"foursquareEnabled"];
    
    self.user.karmaPoints       = [prefs integerForKey:@"karmaPoints"];
    self.user.greenKarma        = [prefs integerForKey:@"greenKarma"];
    self.user.socialKarma       = [prefs integerForKey:@"socialKarma"];
    self.user.beautyKarma       = [prefs integerForKey:@"beautyKarma"];
    self.user.healthKarma       = [prefs integerForKey:@"healthKarma"];
    self.user.totalKarma        = [prefs integerForKey:@"totalKarma"];
    
    self.user.level             = [prefs integerForKey:@"level"];
}

-(void) saveState
{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setBool:true forKey:@"userFlag"];
    [prefs setObject:self.user.fbid forKey:@"fbid"];
    [prefs setBool:self.user.hasRated forKey:@"hasRated"];
    [prefs setBool:self.user.twitterEnabled forKey:@"twitterEnabled"];
    [prefs setBool:self.user.facebookEnabled forKey:@"facebookEnabled"];
    [prefs setBool:self.user.foursquareEnabled forKey:@"foursquareEnabled"];
    [prefs setInteger:self.user.karmaPoints forKey:@"karmaPoints"];
    [prefs setInteger:self.user.greenKarma forKey:@"greenKarma"];
    [prefs setInteger:self.user.beautyKarma forKey:@"beautyKarma"];
    [prefs setInteger:self.user.socialKarma forKey:@"socialKarma"];
    [prefs setInteger:self.user.healthKarma forKey:@"healthKarma"];
    [prefs setInteger:self.user.totalKarma forKey:@"totalKarma"];
    [prefs setInteger:self.user.level forKey:@"level"];
    
    [prefs synchronize];
}

@end
