//
//  CarparkDetalsDescriptionViewController.m
//  DublinCityParking
//
//  Created by darren cullen on 14/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import "CarparkDetalsDescriptionViewController.h"
#import "WebViewController.h"
#import <BugSense-iOS/BugSenseController.h>

@interface CarparkDetalsDescriptionViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation CarparkDetalsDescriptionViewController{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentLocation;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [locationManager startUpdatingLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // start recording current location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
   
//    self.details = [self.details stringByReplacingOccurrencesOfString: @";" withString: @"\n"];
    
    if ([self.title isEqualToString:@"Directions"]){
        // Get the reference to the current toolbar buttons
        NSMutableArray *toolbarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
    
        // This is how you add the button to the toolbar and animate it
        if (![toolbarButtons containsObject:self.directionsButton]) {
            [toolbarButtons addObject:self.directionsButton];
            [self.navigationItem setRightBarButtonItems:toolbarButtons animated:YES];
        }
    } else {
        // Get the reference to the current toolbar buttons
        NSMutableArray *toolbarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
        
        // This is how you remove the button from the toolbar and animate it
        [toolbarButtons removeObject:self.directionsButton];
        [self.navigationItem setRightBarButtonItems:toolbarButtons animated:YES];
    }
    self.textView.text = self.details;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSException* locationManagerException = [NSException
                                             exceptionWithName:@"CarparkMapViewController.locationManager.didFailWithError"
                                             reason:@"Failed to Get Your Location"
                                             userInfo:nil];
    
    BUGSENSE_LOG(locationManagerException, nil);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (newLocation != nil) {
        currentLocation.latitude = newLocation.coordinate.latitude;
        currentLocation.longitude = newLocation.coordinate.longitude;
        
        NSLog(@"Current location: latitude=%.8f; longitude=%.8f",currentLocation.latitude,currentLocation.longitude);
        [locationManager stopUpdatingLocation];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"showCarparkDirections"]){
        
        NSString *directionsURL;
        
        if ((currentLocation.latitude == 0) || (currentLocation.longitude == 0)){
            directionsURL = [NSString stringWithFormat:@"http://maps.google.com/?daddr=%1.6f,%1.6f",self.carparkLocationLatitude, self.carparkLocationLongitude];
        } else {
            directionsURL = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",currentLocation.latitude, currentLocation.longitude, self.carparkLocationLatitude, self.carparkLocationLongitude];
        }
        
        WebViewController *destViewController = segue.destinationViewController;
        destViewController.url = directionsURL;
        destViewController.title = self.title;
        destViewController.hideNavigationToolbar = YES;
        
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style: UIBarButtonItemStyleBordered target: nil action: nil];
        
        [[self navigationItem] setBackBarButtonItem: newBackButton];
    }
}

- (IBAction)getDirections:(id)sender {
    [self performSegueWithIdentifier:@"showCarparkDirections" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && [self.view window] == nil) {
        self.view = nil;
        self.managedObjectContext = nil;
        self.textView = nil;
    }
}
@end
