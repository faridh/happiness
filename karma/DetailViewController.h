//
//  DetailViewController.h
//  karma
//
//  Created by Faridh Mendoza on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPoint.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define fsqClientId @"XJCMI0DEA3Q20SRIYELQZFZ3TTUU4JIP5YWZBDIMV2ZXSYRN"
#define fsqClientSecret @"YRKNF0IJFV0DGSK244AYMHSA1S340BT3BGAIGL4P4BXA0J0I"

@interface DetailViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UISplitViewControllerDelegate>
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;
    int currenDist;
}

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (retain, nonatomic) IBOutlet UILabel *categoryLabel;
@property (retain, nonatomic) IBOutlet UINavigationItem *detailTitle;
@property (retain, nonatomic) IBOutlet MKMapView *detailMap;

@end