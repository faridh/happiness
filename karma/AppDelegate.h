//
//  AppDelegate.h
//  karma
//
//  Created by Faridh Mendoza on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KarmaController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readwrite, retain) KarmaController *karmaController;

@end
