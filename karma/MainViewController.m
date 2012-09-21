//
//  MainViewController.m
//  karma
//
//  Created by Faridh Mendoza on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "KarmaController.h"
#import "SocialHelper.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize loginButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    aButton.frame = CGRectMake(60, 225, 200, 30);
//    [aButton setTitle:@"Login" forState:UIControlStateNormal];
//    [aButton addTarget:self action:@selector(loginWithFacebook) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:aButton];
}

- (IBAction)loginButtonPressed:(id)sender forEvent:(UIEvent *)event 
{
    [self loginWithFacebook];
}

- (void)viewDidUnload
{
    [self setLoginButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void) loginWithFacebook
{
    NSLog(@"Login with Facebook");
    if ( ![[SocialHelper sharedSocialHelper] checkFacebook] ) 
    {
        return;
    }
    else
    {
        [[SocialHelper sharedSocialHelper] getUserLikes];
        [self performSegueWithIdentifier:@"enterTabbedAppSegue" sender:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


- (void)dealloc {
    [loginButton release];
    [super dealloc];
}
@end
