//
//  CarparkDetailsViewController.h
//  DublinCityParkingCoreData
//
//  Created by darren cullen on 27/02/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarparkInfo.h"
#import "carparkDetails.h"

@interface CarparkDetailsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *region;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *totalSpaces;
@property (strong, nonatomic) IBOutlet UILabel *availableSpaces;
@property (strong, nonatomic) IBOutlet UILabel *disabledSpaces;
@property (strong, nonatomic) IBOutlet UILabel *openingHours;
@property (strong, nonatomic) IBOutlet UILabel *hourlyRate;
@property (strong, nonatomic) IBOutlet UILabel *otherRate;
@property (strong, nonatomic) IBOutlet UILabel *maxHeight;
@property (strong, nonatomic) IBOutlet UILabel *phone;
@property (strong, nonatomic) IBOutlet UILabel *services;
@property (strong, nonatomic) IBOutlet UILabel *directions;

@property (nonatomic, strong) CarparkInfo *selectedCarparkInfo;
//@property (nonatomic, strong) CarparkDetails *selectedCarparkDetails;

@end
