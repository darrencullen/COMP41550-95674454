//
//  GraphCalcViewController.h
//  GraphCalc
//
//  Created by darren cullen on 15/02/2013.
//  Copyright (c) 2013 95674454. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"


@interface GraphCalcViewController : UIViewController <GraphViewDelegate>

@property (strong, nonatomic) IBOutlet GraphView *graphView;
@property (weak, nonatomic) IBOutlet UILabel *expressionLabel;
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;

@property (nonatomic, strong) NSString *expressionToPlot;

@end
