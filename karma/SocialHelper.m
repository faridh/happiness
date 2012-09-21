//
//  SocialHelper.m
//  karma
//
//  Created by Faridh Mendoza on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "SocialHelper.h"
#import "KarmaController.h"
#import "LikeTableViewController.h"

@implementation SocialHelper

@synthesize facebook;
@synthesize foursquare = foursquare_;
@synthesize request = request_;

@synthesize score;
@synthesize receivedData;
@synthesize receivedString;
@synthesize currentImage;


static SocialHelper* _sharedSocialHelper = nil;

+(SocialHelper*)sharedSocialHelper
{
	@synchronized([SocialHelper class])
	{
        if (!_sharedSocialHelper)
            [[self alloc] init];
    
        return _sharedSocialHelper;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([SocialHelper class])
	{
        NSAssert(_sharedSocialHelper == nil, @"[SocialHelper] Attempted to allocate a second instance of a singleton.");
        _sharedSocialHelper = [super alloc];
        return _sharedSocialHelper;
	}
	return nil;
}

-(id)dealloc
{
    foursquare_.sessionDelegate = nil;
}

-(id) init
{
    if(self = [super init]) 
    {            
        currentMethod   = @"publishGoodKarma";
        currentText     = @"";
        currentImage    = nil;
        receivedString  = @"";
        receivedData    = [[NSMutableData alloc] init];
        score           = 0;
        
        self.foursquare = [[BZFoursquare alloc] initWithClientID:fsqClientId callbackURL:fsqCallbackURL];
        foursquare_.version = @"20120909";
        foursquare_.locale = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
        foursquare_.sessionDelegate = self;
        
        //Instantiate a location object.
        locationManager = [[CLLocationManager alloc] init];
        
        //Make this controller the delegate for the location manager.
        [locationManager setDelegate:self];
        
        //Set some parameters for the location object.
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=19.369869,-99.01427&client_id=%@&client_secret=%@&v=20120909", fsqClientId, fsqClientSecret];
        
        //Formulate the string as a URL object.
        NSURL *fsqRequestURL=[NSURL URLWithString:url];
        
        // Retrieve the results of the URL.
        dispatch_async(fsqSearchQueue, ^{
            NSData *data = [NSData dataWithContentsOfURL: fsqRequestURL];
            //NSLog(@"%f,%f", currentCentre.latitude, currentCentre.longitude);
            //NSLog(url);
            [self performSelectorOnMainThread:@selector(fsqSearchResults:) withObject:data waitUntilDone:YES];
        });
        NSLog(@"[SocialHelper init]");
    }
    return self;
}

-(void)fsqSearchResults:(NSData *) responseData 
{
    //parse out the JSON data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData 
                          
                          options:kNilOptions 
                          error:&error];
    
    //The results from FSQ will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [[json objectForKey:@"response"] objectForKey:@"venues"]; 
    
    //Write out the data to the console.
    // NSLog(@"Foursquare Data: %@", places);
    NSLog(@"-- ADDING FSQ NEARBY PLACES --");
    for (NSObject *place in places) 
    {        
        NSObject *location  = [place objectForKey:@"location"];        
        NSString *name      = [place objectForKey:@"name"];
        NSString *vicinity  = [location objectForKey:@"address"];
        [[KarmaController sharedController].user.nearbyLocations addObject:place];
        // NSLog(name);
    }
}

-(void) postToFacebookMessage:(NSString *)message andImage:(UIImage *) image
{
    if(![self checkFacebook]) return;
    
    if ( [message isEqualToString:@""] )
        message = @"I'm using GoodKarma!";
    
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        image, @"source",
                                        message, @"message",
                                        message, @"name",
                                        @"Join me!", @"caption",
                                        @"Spread the word and share GoodKarma with your friends!", @"description",
                                        [NSString stringWithFormat:@"http://www.goodkarmaapp.com/?ref=fbPost&subType=%@", currentMethod], @"link",
                                        nil];
    
