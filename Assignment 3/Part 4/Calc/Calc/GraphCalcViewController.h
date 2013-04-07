//
//  GraphCalcViewController.h
//  GraphCalc
//
//  Created by darren cullen on 15/02/2013.
//  Copyright (c) 2013 95674454. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "CalcModel.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface GraphCalcViewController : UIViewController <GraphViewDelegate, SplitViewBarButtonItemPresenter, UISplitViewControllerDelegate>

@property (nonatomic, strong) NSArray *expressionToPlot;
@property (nonatomic, strong) NSString *descriptionOfExpression;

@property (nonatomic, weak) IBOutlet UINavigationItem *navBarItem;
@property (nonatomic, strong) UIPopoverController *popover;
@end
