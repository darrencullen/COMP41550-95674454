//
//  CarparkListViewController.m
//  DublinCityParking
//
//  Created by darren cullen on 21/02/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import "CarparkListViewController.h"
#import "CarparkInfo.h"
#import "CarparkDetails.h"
#import "XMLParser.h"
#import "CarparkMapViewController.h"
#import "NetworkStatus.h"
#import <BugSense-iOS/BugSenseController.h>

@interface CarparkListViewController ()

@property (nonatomic, strong) XMLParser *xmlParser;
@property (nonatomic, strong) CarparkInfo *selectedCarpark;
@property (nonatomic, strong) NSMutableArray *favouriteCarparks;
@property (nonatomic, strong) NSMutableArray *southeastCarparks;
@property (nonatomic, strong) NSMutableArray *southwestCarparks;
@property (nonatomic, strong) NSMutableArray *northeastCarparks;
@property (nonatomic, strong) NSMutableArray *northwestCarparks;
@property (nonatomic, strong) NSMutableArray *carparkLocations;

@end

@implementation CarparkListViewController

- (void) setCarparkInfos:(NSArray *)carparkInfos
{
    if (_carparkInfos != carparkInfos)
        _carparkInfos = carparkInfos;
}

- (NSMutableArray *)favouriteCarparks
{
    if (!_favouriteCarparks) {
        _favouriteCarparks = [[NSMutableArray alloc] init];
    } return _favouriteCarparks;
}

- (NSMutableArray *)southeastCarparks
{
    if (!_southeastCarparks) {
        _southeastCarparks = [[NSMutableArray alloc] init];
    } return _southeastCarparks;
}

- (NSMutableArray *)southwestCarparks
{
    if (!_southwestCarparks) {
        _southwestCarparks = [[NSMutableArray alloc] init];
    } return _southwestCarparks;
}

- (NSMutableArray *)northeastCarparks
{
    if (!_northeastCarparks) {
        _northeastCarparks = [[NSMutableArray alloc] init];
    } return _northeastCarparks;
}

- (NSMutableArray *)northwestCarparks
{
    if (!_northwestCarparks) {
        _northwestCarparks = [[NSMutableArray alloc] init];
    } return _northwestCarparks;
}

