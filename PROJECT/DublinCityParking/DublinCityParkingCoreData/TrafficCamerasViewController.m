//
//  TrafficCamerasViewController.m
//  DublinCityParking
//
//  Created by darren cullen on 12/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import "TrafficCamerasViewController.h"
#import "TrafficCameraInfo.h"
#import "TrafficCameraImageViewController.h"
#import <BugSense-iOS/BugSenseController.h>

@interface TrafficCamerasViewController ()

@property (nonatomic, strong) TrafficCameraInfo *selectedCamera;
@property (nonatomic, strong) NSMutableArray *favouriteCameras;
@property (nonatomic, strong) NSMutableArray *trafficCamerasD1;
@property (nonatomic, strong) NSMutableArray *trafficCamerasD2;
@property (nonatomic, strong) NSMutableArray *trafficCameraLocations;

@end

@implementation TrafficCamerasViewController


- (void) setTrafficCameras:(NSArray *)trafficCameras
{
    if (_trafficCameras != trafficCameras)
        _trafficCameras = trafficCameras;
}

- (NSMutableArray *)trafficCamerasD1
{
    if (!_trafficCamerasD1) {
        _trafficCamerasD1 = [[NSMutableArray alloc] init];
    } return _trafficCamerasD1;
}

- (NSMutableArray *)trafficCamerasD2
{
    if (!_trafficCamerasD2) {
        _trafficCamerasD2 = [[NSMutableArray alloc] init];
    } return _trafficCamerasD2;
}

- (NSMutableArray *)favouriteCameras
{
    if (!_favouriteCameras) {
        _favouriteCameras = [[NSMutableArray alloc] init];
    } return _favouriteCameras;
}

- (void)viewDidLoad
{
    @try{
        [super viewDidLoad];
        
        self.trafficCamerasD1 = [[NSMutableArray alloc] init];
        self.trafficCamerasD2 = [[NSMutableArray alloc] init];
        self.trafficCameraLocations = [[NSMutableArray alloc] initWithObjects:self.favouriteCameras, self.trafficCamerasD1, self.trafficCamerasD2, nil];
        
        // set up the managedObjectContext to read data from CoreData
        id delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"TrafficCameraInfo"
                                                  inManagedObjectContext:self.managedObjectContext];
        
        
        [fetchRequest setEntity:entity];
        NSError *error;
        self.trafficCameras = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        for (TrafficCameraInfo *camera in self.trafficCameras){
            if (camera.favourite == [NSNumber numberWithInt:1]){
                [self.favouriteCameras addObject:camera];
            } else if ([camera.postCode isEqualToString:@"D1"]){
                [self.trafficCamerasD1 addObject:camera];
            } else if ([camera.postCode isEqualToString:@"D2"]){
                [self.trafficCamerasD2 addObject:camera];
            }
        }
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void) resetArrays
{
    self.favouriteCameras = nil;
    self.trafficCamerasD1 = nil;
    self.trafficCamerasD2 = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    @try{
        [self resetArrays];

        self.trafficCameraLocations = [[NSMutableArray alloc] initWithObjects:self.favouriteCameras, self.trafficCamerasD1, self.trafficCamerasD2, nil];
        
        // set up the managedObjectContext to read data from CoreData
        id delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"TrafficCameraInfo"
                                                  inManagedObjectContext:self.managedObjectContext];
        
        
        [fetchRequest setEntity:entity];
        NSError *error;
        self.trafficCameras = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        for (TrafficCameraInfo *camera in self.trafficCameras){
            if (camera.favourite == [NSNumber numberWithInt:1]){
                [self.favouriteCameras addObject:camera];
            } else if ([camera.postCode isEqualToString:@"D1"]){
                [self.trafficCamerasD1 addObject:camera];
            } else if ([camera.postCode isEqualToString:@"D2"]){
                [self.trafficCamerasD2 addObject:camera];
            }
        }
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    @try{
        [self.cameraList reloadData];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.trafficCameraLocations.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try{
        // Return the number of rows in the section.    
        NSArray *sectionContents = [self.trafficCameraLocations objectAtIndex:section];
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
        static NSString *CellIdentifier = @"TrafficCameraCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        NSArray *selectedSection = self.trafficCameraLocations[indexPath.section];
        self.selectedCamera = [selectedSection objectAtIndex:[indexPath row]];
        
        UILabel *trafficCameraStreetLabel = (UILabel *)[cell viewWithTag:300];
        trafficCameraStreetLabel.text = self.selectedCamera.name;
        
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
            if ([_favouriteCameras count] > 0){
                headerLabel.text = @"Favourites";
                [headerView addSubview:headerLabel];
                
                return headerView;
                
            } else return [[UIView alloc] initWithFrame:CGRectZero];
            
        }
        else if(section == 1){
            if ([_trafficCamerasD1 count] > 0){
                headerLabel.text = @"Dublin 1";
                [headerView addSubview:headerLabel];
                
                return headerView;
                
            } else return [[UIView alloc] initWithFrame:CGRectZero];
            
        }
        else if(section == 2){
            if ([_trafficCamerasD2 count] > 0){
                headerLabel.text = @"Dublin 2";
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
            if ([_favouriteCameras count] > 0){
                return 44.0f;
            } else return 0.000001f;
        }
        else if(section == 1){
            if ([_trafficCamerasD1 count] > 0){
                return 44.0f;
            } else return 0.000001f;
        }
        else if(section == 2){
            if ([_trafficCamerasD1 count] > 0){
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
            if ([_favouriteCameras count] > 0){
                return 10.0f;
            } else return 0.000001f;
        }
        else if(section == 1){
            if ([_trafficCamerasD1 count] > 0){
                return 10.0f;
            } else return 0.000001f;
        }
        else if(section == 2){
            if ([_trafficCamerasD1 count] > 0){
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
        NSArray *selectedSection = self.trafficCameraLocations[indexPath.section];
        self.selectedCamera = [selectedSection objectAtIndex:[indexPath row]];
        
        // do a segue based on the indexPath or do any setup later in prepareForSegue
        [self performSegueWithIdentifier:@"showTrafficCameraImage" sender:self];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try{ 
        if([segue.identifier isEqualToString:@"showTrafficCameraImage"]){
            
            TrafficCameraImageViewController *destViewController = segue.destinationViewController;
            destViewController.selectedTrafficCamera = self.selectedCamera;
            
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

@end
