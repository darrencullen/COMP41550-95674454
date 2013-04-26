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
    @try{
        [super viewDidLoad];
        
        // start recording current location
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if ([self.title isEqualToString:@"Directions"]){
            NSMutableArray *toolbarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];

            if (![toolbarButtons containsObject:self.directionsButton]) {
                [toolbarButtons addObject:self.directionsButton];
                [self.navigationItem setRightBarButtonItems:toolbarButtons animated:YES];
            }
        } else {
            NSMutableArray *toolbarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
            [toolbarButtons removeObject:self.directionsButton];
            [self.navigationItem setRightBarButtonItems:toolbarButtons animated:YES];
        }
        self.textView.text = self.details;
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

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
    @try{
        if (newLocation != nil) {
            currentLocation.latitude = newLocation.coordinate.latitude;
            currentLocation.longitude = newLocation.coordinate.longitude;
            
            [locationManager stopUpdatingLocation];
        }
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try{
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
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
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
