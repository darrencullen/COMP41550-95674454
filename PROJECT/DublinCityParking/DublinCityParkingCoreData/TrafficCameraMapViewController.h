//
//  TrafficCameraMapViewController.h
//  DublinCityParking
//
//  Created by darren cullen on 13/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TrafficCameraInfo.h"

@interface TrafficCameraMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) TrafficCameraInfo *selectedTrafficCamera;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (IBAction)setFavouriteCamera:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonFavouriteCamera;



@end
