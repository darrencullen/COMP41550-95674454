//
//  CarparkMapViewController.h
//  DublinCityParking
//
//  Created by darren cullen on 26/02/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CarparkInfo.h"
#import "CarparkDetails.h"
#import <CoreLocation/CoreLocation.h>

@interface CarparkMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) CarparkInfo *selectedCarparkInfo;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)showCarparkDetails:(id)sender;

@end
