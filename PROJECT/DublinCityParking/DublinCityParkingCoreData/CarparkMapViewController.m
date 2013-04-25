//
//  CarparkMapViewController.m
//  DublinCityParking
//
//  Created by darren cullen on 26/02/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import "CarparkMapViewController.h"
#import "CarparkDetailsViewController.h"
#import "MapOverlay.h"
#import "WebViewController.h"
#import <BugSense-iOS/BugSenseController.h>

@implementation CarparkMapViewController{
    CarparkDetails *selectedCarparkDetails;
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
        
        self.title = self.selectedCarparkInfo.name;
        selectedCarparkDetails = self.selectedCarparkInfo.details;
        _mapView.delegate = self;
        
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = selectedCarparkDetails.latitude;
        zoomLocation.longitude= selectedCarparkDetails.longitude;
        
        MKCoordinateSpan span;
        span.latitudeDelta=0.008;             
        span.longitudeDelta=0.008;
        
        MKCoordinateRegion region;
        region.center=zoomLocation;   
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
    [self plotCarparkPosition];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    @try{
        static NSString *identifier = @"CarparkMapOverlay";
        if ([annotation isKindOfClass:[MapOverlay class]]) {
            
            MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            if (annotationView == nil) {
                annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            } else {
                annotationView.annotation = annotation;
            }
            
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if (self.selectedCarparkInfo.favourite == 1)
                [leftButton setImage:[UIImage imageNamed:@"StarFull24-3.png"] forState:UIControlStateNormal];
            else
                [leftButton setImage:[UIImage imageNamed:@"StarEmpty24-3.png"] forState:UIControlStateNormal];
            
            [leftButton setTitle:annotation.title forState:UIControlStateNormal];
            leftButton.frame = CGRectMake(0, 0, 32, 32);
            leftButton.tag = 1;
            annotationView.leftCalloutAccessoryView = leftButton;
            
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
            [self setFavouriteCarpark];
            
        } else if(control.tag == 2) {
            [self performSegueWithIdentifier:@"showCarparkDirections" sender:self];
        }
        
        [self plotCarparkPosition];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
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

- (void)plotCarparkPosition{
    @try{
        for (id<MKAnnotation> annotation in self.mapView.annotations) {
            [_mapView removeAnnotation:annotation];
        }
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = selectedCarparkDetails.latitude;
        coordinate.longitude = selectedCarparkDetails.longitude;
        
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.008;
        span.longitudeDelta = 0.008;
        region.span = span;
        region.center = coordinate;
        
        MapOverlay *annotation = [[MapOverlay alloc] initWithName:self.selectedCarparkInfo.name subTitle:self.selectedCarparkInfo.address titleAddendum:self.selectedCarparkInfo.availableSpaces coordinate:coordinate];
        
        [self.mapView addAnnotation:annotation];
        [self.mapView setRegion:region animated:YES];
        [self.mapView regionThatFits:region];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)setFavouriteCarpark {
    @try{
        // set up the managedObjectContext to read data from CoreData
        id delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CarparkInfo"
                                                  inManagedObjectContext:self.managedObjectContext];
        
        
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"code=%@",self.selectedCarparkInfo.code]];
        
        NSError *error;
        CarparkInfo *cgCarpark;
        
        cgCarpark = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
        
        NSString *alertMessage;
        if (cgCarpark.favourite == NO){
            cgCarpark.favourite = 1;
            alertMessage = @"Added to favourites list";
        } else {
            cgCarpark.favourite = 0;
            alertMessage = @"Removed from favourites list";
        }
        
        error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSException* locationManagerException = [NSException
                                                     exceptionWithName:@"CarparkMapViewController.setFavouriteCarpark.errorSaving"
                                                     reason:@"Failed to save favourite setting"
                                                     userInfo:nil];
            
            BUGSENSE_LOG(locationManagerException, nil);
            
        } else {       
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:NSLocalizedString(self.selectedCarparkInfo.name, @"AlertView")
                                      message:NSLocalizedString(alertMessage, @"AlertView")
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"OK", @"AlertView")
                                      otherButtonTitles:nil, nil];
            [alertView show];
            
            [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:2];
        }
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

-(void)dismissAlertView:(UIAlertView*)favouritesUpdateAlert
{
	[favouritesUpdateAlert dismissWithClickedButtonIndex:-1 animated:YES];
}


- (IBAction)showCarparkDetails:(id)sender {
    [self performSegueWithIdentifier:@"showCarparkDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try{
        if([segue.identifier isEqualToString:@"showCarparkDetails"]){
            
            CarparkDetailsViewController *destViewController = segue.destinationViewController;
            destViewController.selectedCarparkInfo = self.selectedCarparkInfo;
            
            UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style: UIBarButtonItemStyleBordered target: nil action: nil];
            
            [[self navigationItem] setBackBarButtonItem: newBackButton];
            
        } else if([segue.identifier isEqualToString:@"showCarparkDirections"]){
            
            NSString *directionsURL;
            
            if ((currentLocation.latitude == 0) || (currentLocation.longitude == 0)){
                directionsURL = [NSString stringWithFormat:@"http://maps.google.com/?daddr=%1.6f,%1.6f",self.selectedCarparkInfo.details.latitude, self.selectedCarparkInfo.details.longitude];
            } else {
                directionsURL = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",currentLocation.latitude, currentLocation.longitude, self.selectedCarparkInfo.details.latitude, self.selectedCarparkInfo.details.longitude];
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
        self.mapView = nil;
    }
}


@end
