//
//  CarparkDetailsViewController.h
//  DublinCityParking
//
//  Created by darren cullen on 14/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarparkInfo.h"

@interface CarparkDetailsViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) CarparkInfo *selectedCarparkInfo;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonFavs;
- (IBAction)setFavouriteCarpark:(id)sender;

@end
