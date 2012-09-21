//
//  ShareWindowViewController.h
//  karma
//
//  Created by Faridh Mendoza on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ShareWindowViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL newMedia;
}

@property (retain, nonatomic) IBOutlet UITextField *captionTextfield;
@property (retain, nonatomic) IBOutlet UIButton *foursquareButton;
@property (retain, nonatomic) IBOutlet UIButton *fbShareButton;
@property (retain, nonatomic) IBOutlet UIButton *twShareButton;
@property (retain, nonatomic) IBOutlet UIButton *shareButton;
@property (retain, nonatomic) IBOutlet UIButton *fsShareButton;
@property (retain, nonatomic) IBOutlet UIButton *cameraButton;
@property (retain, nonatomic) IBOutlet UIImageView *picImageView;

@property (retain, nonatomic) IBOutlet UIView *rewardsView;
@property (retain, nonatomic) IBOutlet UILabel *rewardsViewTitle;
@property (retain, nonatomic) IBOutlet UILabel *pointsEarnedLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalPointsLabel;
@property (retain, nonatomic) IBOutlet UIButton *closeRewardsViewButton;

@property (retain, nonatomic) UIView *levelUpView;

- (IBAction)useCamera:(id)sender;

@end
