//
//  ShareWindowViewController.m
//  karma
//
//  Created by Faridh Mendoza on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareWindowViewController.h"
#import "KarmaController.h"
#import "SocialHelper.h"

@interface ShareWindowViewController ()

@end

@implementation ShareWindowViewController
@synthesize captionTextfield;
@synthesize foursquareButton;
@synthesize fbShareButton;
@synthesize twShareButton;
@synthesize shareButton;
@synthesize fsShareButton;
@synthesize cameraButton;
@synthesize picImageView;

@synthesize rewardsView;
@synthesize rewardsViewTitle;
@synthesize pointsEarnedLabel;
@synthesize totalPointsLabel;
@synthesize closeRewardsViewButton;

@synthesize levelUpView;

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
	// Do any additional setup after loading the view.
    [self.fbShareButton setImage:[UIImage imageNamed:@"facebookDisabled.png"] forState:UIControlStateNormal];
    [self.fbShareButton setImage:[UIImage imageNamed:@"facebookEnabled.png"] forState:UIControlStateSelected];
    [self.twShareButton setImage:[UIImage imageNamed:@"twitterDisabled.png"] forState:UIControlStateNormal];
    [self.twShareButton setImage:[UIImage imageNamed:@"twitterEnabled.png"] forState:UIControlStateSelected];
    [self.fsShareButton setImage:[UIImage imageNamed:@"foursquareDisabled.png"] forState:UIControlStateNormal];
    [self.fsShareButton setImage:[UIImage imageNamed:@"foursquareEnabled.png"] forState:UIControlStateSelected];
    
    int originX = self.view.bounds.origin.x;
    int originY = self.view.bounds.origin.y;
    int width   = self.view.bounds.size.width;
    int height  = self.view.bounds.size.height;
    // BE CAREFUL WITH THESE VALUES, THEY DIFFER IF ITS LANDSCAPE OR PORTRAIT
    // WE SUSTRACT MANUALLY THE TAB_BAR HEIGHT
    CGRect levelUpRect = CGRectMake((originX + height)/2 - (440/2), (originY + width - 70)/2 - (196/2), 440, 196);
    self.levelUpView = [[UIView alloc] initWithFrame:(levelUpRect)];
    self.levelUpView.backgroundColor = [UIColor redColor];
    self.levelUpView.alpha = 0.0;
    [self.view addSubview:self.levelUpView];
    
    [self configureButtons];
}

-(void) configureButtons
{
    if ( [KarmaController sharedController].user.facebookEnabled )
        [self.fbShareButton setSelected:YES];
    else
        [self.fbShareButton setSelected:NO];
    
    if ( [KarmaController sharedController].user.twitterEnabled )
        [self.twShareButton setSelected:YES];
    else
        [self.twShareButton setSelected:NO];
    
    if ( [KarmaController sharedController].user.foursquareEnabled )
        [self.fsShareButton setSelected:YES];
    else
        [self.fsShareButton setSelected:NO];
    
    [self.shareButton setBackgroundColor:[UIColor colorWithRed:0 green:169 blue:0 alpha:255]];
    [self.shareButton.layer setCornerRadius:7.0];
}

- (IBAction)captionTFChangeEnd:(id)sender 
{
    NSLog(@"captionTFChangeEnded()");
    if ( self.captionTextfield.text.length > 5 )
    {
        NSLog(@"-- must trim captionTextfield.text --");
    }
}

- (IBAction)captionTFChange:(id)sender 
{
    NSLog(@"captionTFChange()");
}

- (IBAction)captionTFDidEndOnExit:(id)sender 
{
    NSLog(@"captionTFDidEndOnExit()");
    [sender resignFirstResponder]; 
}


- (IBAction)foursquareButtonPressed:(id)sender 
{
    NSLog(@"fsqButtonPressed()");
}

- (IBAction)fbSharePressed:(id)sender 
{
    if ( [KarmaController sharedController].user.facebookEnabled )
    {
        [KarmaController sharedController].user.facebookEnabled = FALSE;
        [sender setSelected:NO];
    }
    else
    {
        [KarmaController sharedController].user.facebookEnabled = TRUE;
        [sender setSelected:YES];
    }
    [[KarmaController sharedController] saveState];
}

- (IBAction)twSharePressed:(id)sender 
{
    if ( [KarmaController sharedController].user.twitterEnabled )
    {
        [KarmaController sharedController].user.twitterEnabled = FALSE;
        [sender setSelected:NO];
    }
    else
    {
        [KarmaController sharedController].user.twitterEnabled = TRUE;
        [sender setSelected:YES];
    }
    [[KarmaController sharedController] saveState];
}
- (IBAction)fsSharePressed:(id)sender 
{
    if ( [KarmaController sharedController].user.foursquareEnabled )
    {
        [KarmaController sharedController].user.foursquareEnabled = FALSE;
        [sender setSelected:NO];
    }
    else
    {
        [KarmaController sharedController].user.foursquareEnabled = TRUE;
        [sender setSelected:YES];
    }
    [[KarmaController sharedController] saveState];
}

