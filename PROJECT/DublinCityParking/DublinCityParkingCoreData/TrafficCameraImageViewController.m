//
//  TrafficCameraImageViewController.m
//  DublinCityParking
//
//  Created by darren cullen on 13/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import "TrafficCameraImageViewController.h"
#import "TrafficCameraMapViewController.h"
#import "NetworkStatus.h"
#import <BugSense-iOS/BugSenseController.h>

@interface TrafficCameraImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;
@property (nonatomic, strong) NSURL *imageURL;
@end

@implementation TrafficCameraImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadImage
{
    @try{
        if (self.imageView && self.imageURL) {
            self.activitySpinner.hidden = NO;
            [self.activitySpinner startAnimating];
            dispatch_queue_t downloadQ = dispatch_queue_create("ie.dcdevelopmentstudios.DubPark.imageview", 0);
            dispatch_async(downloadQ, ^{
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = image;
                    [self.activitySpinner stopAnimating];
                    self.activitySpinner.hidden = YES;
                });
            });
        } else self.imageView.image = nil;
            
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)viewDidLoad
{
    @try{
        [super viewDidLoad];
        
        self.title = self.selectedTrafficCamera.name;
        self.imageURL = [[NSURL alloc] initWithString:self.selectedTrafficCamera.url];
        
        if ([NetworkStatus hasConnectivity])
            [self loadImage];
        else{
            NSString *message = [NSString stringWithFormat:@"A network connection is required to access traffic camera images"];
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:NSLocalizedString(@"No network available", @"AlertView")
                                      message:NSLocalizedString(message, @"AlertView")
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"OK", @"AlertView")
                                      otherButtonTitles:nil, nil];
            [alertView show];
            
            self.activitySpinner.hidden = YES;
            self.imageView.image = [UIImage imageNamed:@"imagenotavailable.jpg"];
        }
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try{    
        if([segue.identifier isEqualToString:@"showTrafficCameraMap"]){
            
            TrafficCameraMapViewController *destViewController = segue.destinationViewController;
            destViewController.selectedTrafficCamera = self.selectedTrafficCamera;
            
            
            UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Camera" style: UIBarButtonItemStyleBordered target: nil action: nil];
            
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
        [self setView:nil];
        [self setImageView:nil];
        [self setActivitySpinner:nil];
    }
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setActivitySpinner:nil];
    [super viewDidUnload];
}
@end
