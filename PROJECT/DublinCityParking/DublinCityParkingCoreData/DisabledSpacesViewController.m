//
//  DisabledSpacesViewController.m
//  DublinCityParking
//
//  Created by darren cullen on 10/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import "DisabledSpacesViewController.h"
#import "DisabledParkingSpaceInfo.h"
#import "DisabledSpacesMapViewController.h"

@interface DisabledSpacesViewController ()

@property (nonatomic, strong) DisabledParkingSpaceInfo *selectedSpace;
@property (nonatomic, strong) NSMutableArray *disabledSpacesD1;
@property (nonatomic, strong) NSMutableArray *disabledSpacesD2;
@property (nonatomic, strong) NSMutableArray *disabledSpaceLocations;

@end

@implementation DisabledSpacesViewController

- (void) setDisabledSpaces:(NSArray *)disabledSpaces
{
    if (_disabledSpaces != disabledSpaces)
        _disabledSpaces = disabledSpaces;
}

- (NSMutableArray *)disabledSpacesD1
{
    if (!_disabledSpacesD1) {
        _disabledSpacesD1 = [[NSMutableArray alloc] init];
    } return _disabledSpacesD1;
}

- (NSMutableArray *)disabledSpacesD2
{
    if (!_disabledSpacesD2) {
        _disabledSpacesD2 = [[NSMutableArray alloc] init];
    } return _disabledSpacesD2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.disabledSpacesD1 = [[NSMutableArray alloc] init];
    self.disabledSpacesD2 = [[NSMutableArray alloc] init];
    self.disabledSpaceLocations = [[NSMutableArray alloc] initWithObjects:self.disabledSpacesD1, self.disabledSpacesD2, nil];
    
    // set up the managedObjectContext to read data from CoreData
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DisabledParkingSpaceInfo"
                                              inManagedObjectContext:self.managedObjectContext];
    
    
    [fetchRequest setEntity:entity];
    NSError *error;
    self.disabledSpaces = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (DisabledParkingSpaceInfo *space in self.disabledSpaces){
        if ([space.postCode isEqualToString:@"D1"]){
            [self.disabledSpacesD1 addObject:space];
        } else if ([space.postCode isEqualToString:@"D2"]){
            [self.disabledSpacesD2 addObject:space];
        }
    }
}

- (void) resetArrays
{
    self.disabledSpacesD1 = nil;
    self.disabledSpacesD2 = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.disabledSpaceLocations.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.   
    NSArray *sectionContents = [self.disabledSpaceLocations objectAtIndex:section];
    NSInteger rows = [sectionContents count];
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: maybe use region as a cell identifier
    static NSString *CellIdentifier = @"DisabledSpaceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray *selectedSection = self.disabledSpaceLocations[indexPath.section];
    self.selectedSpace = [selectedSection objectAtIndex:[indexPath row]];
    
    UILabel *disabledSpaceStreetLabel = (UILabel *)[cell viewWithTag:200];
    disabledSpaceStreetLabel.text = self.selectedSpace.street;
    
    UILabel *spacesLabel = (UILabel *)[cell viewWithTag:201];
    spacesLabel.text = self.selectedSpace.spaces;
    
    return cell;
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
        headerLabel.text = @"Dublin 1";
    else if(section == 1)
        headerLabel.text = @"Dublin 2";
    
    [headerView addSubview:headerLabel];
    return headerView;    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *selectedSection = self.disabledSpaceLocations[indexPath.section];
    self.selectedSpace = [selectedSection objectAtIndex:[indexPath row]];
    
    // do a segue based on the indexPath or do any setup later in prepareForSegue
    [self performSegueWithIdentifier:@"showDisabledSpaceMap" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"showDisabledSpaceMap"]){
        
        DisabledSpacesMapViewController *destViewController = segue.destinationViewController;
        destViewController.selectedDisabledSpace = self.selectedSpace;
        
        
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"List" style: UIBarButtonItemStyleBordered target: nil action: nil];
        
        [[self navigationItem] setBackBarButtonItem: newBackButton];
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
