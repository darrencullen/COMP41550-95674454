//
//  CalcViewController.m
//  Calc
//
//  Created by darren cullen on 28/01/2013.
//  Copyright (c) 2013 95674454. All rights reserved.
//

#import "CalcViewController.h"

@interface CalcViewController()
@property (nonatomic) BOOL isInTheMiddleOfTypingSomething;
@property (nonatomic) BOOL hasMemoryJustBeenAccessed;
@end

@implementation CalcViewController



- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    
    // don't allow more than one dot
    if ([digit isEqual:@"."])
        if ([self.calcDisplay.text rangeOfString:@"."].location != NSNotFound)
            return;
    
    // handle pi
    if ([digit isEqual:@"π"])
        digit = [NSString stringWithFormat:@"%g", M_PI];
    
    if (self.isInTheMiddleOfTypingSomething)
        if (self.hasMemoryJustBeenAccessed == YES)
            self.calcDisplay.text = digit;
    
        // replace digit if 0 displayed or else append digit
        else if ([self.calcDisplay.text isEqual:@"0"])
            if ([digit isEqual:@"."])
               self.calcDisplay.text = [self.calcDisplay.text stringByAppendingString:digit];
            else
                self.calcDisplay.text = digit;
    
        else
            self.calcDisplay.text = [self.calcDisplay.text stringByAppendingString:digit];
    else {
        if ([digit isEqual:@"."])
            self.calcDisplay.text = [self.calcDisplay.text stringByAppendingString:digit];
        else
            self.calcDisplay.text = digit;
        self.isInTheMiddleOfTypingSomething = YES;
    }
    
    self.hasMemoryJustBeenAccessed = NO;
    //self.expressionDisplay.text = [self.expressionDisplay.text stringByAppendingString:digit];
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
    
    
    if (self.calcModel.operationError == YES){
        UIAlertView *alertDialog;
        alertDialog=[[UIAlertView alloc]
                     initWithTitle:@"Operation Error"
                     message:self.calcModel.operationErrorMessage
                     delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
        [alertDialog show];
    }
    
    self.hasMemoryJustBeenAccessed = NO;
    self.expressionDisplay.text = [[self calcModel] descriptionOfExpression:self.calcModel.expression];
}

- (IBAction)storeValueInMemory:(UIButton *)sender {
    self.calcModel.valueInMemory = [self.calcDisplay.text doubleValue];
    self.hasMemoryJustBeenAccessed = YES;
}

- (IBAction)retrieveValueFromMemory:(UIButton *)sender {
    [[self calcDisplay] setText:[NSString stringWithFormat:@"%g", self.calcModel.valueInMemory]];
    self.calcModel.operand = self.calcModel.valueInMemory;
    self.hasMemoryJustBeenAccessed = YES;
}

- (IBAction)backspacePressed:(UIButton *)sender
{
    if ([self.calcDisplay.text length] > 1)
        self.calcDisplay.text = [self.calcDisplay.text substringToIndex:[self.calcDisplay.text length] - 1];
    else if ([self.calcDisplay.text length] == 1)
        self.calcDisplay.text = @"0";
}

- (IBAction)variablePressed:(UIButton *)sender
{
    [[self calcModel] setVariableAsOperand:sender.titleLabel.text];
    self.expressionDisplay.text = [[self calcModel] descriptionOfExpression:self.calcModel.expression];
}

- (IBAction)solveExpressionPressed:(UIButton *)sender {
    NSSet *variablesCurrentlyInExpression = [[NSSet alloc] initWithSet:[CalcModel variablesInExpression:self.calcModel.expression]];
    
    if (variablesCurrentlyInExpression){
        
        
        //CalcModel evaluateExpression:(id)self.calcModel.expression usingVariableValues:(NSDictionary *)variable;
    }
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

- (void)viewDidUnload {
    [self setExpressionDisplay:nil];
    [super viewDidUnload];
}
@end
