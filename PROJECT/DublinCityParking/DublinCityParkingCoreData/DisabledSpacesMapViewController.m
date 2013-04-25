//
//  DisabledSpacesMapViewController.m
//  DublinCityParking
//
//  Created by darren cullen on 12/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import "DisabledSpacesMapViewController.h"
#import "MapOverlay.h"
#import "WebViewController.h"
#import <BugSense-iOS/BugSenseController.h>

@interface DisabledSpacesMapViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@end


@implementation DisabledSpacesMapViewController{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentLocation;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    @try{
        [super viewDidLoad];

        // start recording current location
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        self.title = self.selectedDisabledSpace.street; 
        _mapView.delegate = self;
        
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = [self.selectedDisabledSpace.latitude doubleValue];
        zoomLocation.longitude= [self.selectedDisabledSpace.longitude doubleValue];
         
        MKCoordinateRegion region;
        region.center=zoomLocation;   
        MKCoordinateSpan span;
        span.latitudeDelta=0.008;              
        span.longitudeDelta=0.008;
        region.span=span;
        [self.mapView setRegion:region animated:YES];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [locationManager startUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self plotDisabledSpacePosition];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    @try{
        static NSString *identifier = @"DisabledSpaceMapOverlay";
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

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    @try{
        if (control.tag == 1){
//            [self setFavouriteCarpark];
            
        } else if(control.tag == 2) {
            [self performSegueWithIdentifier:@"showDisabledSpaceDirections" sender:self];
        }
        
        [self plotDisabledSpacePosition];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSException* locationManagerException = [NSException
                                             exceptionWithName:@"DisabledSpacesMapViewController.locationManager.didFailWithError"
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

- (void)plotDisabledSpacePosition{
    @try{
        for (id<MKAnnotation> annotation in self.mapView.annotations) {
            [_mapView removeAnnotation:annotation];
        }
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [self.selectedDisabledSpace.latitude doubleValue];
        coordinate.longitude= [self.selectedDisabledSpace.longitude doubleValue];
        
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.008;
        span.longitudeDelta = 0.008;
        region.span = span;
        region.center = coordinate;
        
        NSString *numbersOfSpaces = [NSString stringWithFormat:@"Disabled Spaces: %@",self.selectedDisabledSpace.spaces];
        
        MapOverlay *annotation = [[MapOverlay alloc] initWithName:self.selectedDisabledSpace.street subTitle:numbersOfSpaces titleAddendum:nil coordinate:coordinate];
        [_mapView addAnnotation:annotation];
        
        [self.mapView addAnnotation:annotation];
        [self.mapView setRegion:region animated:YES];
        [self.mapView regionThatFits:region];
    
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (IBAction)showDisabledSpacesDirections:(id)sender {
    [self performSegueWithIdentifier:@"showDisabledSpaceDirections" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try{
        if([segue.identifier isEqualToString:@"showDisabledSpaceDirections"]){
            
            NSString *directionsURL;
            
            if ((currentLocation.latitude == 0) || (currentLocation.longitude == 0)){
                directionsURL = [NSString stringWithFormat:@"http://maps.google.com/?daddr=%1.6f,%1.6f",[self.selectedDisabledSpace.latitude doubleValue], [self.selectedDisabledSpace.longitude doubleValue]];
            } else {
                directionsURL = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",currentLocation.latitude, currentLocation.longitude, [self.selectedDisabledSpace.latitude doubleValue], [self.selectedDisabledSpace.longitude doubleValue]];
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
        self.mapView = nil;
    }
}

@end
