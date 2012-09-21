//
//  FirstViewController.m
//  karma
//
//  Created by Faridh Mendoza on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize shareButton;

- (IBAction)shareButtonPressed:(id)sender 
{
    [self performSegueWithIdentifier:@"enterShareScene" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setShareButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc {
    [shareButton release];
    [super dealloc];
}
@end
