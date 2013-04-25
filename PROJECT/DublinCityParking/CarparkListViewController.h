//
//  CarparkListViewController.h
//  DublinCityParking
//
//  Created by darren cullen on 21/02/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarparkListViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *carparkInfos;
@property (strong, nonatomic) IBOutlet UITableView *carparkList;

@end