//    NSLog(@"About to post as %@", [KarmaController sharedController].user.fbid);
//    [facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/feed", [KarmaController sharedController].user.fbid] andParams:params andHttpMethod:@"POST" andDelegate:self];
    [facebook requestWithGraphPath:@"me/photos" andParams:params andHttpMethod:@"POST" andDelegate:self];

}

-(void) postToTwitterMessage:(NSString *)message andImage:(UIImage *)image
{
    if( [TWTweetComposeViewController canSendTweet] )
    {
        ACAccountStore *store       = [[ACAccountStore alloc] init];
        ACAccountType *twitterType  = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        NSString *finalMessage      = [NSString alloc];
        UIImage *finalImage         = image;
        
        if ( [message isEqualToString:@""] )
            finalMessage = @"Come and share #happyKarma with me! ";
        else
            finalMessage = message;
        //[NSString stringWithFormat:@"Come and share #goodKarma with me! / http://www.goodkarmaapp.com/?ref=iosTweet&subType=%@", currentMethod]
    
        [store requestAccessToAccountsWithType:twitterType withCompletionHandler:^(BOOL granted, NSError *error) 
        {
            
            NSArray *accounts = [store accountsWithAccountType:twitterType];
            NSURL *url = [NSURL URLWithString:@"https://upload.twitter.com/1/statuses/update_with_media.json"];
            NSData *imageData = UIImagePNGRepresentation(finalImage);
        
            // NSLog(@"About to tweet %@",[dict objectForKey:@"status"]);
                             
            TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:nil requestMethod:TWRequestMethodPOST];
                             
            //  Use the first account for simplicity
            [request setAccount:[accounts objectAtIndex:0]];
            
            //  Add the data of the image with the 
            //  correct parameter name, "media[]"
            [request addMultiPartData:imageData withName:@"media[]" type:@"multipart/form-data"];
        
            // NB: Our status must be passed as part of the multipart form data            
            //  Add the data of the status as parameter "status"
            [request addMultiPartData:[finalMessage dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"multipart/form-data"];

            [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) 
            {
                                  
                if (responseData) 
                {
                    // id data = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
                    
                    //  Print out the response.  
                    //  You can verify that the "text" of the status is now t.co'd.
                    //NSLog(@"%@", data);
                
                    if([currentMethod isEqualToString:@"publishGoodKarma"])
                    {
                        NSLog(@"Tweet posted -- publishGoodKarma()");
                    }
                }
            }];     
        }];
    }
    else 
    {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Twitter not configured!" 
                              message:@"Please verify that you have a Twitter account configured in this device and internet access." 
                              delegate:self
                              cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
        [alert show];
    }
}

-(void) postToFoursquareMessage:(NSString *)message andImage:(UIImage *)image
{
    NSLog(@"postToFoursquare");
    self.currentImage = image;
    
    if ( [message isEqualToString:@""] )
        message = @"Come and share HappyKarma with me!";
    
//    NSData *imageData = UIImageJPEGRepresentation(image, 100);
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    NSString *checkinURLString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/checkins/add"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:checkinURLString]];
//    
//    NSString *params = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"oauth_token=%@&broadcast=private&venueId=%@&shout=%@&v=20120909", [defaults stringForKey:@"access_token"], @"501589d5e4b0c79e48c56fa8", message]];
//    
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
//    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //[self addPhoto:image];

}