- (IBAction)shareButtonPressed:(id)sender 
{
    [self.shareButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:169 alpha:255]];
    self.shareButton.titleLabel.textColor = [UIColor colorWithWhite:0 alpha:255];
    int totalCurrentKarma = 0;
    totalCurrentKarma += [[[KarmaController sharedController].rewardData objectForKey:@"hkSharePoints"] intValue];
    
    if ([KarmaController sharedController].user.facebookEnabled)
    {
        [[SocialHelper sharedSocialHelper] postToFacebookMessage:self.captionTextfield.text andImage:picImageView.image];
        totalCurrentKarma += [[[KarmaController sharedController].rewardData objectForKey:@"fbSharePoints"] intValue];
    }
    if ([KarmaController sharedController].user.twitterEnabled)
    {
        [[SocialHelper sharedSocialHelper] postToTwitterMessage:self.captionTextfield.text andImage:picImageView.image];
        totalCurrentKarma += [[[KarmaController sharedController].rewardData objectForKey:@"twSharePoints"] intValue];
    }
          
    if ([KarmaController sharedController].user.foursquareEnabled)
    {
        [[SocialHelper sharedSocialHelper] postToFoursquareMessage:self.captionTextfield.text andImage:picImageView.image];
        totalCurrentKarma += [[[KarmaController sharedController].rewardData objectForKey:@"fsSharePoints"] intValue];
    }
    
    NSString *currentLevel = [NSString stringWithFormat:@"%d", [KarmaController sharedController].user.level];
    NSObject *levelMetadata = [[KarmaController sharedController].levelUpData objectForKey:@"11"];
    int levelUpAt = [[levelMetadata objectForKey:@"levelUpAt"] intValue];
    
    NSLog(@"Current Level: %@", currentLevel);
    NSLog(@"Metadata: %@", levelMetadata); // METADATA CAN NIL
    NSLog(@"LevelUp at: %d", levelUpAt); // (METADATA == NIL) levelUpAt = 0
    
    [KarmaController sharedController].user.totalKarma += totalCurrentKarma;
    totalPointsLabel.text = [NSString stringWithFormat:@"Total Points: %d point(s)", [KarmaController sharedController].user.totalKarma];
    pointsEarnedLabel.text = [NSString stringWithFormat:@"Points earned: %d point(s)", totalCurrentKarma];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.666];
    [UIView setAnimationDelay:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    rewardsView.alpha = 1;
    rewardsViewTitle.alpha = 1;
    pointsEarnedLabel.alpha = 1;
    totalPointsLabel.alpha = 1;
    closeRewardsViewButton.alpha = 1;
    [UIView commitAnimations];
    
    NSLog(@"shareButtonPressed()");
    
}
- (IBAction)closeRewardsView:(id)sender
{
    
    [UIView animateWithDuration:0.666 delay:0.1
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         rewardsView.alpha = 0;
                         rewardsViewTitle.alpha = 0;
                         pointsEarnedLabel.alpha = 0;
                         totalPointsLabel.alpha = 0;
                         closeRewardsViewButton.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [self.navigationController popViewControllerAnimated:YES];
                     }];
}

- (IBAction)useCamera:(id)sender 
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = 
        UIImagePickerControllerSourceTypeCamera;
        
        // TODO: FIX THIS
        // imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        [imagePicker release];
        newMedia = YES;
    }
    else
    {
        NSLog(@"-- CAMERA NOT AVAILABLE --");
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = 
        UIImagePickerControllerSourceTypePhotoLibrary;
    
        // TODO: FIX THIS
        // imagePicker.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        [imagePicker release];
        newMedia = NO;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"LOL image selected");
    [self dismissModalViewControllerAnimated:YES];
    
    // if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) 
    // {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        picImageView.image = image;
        NSLog(@"Set imageView.image");
    
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
    //}
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) 
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)shareButtonPressEnded:(id)sender 
{
    [self.shareButton setBackgroundColor:[UIColor colorWithRed:0 green:169 blue:0 alpha:255]];
    NSLog(@"shareButtonPressEnded()");
}

- (void)viewDidUnload
{
    [self setCaptionTextfield:nil];
    [self setFoursquareButton:nil];
    [self setFbShareButton:nil];
    [self setTwShareButton:nil];
    [self setShareButton:nil];
    [self setFsShareButton:nil];
    [self setCameraButton:nil];
    [self setPicImageView:nil];
    [self setRewardsView:nil];
    [self setCloseRewardsViewButton:nil];
    [self setRewardsViewTitle:nil];
    [self setPointsEarnedLabel:nil];
    [self setTotalPointsLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc 
{
    [captionTextfield release];
    [foursquareButton release];
    [fbShareButton release];
    [twShareButton release];
    [shareButton release];
    [fsShareButton release];
    [cameraButton release];
    [picImageView release];
    [rewardsView release];
    [closeRewardsViewButton release];
    [rewardsViewTitle release];
    [pointsEarnedLabel release];
    [totalPointsLabel release];
    [super dealloc];
}

@end
