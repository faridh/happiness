//
//  DetailViewController.m
//  karma
//
//  Created by Faridh Mendoza on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize categoryLabel = _categoryLabel;
@synthesize detailTitle = _detailTitle;
@synthesize detailMap = _detailMap;
@synthesize masterPopoverController = _masterPopoverController;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) 
    {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) 
    {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) 
    {
        self.detailTitle.title = [self.detailItem objectForKey:@"name"];
        self.detailDescriptionLabel.text = [self.detailItem description];
        self.categoryLabel.text = [self.detailItem objectForKey:@"category"];
        if ( [self.detailItem objectForKey:@"name"] != nil )
        {
            [self queryFoursquarePlaces:[self.detailItem objectForKey:@"name"]];
        }
    }
}

-(void) queryFoursquarePlaces: (NSString *) fsqType 
{
    
    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=19.369869,-99.01427&client_id=%@&client_secret=%@&v=20120814", fsqClientId, fsqClientSecret];
    
    //Formulate the string as a URL object.
    NSURL *fsqRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL: fsqRequestURL];
        //NSLog(@"%f,%f", currentCentre.latitude, currentCentre.longitude);
        NSLog(url);
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

-(void)fetchedData:(NSData *) responseData 
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
    //NSLog(@"Foursquare Data: %@", places);
    [self plotPositions:places];
}

-(void)plotPositions:(NSArray *)data 
{
    // 1 - Remove any existing custom annotations but not the user location blue dot.
    for (id<MKAnnotation> annotation in self.detailMap.annotations) 
    {
        if ([annotation isKindOfClass:[MapPoint class]]) 
        {
            [self.detailMap removeAnnotation:annotation];
        }
    }
    // 2 - Loop through the array of places returned from the Google API.
    for (NSObject *place in data) 
    {

        // 3 - There is a specific NSDictionary object that gives us the location info.
        NSObject *location = [place objectForKey:@"location"];
    
        // 4 - Get your name and address info for adding to a pin.
        NSString *name      = [place objectForKey:@"name"];
        NSString *vicinity  = [location objectForKey:@"address"];
    
        // Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
    
        // Set the lat and long.
        placeCoord.latitude     = [[location objectForKey:@"lat"] doubleValue];
        placeCoord.longitude    = [[location objectForKey:@"lng"] doubleValue];
        
        // 5 - Create a new annotation.
        MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:vicinity coordinate:placeCoord];
    
        [self.detailMap addAnnotation:placeObject];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailMap.delegate = self;
    [self.detailMap setShowsUserLocation:YES];
    
    //Instantiate a location object.
    locationManager = [[CLLocationManager alloc] init];
    
    //Make this controller the delegate for the location manager.
    [locationManager setDelegate:self];
    
    //Set some parameters for the location object.
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [self setCategoryLabel:nil];
    [self setDetailTitle:nil];
    [self setDetailMap:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"LikeTab", @"LikeTab");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - MKMapViewDelegate methods. 
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views 
{    
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate, 1000000, 1000000);
    [mv setRegion:region animated:YES];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //Get the east and west points on the map so you can calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = self.detailMap.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set your current distance instance variable.
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    //Set your current center point on the map instance variable.
    currentCentre = self.detailMap.centerCoordinate;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation 
{
    // Define your reuse identifier.
    static NSString *identifier = @"MapPoint";   
    
    if ([annotation isKindOfClass:[MapPoint class]]) 
    {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.detailMap dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) 
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } 
        else 
        {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    return nil;    
}

- (void)dealloc {
    [_categoryLabel release];
    [_detailTitle release];
    [_detailMap release];
    [super dealloc];
}
@end
