//
//  SocialHelper.h
//  karma
//
//  Created by Faridh Mendoza on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "FBConnect.h"
#import "BZFoursquare.h"

#define fsqSearchQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define fsqClientId @"XJCMI0DEA3Q20SRIYELQZFZ3TTUU4JIP5YWZBDIMV2ZXSYRN"
#define fsqClientSecret @"YRKNF0IJFV0DGSK244AYMHSA1S340BT3BGAIGL4P4BXA0J0I"
#define fsqCallbackURL @"http://karma.ikistudio.com"

@interface SocialHelper : NSObject <BZFoursquareRequestDelegate, BZFoursquareSessionDelegate, FBSessionDelegate, FBDialogDelegate, FBRequestDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
{
    BZFoursquare        *foursquare_;
    BZFoursquareRequest *request_;
    NSString *currentMethod;
    NSString *currentText;
    NSString *receivedString;
    NSMutableData *receivedData;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;

}
@property(nonatomic,readwrite,strong) BZFoursquare *foursquare;
@property(nonatomic,strong) BZFoursquareRequest *request;
@property (nonatomic, retain) Facebook *facebook;

@property int score;
@property (copy, readonly) NSString *receivedString;
@property (nonatomic, assign) NSMutableData *receivedData;
@property (readwrite, retain) UIImage *currentImage;

+(SocialHelper*)sharedSocialHelper;

-(void) postToFacebookMessage:(NSString*)message andImage:(UIImage *)image;
-(void) postToTwitterMessage:(NSString*)message andImage:(UIImage *)image;
-(void) postToFoursquareMessage:(NSString*)message andImage:(UIImage *)image;
-(void) rateApp;

-(BOOL) checkFacebook;
- (BOOL)handleOpenUrl:(NSURL *)url;
-(void) getUserLikes;

@end
