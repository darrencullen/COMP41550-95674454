//
//  CalcViewController.m
//  Calc
//
//  Created by darren cullen on 28/01/2013.
//  Copyright (c) 2013 95674454. All rights reserved.
//

#import "CalcViewController.h"

@implementation CalcViewController


- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    
    if ([digit isEqual:@"."])
        if ([self.calcDisplay.text rangeOfString:@"."].location != NSNotFound)
            return;
    
    if (self.isInTheMiddleOfTypingSomething)
        self.calcDisplay.text = [self.calcDisplay.text stringByAppendingString:digit];
    else {
        self.calcDisplay.text = digit;
        self.isInTheMiddleOfTypingSomething = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.isInTheMiddleOfTypingSomething){
        self.calcModel.operand = [self.calcDisplay.text doubleValue];
        self.isInTheMiddleOfTypingSomething = NO;
    }
    
    NSString *operation = [[sender titleLabel] text];
    double result = [[self calcModel] performOperation:operation];
    [[self calcDisplay] setText:[NSString stringWithFormat:@"%g", result]];
}

- (IBAction)storeValueInMemory:(UIButton *)sender {
    self.calcModel.valueInMemory = [self.calcDisplay.text doubleValue];
}

- (IBAction)retrieveValueFromMemory:(UIButton *)sender {
    [[self calcDisplay] setText:[NSString stringWithFormat:@"%g", self.calcModel.valueInMemory]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (IBAction)doAlert:(id)sender {
//    UIAlertView *alertDialog;
//    alertDialog=[[UIAlertView alloc]
//                 initWithTitle:@"Alert button selected"
//                 message:@"I need your attention now"
//                 delegate:nil
//                 cancelButtonTitle:@"OK"
//                 otherButtonTitles:nil];
//    [alertDialog show];
//}

@end
