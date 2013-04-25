//
//  DisabledSpacesMapViewController.h
//  DublinCityParking
//
//  Created by darren cullen on 12/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DisabledParkingSpaceInfo.h"
#import <CoreLocation/CoreLocation.h>


@interface DisabledSpacesMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) DisabledParkingSpaceInfo *selectedDisabledSpace;
- (IBAction)showDisabledSpacesDirections:(id)sender;

@end