//
//  WebViewController.h
//  DublinCityParking
//
//  Created by darren cullen on 16/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSString *url;
@property (nonatomic) BOOL hideNavigationToolbar;

- (IBAction)refreshPage:(id)sender;
- (IBAction)backButtonPressed:(id)sender;


@end
