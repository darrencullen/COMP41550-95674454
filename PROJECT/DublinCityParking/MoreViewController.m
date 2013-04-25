//
//  CarparkDetailsViewController.m
//  DublinCityParkingCoreData
//
//  Created by darren cullen on 27/02/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import "CarparkDetailsViewController.h"
#import "CarparkInfo.h"
#import "CarparkDetails.h"

@interface CarparkDetailsViewController ()

@end

@implementation CarparkDetailsViewController{
    CarparkDetails *selectedCarparkDetails;
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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = self.selectedCarparkInfo.name;
    selectedCarparkDetails = self.selectedCarparkInfo.details;
    
    self.region.text = selectedCarparkDetails.region;
    self.address.text = self.selectedCarparkInfo.address;
    self.totalSpaces.text = selectedCarparkDetails.totalSpaces;
    self.availableSpaces.text = self.selectedCarparkInfo.availableSpaces;
    self.disabledSpaces.text = selectedCarparkDetails.disabledSpaces;
    self.openingHours.text = selectedCarparkDetails.openingHours;
    self.hourlyRate.text = selectedCarparkDetails.hourlyRate;
    self.otherRate.text = selectedCarparkDetails.otherRate1;
    self.maxHeight.text = selectedCarparkDetails.heightRestrictions;
    self.phone.text = selectedCarparkDetails.phoneNumber;
    self.services.text = selectedCarparkDetails.services;
    self.directions.text = selectedCarparkDetails.directions;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
