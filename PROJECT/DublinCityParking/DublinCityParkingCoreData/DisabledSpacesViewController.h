//
//  DisabledSpacesViewController.h
//  DublinCityParking
//
//  Created by darren cullen on 10/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisabledSpacesViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *disabledSpaces;
@property (strong, nonatomic) IBOutlet UITableView *disabledSpacesList;

@end
