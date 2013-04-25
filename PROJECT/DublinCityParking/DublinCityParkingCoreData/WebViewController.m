//
//  WebViewController.m
//  DublinCityParking
//
//  Created by darren cullen on 16/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import "WebViewController.h"
#import "NetworkStatus.h"
#import <BugSense-iOS/BugSenseController.h>

@interface WebViewController ()
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
    @try{
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
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)loadWebsite
{
    @try{
        if (self.webView && self.url) {
            dispatch_queue_t downloadQ = dispatch_queue_create("ie.dcdevelopmentstudios.DubPark.webview", 0);
            dispatch_async(downloadQ, ^{
                NSURL *url = [NSURL URLWithString:self.url];
                NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.webView loadRequest:requestObj];
                });
            });
        };
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (IBAction)refreshPage:(id)sender
{
    @try{
        [self loadWebsite];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (IBAction)backButtonPressed:(id)sender
{
    @try{
        [self.webView goBack];
        
    } @catch (NSException *exc) {
        BUGSENSE_LOG(exc, nil);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && [self.view window] == nil) {
        [self setView:nil];
        [self setWebView:nil];
    }
}
@end
