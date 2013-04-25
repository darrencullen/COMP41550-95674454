//
//  MoreViewController.m
//  DublinCityParking
//
//  Created by darren cullen on 16/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import "MoreViewController.h"
#import "WebViewController.h"
#import <BugSense-iOS/BugSenseController.h>

@interface MoreViewController ()

@end

@implementation MoreViewController

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
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.tag == 502){
        
        NSString *phoneNumberURL = [NSString stringWithFormat:@"https://twitter.com/LiveDrive"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberURL]];
        
    } else if (cell.tag == 504){
        NSString *emailTitle = @"DubPark Feedback";
        NSArray *toRecipents = [NSArray arrayWithObject:@"dcdevelopmentstudios@gmail.com"];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setToRecipients:toRecipents];
        
        [self presentViewController:mc animated:YES completion:NULL];
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
        headerLabel.text = @"Parking & Traffic";
    else if(section == 1)
        headerLabel.text = @"DubPark";
    
    [headerView addSubview:headerLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultFailed){
        NSException* locationManagerException = [NSException
                                                 exceptionWithName:@"MoreViewController.mailComposeController.mailSentError"
                                                 reason:[error localizedDescription]
                                                 userInfo:nil];
        
        BUGSENSE_LOG(locationManagerException, nil);
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showParkingInformation"]){
        
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"More Info" style: UIBarButtonItemStyleBordered target: nil action: nil];
        
        [[self navigationItem] setBackBarButtonItem: newBackButton];

    } else if([segue.identifier isEqualToString:@"showDubParkInformation"]){
        
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"More Info" style: UIBarButtonItemStyleBordered target: nil action: nil];
        
        [[self navigationItem] setBackBarButtonItem: newBackButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && [self.view window] == nil) {
        self.view = nil;
    }
}

@end
