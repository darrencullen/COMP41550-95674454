//
//  WebViewController.m
//  DublinCityParking
//
//  Created by darren cullen on 16/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import "WebViewController.h"
#import "NetworkStatus.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIToolbar *navigationToolbar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

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
    self.navigationToolbar.hidden = self.hideNavigationToolbar;

    if ([NetworkStatus hasConnectivity]){
        [self loadWebsite];
        [self.webView setDelegate:self];
    }
    else{
        NSString *message = [NSString stringWithFormat:@"A network connection is required to connect to %@", self.title];
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"No network available", @"AlertView")
                                  message:NSLocalizedString(message, @"AlertView")
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"OK", @"AlertView")
                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)loadWebsite
{
    if (self.webView && self.url) {
        self.activitySpinner.hidden = NO;
        [self.activitySpinner startAnimating];
        dispatch_queue_t downloadQ = dispatch_queue_create("ie.dcdevelopmentstudios.DubPark.webview", 0);
        dispatch_async(downloadQ, ^{
            NSURL *url = [NSURL URLWithString:self.url];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.webView loadRequest:requestObj];
                [self.activitySpinner stopAnimating];
                self.activitySpinner.hidden = YES;
            });
        });
    };
    
    
}

- (IBAction)refreshPage:(id)sender {
    [self loadWebsite];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.webView goBack];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && [self.view window] == nil) {
        [self setView:nil];
        [self setWebView:nil];
        [self setActivitySpinner:nil];
    }
}
@end
