//
//  CombinedMapViewController.h
//  DublinCityParking
//
//  Created by darren cullen on 15/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CombinedMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
- (IBAction)selectOverlayType:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControlOverlayTypes;

@end
