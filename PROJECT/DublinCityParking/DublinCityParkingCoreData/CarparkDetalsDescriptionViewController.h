//
//  CarparkDetalsDescriptionViewController.h
//  DublinCityParking
//
//  Created by darren cullen on 14/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CarparkDetalsDescriptionViewController : UITableViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSString *details;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *directionsButton;
@property (nonatomic) float carparkLocationLatitude;
@property (nonatomic) float carparkLocationLongitude;

@end
