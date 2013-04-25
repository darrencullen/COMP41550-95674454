//
//  ParkingInfoViewController.m
//  DublinCityParking
//
//  Created by darren cullen on 19/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import "ParkingInfoViewController.h"
#import "WebViewController.h"

@interface ParkingInfoViewController ()

@end

@implementation ParkingInfoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Last Updated
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastUpdated;
    if (standardUserDefaults){
        lastUpdated = [standardUserDefaults valueForKey:@"lastUpated"];
    }
    if (lastUpdated.length > 0){
        self.lastUpdatedLabel.text = lastUpdated;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,10, headerView.frame.size.width, 30)];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.shadowColor = [UIColor grayColor];
    headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    
    if(section == 0)
        headerLabel.text = @"Live Data";
    else if(section == 1)
        headerLabel.text = @"Payment Details";
    else if(section == 2)
        headerLabel.text = @"Payment Exemptions";
    else if(section == 3)
        headerLabel.text = @"Parking Zones";
    else if(section == 4)
        headerLabel.text = @"Zone 1 - €2.90/hour";
    else if(section == 5)
        headerLabel.text = @"Zone 2 - €2.40/hour";
    else if(section == 6)
        headerLabel.text = @"Zone 3 - €1.40/hour";
    else if(section == 7)
        headerLabel.text = @"Zone 4 - €1.60/hour";
    else if(section == 8)
        headerLabel.text = @"Zone 5 - €1.00/hour";
    else if(section == 9)
        headerLabel.text = @"Zone 6 - €0.60/hour";
    else if(section == 10)
        headerLabel.text = @"Useful Web Links";
    
    [headerView addSubview:headerLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.tag == 502){
        
        NSString *phoneNumberURL = [NSString stringWithFormat:@"http://www.dublincity.ie/RoadsandTraffic/Pages/Roads.aspx"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberURL]];
        
    } else if (cell.tag >= 503){
        
        NSString *phoneNumberURL = [NSString stringWithFormat:@"http://www.dsps.ie"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberURL]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && [self.view window] == nil) {
        self.view = nil;
    }
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if([segue.identifier isEqualToString:@"showDCCWebView"]){
//        
////        WebViewController *destViewController = segue.destinationViewController;
////        destViewController.url = @"http://www.dublincity.ie/RoadsandTraffic/Pages/Roads.aspx";
////        destViewController.title = @"Dublin City Council";
////        
////        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Info" style: UIBarButtonItemStyleBordered target: nil action: nil];
////        
////        [[self navigationItem] setBackBarButtonItem: newBackButton];
//        
//        NSString *phoneNumberURL = [NSString stringWithFormat:@"http://www.dublincity.ie/RoadsandTraffic/Pages/Roads.aspx"];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberURL]];
//        
//    } else if([segue.identifier isEqualToString:@"showDSPSWebView"]){
//        
////        WebViewController *destViewController = segue.destinationViewController;
////        destViewController.url = @"http://www.dsps.ie";
////        destViewController.title = @"DSPS";
////        
////        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Info" style: UIBarButtonItemStyleBordered target: nil action: nil];
////        
////        [[self navigationItem] setBackBarButtonItem: newBackButton];
//        
//        NSString *phoneNumberURL = [NSString stringWithFormat:@"http://www.dsps.ie"];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberURL]];
//    }
//}

@end
