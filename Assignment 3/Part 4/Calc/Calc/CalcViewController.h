//
//  CalcViewController.h
//  Calc
//
//  Created by darren cullen on 28/01/2013.
//  Copyright (c) 2013 95674454. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalcModel.h"

@interface CalcViewController : UIViewController <UIAlertViewDelegate, UISplitViewControllerDelegate>

@property (nonatomic, strong) IBOutlet CalcModel *calcModel;
@property (nonatomic, weak) IBOutlet UILabel *calcDisplay;
@property (weak, nonatomic) IBOutlet UILabel *expressionDisplay;

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)backspacePressed:(UIButton *)sender;
- (IBAction)variablePressed:(UIButton *)sender;
- (IBAction)solveExpressionPressed:(UIButton *)sender;
@end