- (void)viewDidLoad
{
    @try{
        [super viewDidLoad];
        
        if (![NetworkStatus hasConnectivity]){
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:NSLocalizedString(@"No network available", @"AlertView")
                                      message:NSLocalizedString(@"A network connection is required for up to the minute parking information.", @"AlertView")
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"OK", @"AlertView")
                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadXMLData)
                                                     name:@"appDidBecomeActive"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contextChanged:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:nil];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)contextChanged:(NSNotification*)notification
{
    @try{
        // update managed object on main thread when edited on background thread
        if ([notification object] == [self managedObjectContext]) return;
        
        if (![NSThread isMainThread]) {
            [self performSelectorOnMainThread:@selector(contextChanged:) withObject:notification waitUntilDone:YES];
            return;
        }
        
        [[self managedObjectContext] mergeChangesFromContextDidSaveNotification:notification];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void) resetArrays
{
    self.favouriteCarparks = nil;
    self.southeastCarparks = nil;
    self.southwestCarparks = nil;
    self.northeastCarparks = nil;
    self.northwestCarparks = nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    @try{
        [self resetArrays];
        
        self.carparkLocations = [[NSMutableArray alloc] initWithObjects:self.favouriteCarparks, self.northwestCarparks, self.northeastCarparks, self.southwestCarparks, self.southeastCarparks, nil];
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CarparkInfo"
                                                  inManagedObjectContext:self.managedObjectContext];
        
        
        [fetchRequest setEntity:entity];
        NSError *error;
        self.carparkInfos = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        for (CarparkInfo *carpark in self.carparkInfos){
            if (carpark.favourite == YES){
                [self.favouriteCarparks addObject:carpark];
            } else if ([carpark.details.region isEqualToString:@"Northwest"]){
                [self.northwestCarparks addObject:carpark];
            } else if ([carpark.details.region isEqualToString:@"Northeast"]){
                [self.northeastCarparks addObject:carpark];
            } else if ([carpark.details.region isEqualToString:@"Southwest"]){
                [self.southwestCarparks addObject:carpark];
            } else if ([carpark.details.region isEqualToString:@"Southeast"]){
                [self.southeastCarparks addObject:carpark];
            }
        }
        
        [self loadXMLData];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void) loadXMLData {
    @try{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                                selector:@selector(loadXMLDataWithOperation)
                                                                                  object:nil];
        [queue addOperation:operation];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void) loadXMLDataWithOperation {
    @try{
        self.xmlParser = [[XMLParser alloc] loadXMLByURL:@"http://www.dublincity.ie/dublintraffic/cpdata.xml"];
        
        [self performSelectorOnMainThread:@selector(reloadUpdatedData) withObject:nil waitUntilDone:YES];
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void) reloadUpdatedData
{
    @try{
        [self.carparkList reloadData];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.carparkLocations.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try{
        // Return the number of rows in the section.    
        NSArray *sectionContents = [self.carparkLocations objectAtIndex:section];
        NSInteger rows = [sectionContents count];
        
        return rows;
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        static NSString *CellIdentifier = @"CarparkCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
        // Configure the cell...
        NSArray *selectedSection = self.carparkLocations[indexPath.section];
        self.selectedCarpark = [selectedSection objectAtIndex:[indexPath row]];
    
        UILabel *carparkNameLabel = (UILabel *)[cell viewWithTag:100];
        carparkNameLabel.text = self.selectedCarpark.name;
    
        UILabel *carparkAddressLabel = (UILabel *)[cell viewWithTag:101];
        carparkAddressLabel.text = [NSString stringWithFormat:@"%@", self.selectedCarpark.address];
    
        UILabel *availableSpacesLabel = (UILabel *)[cell viewWithTag:102];
        availableSpacesLabel.text = self.selectedCarpark.availableSpaces;
    
        UILabel *hourlyRateLabel = (UILabel *)[cell viewWithTag:103];
        hourlyRateLabel.text = self.selectedCarpark.details.hourlyRate;
    
        return cell;
    
    } @catch (NSException *exc) {       
        BUGSENSE_LOG(exc, nil);
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    @try{
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,10, headerView.frame.size.width, 30)];
        
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.shadowColor = [UIColor grayColor];
        headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        headerLabel.font = [UIFont boldSystemFontOfSize:18];
        
        if(section == 0){
            if ([_favouriteCarparks count] > 0){
                headerLabel.text = @"Favourites";
                [headerView addSubview:headerLabel];
                
                return headerView;
                
            } else return [[UIView alloc] initWithFrame:CGRectZero];
            
        }
        else if(section == 1){
            if ([_northwestCarparks count] > 0){
                headerLabel.text = @"Northwest";
                [headerView addSubview:headerLabel];
                
                return headerView;
                
            } else return [[UIView alloc] initWithFrame:CGRectZero];
            
        }
        else if(section == 2){
            if ([_northeastCarparks count] > 0){
                headerLabel.text = @"Northeast";
                [headerView addSubview:headerLabel];
                
                return headerView;
                
            } else return [[UIView alloc] initWithFrame:CGRectZero];
            
        }
        else if(section == 3){
            if ([_southwestCarparks count] > 0){
                headerLabel.text = @"Southwest";
                [headerView addSubview:headerLabel];
                
                return headerView;
                
            } else return [[UIView alloc] initWithFrame:CGRectZero];
            
        }
        else if(section == 4){
            if ([_southeastCarparks count] > 0){
                headerLabel.text = @"Southeast";
                [headerView addSubview:headerLabel];
                
                return headerView;
                
            } else return [[UIView alloc] initWithFrame:CGRectZero];
        }
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }

    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    @try{
        if(section == 0){
            if ([_favouriteCarparks count] > 0){
                return 44.0f;
            } else return 0.000001f;
        }
        else if(section == 1){
            if ([_northwestCarparks count] > 0){
                return 44.0f;
            } else return 0.000001f;
        }
        else if(section == 2){
            if ([_northeastCarparks count] > 0){
                return 44.0f;
            } else return 0.000001f;
        }
        else if(section == 3){
            if ([_southwestCarparks count] > 0){
                return 44.0f;
            } else return 0.000001f;
        }
        else if(section == 4){
            if ([_southeastCarparks count] > 0){
                return 44.0f;
            } else return 0.000001f;
        }
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
    
    return 0.000001f;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    @try{
        if(section == 0){
            if ([_favouriteCarparks count] > 0){
                return 10.0f;
            } else return 0.000001f;
        }
        else if(section == 1){
            if ([_northwestCarparks count] > 0){
                return 10.0f;
            } else return 0.000001f;
        }
        else if(section == 2){
            if ([_northeastCarparks count] > 0){
                return 10.0f;
            } else return 0.000001f;
        }
        else if(section == 3){
            if ([_southwestCarparks count] > 0){
                return 10.0f;
            } else return 0.000001f;
        }
        else if(section == 4){
            if ([_southeastCarparks count] > 0){
                return 10.0f;
            } else return 0.000001f;
        }
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
    return 0.000001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        NSArray *selectedSection = self.carparkLocations[indexPath.section];
        self.selectedCarpark = [selectedSection objectAtIndex:[indexPath row]];

        [self performSegueWithIdentifier:@"showCarparkMap" sender:self];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try{
        if([segue.identifier isEqualToString:@"showCarparkMap"]){
            
            CarparkMapViewController *destViewController = segue.destinationViewController;
            destViewController.selectedCarparkInfo = self.selectedCarpark;
            
            UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"List" style: UIBarButtonItemStyleBordered target: nil action: nil];
            
            [[self navigationItem] setBackBarButtonItem: newBackButton];
        }
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && [self.view window] == nil) {
        [self resetArrays];
        self.view = nil;
    }
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
