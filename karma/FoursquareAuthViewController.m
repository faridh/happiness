//
//  FoursquareAuthViewController.m
//  karma
//
//  Created by Faridh Mendoza on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FoursquareAuthViewController.h"

#define fsqClientId @"XJCMI0DEA3Q20SRIYELQZFZ3TTUU4JIP5YWZBDIMV2ZXSYRN"
#define fsqCallbackURL @"http://karma.ikistudio.com"

@interface FoursquareAuthViewController ()

@property (nonatomic, readwrite, retain) UIWebView *webView;

@end

@implementation FoursquareAuthViewController

@synthesize webView = _webView;

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 220)];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView = [[[UIWebView alloc] initWithFrame:self.view.bounds] autorelease];
    [[[self.webView subviews] lastObject] setBounds:self.view.bounds];
    [[[self.webView subviews] lastObject] setBounces:YES];
    self.webView.delegate = self;
    NSString *authenticateURLString = [NSString stringWithFormat:@"https://foursquare.com/oauth2/authenticate?client_id=%@&response_type=token&redirect_uri=%@", fsqClientId, fsqCallbackURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authenticateURLString]];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView = nil; 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Web view delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType 
{
    if ([request.URL.scheme isEqualToString:@"itms-apps"]) 
    {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
    NSString *URLString = [[self.webView.request URL] absoluteString];
    NSLog(@"--> URL:%@", URLString);
    
    if ([URLString rangeOfString:@"access_token="].location != NSNotFound) 
    {
        NSString *accessToken = [[URLString componentsSeparatedByString:@"="] lastObject];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:accessToken forKey:@"access_token"];
        [defaults synchronize];
        [self dismissModalViewControllerAnimated:YES];
    }
}

@end