- (void)cancelRequest 
{
    if (request_) {
        request_.delegate = nil;
        [request_ cancel];
        self.request = nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)prepareForRequest 
{
    [self cancelRequest];
}

- (void)addPhoto:(UIImage *)image 
{
    [self prepareForRequest];
    NSData *imageData = UIImageJPEGRepresentation(image, 100);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                imageData, @"photo.jpg",
                                @"501589d5e4b0c79e48c56fa8", @"venueId", 
                                [defaults stringForKey:@"access_token"], @"oauth_token", nil];
    self.request = [foursquare_ requestWithPath:@"photos/add" HTTPMethod:@"POST" parameters:parameters delegate:self];
    [request_ start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


//#pragma mark -
//#pragma mark BZFoursquareRequestDelegate
//
//- (void)requestDidFinishLoading:(BZFoursquareRequest *)request 
//{
//    NSDictionary *meta = request.meta;
//    NSArray *notifications = request.notifications;
//    NSDictionary *response = request.response;
//    
//    NSLog(@"Response %@", response);
//    self.request = nil;
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//}
//
//- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error {
//    NSDictionary *meta = request.meta;
//    NSArray *notifications = request.notifications;
//    NSDictionary *response = request.response;
//    
//    NSLog(@"Error %@", response);
//    self.request = nil;
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Discard all previously received data.
    [receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the receivedData.
    [receivedData appendData:data];     
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"-- connectionDidFinishLoading --");
    NSString *responseText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"Response:%@", responseText);
}

-(void) getUserLikes
{
    if(![self checkFacebook]) return;
    [facebook requestWithGraphPath:@"me/likes" andDelegate:self];
}

-(BOOL) checkFacebook
{
    NSLog(@"-- FB CHECK --");
    facebook = [[Facebook alloc] initWithAppId:@"450756228297419" andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) 
    {
        NSLog(@"Valid Token");
        facebook.accessToken    = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if (![facebook isSessionValid]) 
    {
        NSLog(@"Invalid Session");
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream", @"user_likes", @"user_activities",
                                @"user_birthday", @"user_checkins", @"user_interests",
                                @"user_religion_politics",
                                nil];
        [facebook authorize:permissions];
        [permissions release];
        return false;
        
    }
    return true;
}

- (BOOL)handleOpenUrl:(NSURL *)url
{
    return [facebook handleOpenURL:url]; 
}

- (void)fbDidLogin 
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    // [Analytics track:@"Facebook Login Granted"];
    
    //Get user id
    [facebook requestWithGraphPath:@"me" andDelegate:self];
    
}

// Method that gets called when the request dialog button is pressed
- (void) requestDialogButtonClicked 
{
    NSMutableDictionary* params = 
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"invites you to check out cool stuff",  @"message",
     @"Check this out", @"notification_text",
     nil];  
    [facebook dialog:@"apprequests"
           andParams:params
         andDelegate:self];
}

// FBDialogDelegate
- (void)dialogDidComplete:(FBDialog *)dialog 
{
    NSLog(@"dialog completed successfully");
    // [Analytics track:@"FB Share"];
    
}

-(void) rateApp
{
    // [Analytics track:@"App Rating Intent"];
    // [[MaverickGame sharedMaverickGame] updateGUIfromThread];
    // [MaverickGame sharedMaverickGame].player.hasRated = true;
    // [Appirater rateApp];
}

//FB REQUEST DELEGATE
- (void)requestLoading:(FBRequest *)request
{
    
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"GRAPH REQUEST ERROR %@", error);    
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    //NSLog(@"GRAPH REQUEST SUCCESS %@ %@", [request url], result);
    if( [[request url] rangeOfString:@"/me"].location == NSNotFound )
    {
        if([currentMethod isEqualToString:@"publishGoodKarma"])
        {
            // [Analytics track:@"Facebook Score Share"];
            NSLog(@"FB post -- publishGoodKarma()");
        }
    }
    //getting user data
    else 
    {
        if( [[request url] rangeOfString:@"/me/likes"].location == NSNotFound )
        {
            [KarmaController sharedController].user.fbid = [NSString stringWithFormat:@"%@", [result objectForKey:@"id"]];
            [[KarmaController sharedController] saveState];
        }
        else 
        {
            NSLog(@"URL LIKES");
            [KarmaController sharedController].user.userLikes = [result objectForKey:@"data"];
            //[[LikeTableViewController sharedLikeTableViewController].tableView reloadData];
        }
    }
    
}

- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{
    
}
@end
