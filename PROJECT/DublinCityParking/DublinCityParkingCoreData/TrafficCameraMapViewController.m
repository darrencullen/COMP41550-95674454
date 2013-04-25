//
//  TrafficCameraMapViewController.m
//  DublinCityParking
//
//  Created by darren cullen on 13/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import "TrafficCameraMapViewController.h"
#import "MapOverlay.h"
#import "WebViewController.h"
#import <BugSense-iOS/BugSenseController.h>

@interface TrafficCameraMapViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation TrafficCameraMapViewController{
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
        
        self.title = self.selectedTrafficCamera.name;
        _mapView.delegate = self;

        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = [self.selectedTrafficCamera.latitude doubleValue];
        zoomLocation.longitude= [self.selectedTrafficCamera.longitude doubleValue];
        
        MKCoordinateRegion region;
        region.center=zoomLocation;
        MKCoordinateSpan span;
        span.latitudeDelta=0.008;
        span.longitudeDelta=0.008;
        region.span=span;
        [self.mapView setRegion:region animated:YES];
        
        if (self.selectedTrafficCamera.favourite == [NSNumber numberWithInt:1]){
            self.buttonFavouriteCamera.image = [UIImage imageNamed:@"StarFull24-3.png"];
        } else {
            self.buttonFavouriteCamera.image = [UIImage imageNamed:@"StarEmpty24-3.png"];
        }
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    @try{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [locationManager startUpdatingLocation];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    @try{
        [self plotTrafficCameraPosition];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    @try{
        static NSString *identifier = @"TrafficCameraMapOverlay";
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
            if (self.selectedTrafficCamera.favourite == [NSNumber numberWithInt:1])
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
            [self setFavouriteTrafficCamera];
            
        } else if(control.tag == 2) {
            [self performSegueWithIdentifier:@"showTrafficCameraDirections" sender:self];
        }
        
        [self plotTrafficCameraPosition];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSException* locationManagerException = [NSException
                                             exceptionWithName:@"TrafficCameraMapViewController.locationManager.didFailWithError"
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

- (void)plotTrafficCameraPosition{
    @try{
        for (id<MKAnnotation> annotation in self.mapView.annotations) {
            [_mapView removeAnnotation:annotation];
        }
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [self.selectedTrafficCamera.latitude doubleValue];
        coordinate.longitude= [self.selectedTrafficCamera.longitude doubleValue];
        
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.008;
        span.longitudeDelta = 0.008;
        region.span = span;
        region.center = coordinate;
        
        MapOverlay *annotation = [[MapOverlay alloc] initWithName:self.selectedTrafficCamera.name subTitle:nil titleAddendum:nil coordinate:coordinate];
        [_mapView addAnnotation:annotation];
        
        [self.mapView addAnnotation:annotation];
        [self.mapView setRegion:region animated:YES];
        [self.mapView regionThatFits:region];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try{
        if([segue.identifier isEqualToString:@"showTrafficCameraDirections"]){
            
            NSString *directionsURL;
            
            if ((currentLocation.latitude == 0) || (currentLocation.longitude == 0)){
                directionsURL = [NSString stringWithFormat:@"http://maps.google.com/?daddr=%1.6f,%1.6f",[self.selectedTrafficCamera.latitude doubleValue], [self.selectedTrafficCamera.longitude doubleValue]];
            } else {
                directionsURL = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",currentLocation.latitude, currentLocation.longitude, [self.selectedTrafficCamera.latitude doubleValue], [self.selectedTrafficCamera.longitude doubleValue]];
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

- (void)setFavouriteTrafficCamera
{
    @try{
        // set up the managedObjectContext to read data from CoreData
        id delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"TrafficCameraInfo"
                                                  inManagedObjectContext:self.managedObjectContext];
        
        
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"code=%@",self.selectedTrafficCamera.code]];
        
        NSError *error;
        TrafficCameraInfo *cgTrafficCamera;
        
        UIImage *newFavImage;
        
        cgTrafficCamera = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
        
        NSString *alertMessage;
        if (cgTrafficCamera.favourite == [NSNumber numberWithInt:0]){
            cgTrafficCamera.favourite = [NSNumber numberWithBool:YES];
            alertMessage = @"Added to favourite cameras list";
            newFavImage = [UIImage imageNamed:@"StarFull24-3.png"];
        } else {
            cgTrafficCamera.favourite = [NSNumber numberWithBool:NO];
            alertMessage = @"Removed from favourite cameras list";
            newFavImage = [UIImage imageNamed:@"StarEmpty24-3.png"];
        }
        
        error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSException* locationManagerException = [NSException
                                                     exceptionWithName:@"TrafficCameraMapViewController.setFavouriteCamera.errorSaving"
                                                     reason:@"Failed to save favourite setting"
                                                     userInfo:nil];
            
            BUGSENSE_LOG(locationManagerException, nil);
            
        } else {
            self.buttonFavouriteCamera.image = newFavImage;
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:NSLocalizedString(self.selectedTrafficCamera.name, @"AlertView")
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

- (IBAction)setFavouriteCamera:(id)sender
{
    @try{
        [self setFavouriteTrafficCamera];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

-(void)dismissAlertView:(UIAlertView*)favouritesUpdateAlert
{
    [favouritesUpdateAlert dismissWithClickedButtonIndex:-1 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && [self.view window] == nil) {
        self.mapView = nil;
        [self setView:nil];
    }
}

@end
