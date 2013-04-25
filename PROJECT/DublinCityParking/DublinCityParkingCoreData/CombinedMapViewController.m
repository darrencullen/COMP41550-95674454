//
//  CombinedMapViewController.m
//  DublinCityParking
//
//  Created by darren cullen on 15/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import "CombinedMapViewController.h"
#import "MapOverlay.h"
#import "CarparkInfo.h"
#import "CarparkDetails.h"
#import "DisabledParkingSpaceInfo.h"
#import "TrafficCameraInfo.h"
#import "WebViewController.h"
#import <BugSense-iOS/BugSenseController.h>

@interface CombinedMapViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *carparkLocations;
@property (nonatomic, strong) NSArray *disabledParkingLocations;
@property (nonatomic, strong) NSArray *trafficCameraLocations;
@property (nonatomic) CLLocationCoordinate2D selectedAnnotationCoordinate;
@property (nonatomic, strong) NSString *selectedAnnotationTitle;
@end

@implementation CombinedMapViewController{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentLocation;
}


- (void)viewDidLoad
{
    @try{
        [super viewDidLoad];
        
        // start recording current location
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        _mapView.delegate = self;
    
        [self initialiseMap];    
        [self getDisabledParkingDetails];
        [self getTrafficCameraDetails];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    @try{
        if (self.segmentedControlOverlayTypes.selectedSegmentIndex == 0){
            [self getCarparkDetails];
            [self createCarparkOverlays];
        }
        
        [locationManager startUpdatingLocation];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void) resetArrays
{
    self.carparkLocations = nil;
    self.disabledParkingLocations = nil;
    self.trafficCameraLocations = nil;
}

- (void)initialiseMap
{
    @try{
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = 53.34326;
        zoomLocation.longitude = -6.26413;
        
        MKCoordinateRegion region;
        region.center=zoomLocation;
        MKCoordinateSpan span;
        span.latitudeDelta=0.025;
        span.longitudeDelta=0.025;
        region.span=span;
        [self.mapView setRegion:region animated:YES];
        
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)clearOverlays
{
    @try{
        [self.mapView removeAnnotations:[self.mapView annotations]];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)getCarparkDetails
{
    @try{
        // set up the managedObjectContext to read data from CoreData
        id delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CarparkInfo"
                                                  inManagedObjectContext:self.managedObjectContext];
        
        [fetchRequest setEntity:entity];
        NSError *error;
        self.carparkLocations = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)getDisabledParkingDetails
{
    @try{
        // set up the managedObjectContext to read data from CoreData
        id delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"DisabledParkingSpaceInfo"
                                                  inManagedObjectContext:self.managedObjectContext];
        
        
        [fetchRequest setEntity:entity];
        NSError *error;
        self.disabledParkingLocations = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)getTrafficCameraDetails
{
    @try{
        // set up the managedObjectContext to read data from CoreData
        id delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"TrafficCameraInfo"
                                                  inManagedObjectContext:self.managedObjectContext];
        
        
        [fetchRequest setEntity:entity];
        NSError *error;
        self.trafficCameraLocations = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)createCarparkOverlays
{
    @try{
        [self clearOverlays];
        for (CarparkInfo *carpark in self.carparkLocations){
            [self createCarparkOverlay:carpark];
        }
        self.navigationBar.title = @"Carpark Locations";
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)createCarparkOverlay:(CarparkInfo *)carpark
{
    @try{
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = carpark.details.latitude;
        coordinate.longitude= carpark.details.longitude;
        
        NSString *numbersOfSpaces = [NSString stringWithFormat:@"Spaces: %@",carpark.availableSpaces];
        
        MapOverlay *annotation = [[MapOverlay alloc] initWithName:carpark.name subTitle:carpark.address titleAddendum:numbersOfSpaces coordinate:coordinate];
        [_mapView addAnnotation:annotation];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)createDisabledSpaceOverlays
{
    @try{
        [self clearOverlays];
        for (DisabledParkingSpaceInfo *disabledSpace in self.disabledParkingLocations){
            [self createDisabledSpaceOverlay:disabledSpace];
        }
        self.navigationBar.title = @"Disabled Parking Locations";
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)createDisabledSpaceOverlay:(DisabledParkingSpaceInfo *)disabledSpace
{
    @try{
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [disabledSpace.latitude doubleValue];
        coordinate.longitude = [disabledSpace.longitude doubleValue];
        
        NSString *numbersOfSpaces = [NSString stringWithFormat:@"Disabled Spaces: %@",disabledSpace.spaces];
        
        MapOverlay *annotation = [[MapOverlay alloc] initWithName:disabledSpace.street subTitle:numbersOfSpaces titleAddendum:nil coordinate:coordinate];
        [_mapView addAnnotation:annotation];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)createTrafficCameraOverlays
{
    @try{
        [self clearOverlays];
        for (TrafficCameraInfo *trafficCamera in self.trafficCameraLocations){
            [self createTraficCameraOverlay:trafficCamera];
        }
        self.navigationBar.title = @"Traffic Camera Locations";
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)createTraficCameraOverlay:(TrafficCameraInfo *)camera
{
    @try{
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [camera.latitude doubleValue];
        coordinate.longitude = [camera.longitude doubleValue];
        
        MapOverlay *annotation = [[MapOverlay alloc] initWithName:camera.name subTitle:nil titleAddendum:nil coordinate:coordinate];
        [_mapView addAnnotation:annotation];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (IBAction)selectOverlayType:(UISegmentedControl *)sender {
    @try{
        [self plotRequiredOverlays];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)plotRequiredOverlays
{
    @try {
        if (self.segmentedControlOverlayTypes.selectedSegmentIndex == 0){
            [self getCarparkDetails];
            [self createCarparkOverlays];
        } else if (self.segmentedControlOverlayTypes.selectedSegmentIndex == 1){
            [self createDisabledSpaceOverlays];
        } else if (self.segmentedControlOverlayTypes.selectedSegmentIndex == 2){
            [self createTrafficCameraOverlays];
        }
    }
    @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    @try{
        static NSString *identifier = @"CombinedMapOverlay";
        if ([annotation isKindOfClass:[MapOverlay class]]) {
            
            MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            if (annotationView == nil) {
                annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            } else {
                annotationView.annotation = annotation;
            }
            
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            
            //            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            //            if (self.selectedCarparkInfo.favourite == 1)
            //                [leftButton setImage:[UIImage imageNamed:@"StarFull24-3.png"] forState:UIControlStateNormal];
            //            else
            //                [leftButton setImage:[UIImage imageNamed:@"StarEmpty24-3.png"] forState:UIControlStateNormal];
            //
            //            [leftButton setTitle:annotation.title forState:UIControlStateNormal];
            //            leftButton.frame = CGRectMake(0, 0, 32, 32);
            //            leftButton.tag = 1;
            //            annotationView.leftCalloutAccessoryView = leftButton;
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightButton setImage:[UIImage imageNamed:@"directions38.png"] forState:UIControlStateNormal];
            [rightButton setTitle:annotation.title forState:UIControlStateNormal];
            rightButton.frame = CGRectMake(0, 0, 32, 32);
            rightButton.tag = 2;
            annotationView.rightCalloutAccessoryView = rightButton;
            
            return annotationView;
        }
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    @try{
        _selectedAnnotationCoordinate.latitude = view.annotation.coordinate.latitude;
        _selectedAnnotationCoordinate.longitude = view.annotation.coordinate.longitude;

        NSRange range = [view.annotation.title rangeOfString:@"("];
        if (range.location == NSNotFound){
            _selectedAnnotationTitle = view.annotation.title;
        }
        else{
           _selectedAnnotationTitle = [NSString stringWithString :[view.annotation.title substringToIndex:range.location]]; 
        }
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    @try{
        if (control.tag == 1){
            //            [self setFavouriteCarpark];
            
        } else if(control.tag == 2) {
            
            [self performSegueWithIdentifier:@"showDirections" sender:self];
        }
        
        [self plotRequiredOverlays];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSException* locationManagerException = [NSException
                                             exceptionWithName:@"CombinedMapViewController.locationManager.didFailWithError"
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
            
            NSLog(@"Current location: latitude=%.8f; longitude=%.8f",currentLocation.latitude,currentLocation.longitude);
            [locationManager stopUpdatingLocation];
        }
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try{
        if([segue.identifier isEqualToString:@"showDirections"]){
            
            NSString *directionsURL;
            
            if ((currentLocation.latitude == 0) || (currentLocation.longitude == 0)){
                directionsURL = [NSString stringWithFormat:@"http://maps.google.com/?daddr=%1.6f,%1.6f",_selectedAnnotationCoordinate.latitude, _selectedAnnotationCoordinate.longitude];
            } else {
                directionsURL = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",currentLocation.latitude, currentLocation.longitude, _selectedAnnotationCoordinate.latitude, _selectedAnnotationCoordinate.longitude];
            }
            
            WebViewController *destViewController = segue.destinationViewController;
            destViewController.url = directionsURL;
            destViewController.title = _selectedAnnotationTitle;
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
        [self clearOverlays];
        self.mapView = nil;
        [self resetArrays];
        [self setView:nil];
    }
}
@end

