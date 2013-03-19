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
@property (nonatomic) BOOL hasCompleteEquationJustBeenSolved;
@property (nonatomic, retain) NSMutableDictionary *variablesSet;
@property (nonatomic, strong) NSString *variableBeingSet;
@property (nonatomic, strong) NSMutableSet *variablesCurrentlyInExpression;
@property (nonatomic) double expressionResult;
@end

@implementation CalcViewController


- (IBAction)digitPressed:(UIButton *)sender
{
    // if equation has just been solved then selecting a digit starts another expression
    if (self.hasCompleteEquationJustBeenSolved == YES){
        [self solveEquation:@"C"];
        self.hasCompleteEquationJustBeenSolved = NO;
    }
    
    NSString *digit = sender.titleLabel.text;
    
    // don't allow more than one dot
    if ([digit isEqualToString:@"."])
        if ([self.calcDisplay.text rangeOfString:@"."].location != NSNotFound)
            return;
    
    // handle pi
    if ([digit isEqualToString:@"π"])
        digit = [NSString stringWithFormat:@"%g", M_PI];
    
    if (self.isInTheMiddleOfTypingSomething == YES)
        if (self.hasMemoryJustBeenAccessed == YES)
            self.calcDisplay.text = digit;
    
        // replace digit if 0 displayed or else append digit
        else if ([self.calcDisplay.text isEqual:@"0"])
            if ([digit isEqualToString:@"."])
                self.calcDisplay.text = [self.calcDisplay.text stringByAppendingString:digit];
            else
                self.calcDisplay.text = digit;
    
        else
            self.calcDisplay.text = [self.calcDisplay.text stringByAppendingString:digit];
    else {
        if ([digit isEqualToString:@"."])
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
    if (self.isInTheMiddleOfTypingSomething == YES){
        self.calcModel.operand = [self.calcDisplay.text doubleValue];
        self.isInTheMiddleOfTypingSomething = NO;
    }
    
    NSString *operation = [[sender titleLabel] text];
    
    // if equation has just been solved then selecting sin or cos starts another expression
    if (self.hasCompleteEquationJustBeenSolved == YES)
        if (([operation isEqualToString:@"sin"]) || ([operation isEqualToString:@"cos"])){
            [self solveEquation:@"C"];
            self.hasCompleteEquationJustBeenSolved = NO;
        }
    
    [self solveEquation:operation];
    
    // if equation has just been solved, reset the flag if operation pressed
    if ([operation isEqualToString:@"="])
        self.hasCompleteEquationJustBeenSolved = YES;
    else
        self.hasCompleteEquationJustBeenSolved = NO;
    
    //[self checkForErrorsInModel];
}

- (void)checkForErrorsInModel{
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
}

- (void) solveEquation:(NSString *)operation
{
    double result = [[self calcModel] performOperation:operation];
    [[self calcDisplay] setText:[NSString stringWithFormat:@"%g", result]];

    [self checkForErrorsInModel];
    
    self.hasMemoryJustBeenAccessed = NO;

    self.expressionDisplay.text = [[self calcModel] descriptionOfExpression:self.calcModel.expression];
    [CalcModel propertyListForExpression:self.calcModel.expression];
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
//    // if number has been typed before solve clicked then add it to expression
//    if (self.isInTheMiddleOfTypingSomething){
//        self.calcModel.operand = [self.calcDisplay.text doubleValue];
//        self.isInTheMiddleOfTypingSomething = NO;
//    }        
    
    [self solveExpression];
}

- (void) solveExpression{
    [self.variablesSet removeAllObjects];
    self.variablesCurrentlyInExpression = [[NSMutableSet alloc] initWithSet:[CalcModel variablesInExpression:self.calcModel.expression]];
    
    if ([self.variablesCurrentlyInExpression count] > 0){
        [self promptForVariables];
    } else {
        self.expressionResult = [CalcModel evaluateExpression:self.calcModel.expression usingVariableValues:self.variablesSet];
        [[self calcDisplay] setText:[NSString stringWithFormat:@"%g", self.expressionResult]];
        
        [CalcModel propertyListForExpression:self.calcModel.expression];
        self.hasCompleteEquationJustBeenSolved = YES;
        return;
    }
}

- (void)promptForVariables {
    
    if (![self.variablesCurrentlyInExpression count]){
        //[[self calcDisplay] setText:[NSString stringWithFormat:@"%g", [CalcModel evaluateExpression:self.calcModel.expression usingVariableValues:self.variablesSet]]];
        
        self.expressionResult = [CalcModel evaluateExpression:self.calcModel.expression usingVariableValues:self.variablesSet];
        [[self calcDisplay] setText:[NSString stringWithFormat:@"%g", self.expressionResult]];
        
        [CalcModel propertyListForExpression:self.calcModel.expression];
        self.hasCompleteEquationJustBeenSolved = YES;
        
        return;
        
    } else {
        self.variableBeingSet = [self.variablesCurrentlyInExpression anyObject];
        [self.variablesCurrentlyInExpression removeObject:self.variableBeingSet];
        
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] initWithTitle:@"Enter value for variable"
                                                 message:self.variableBeingSet
                                                delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
        
        alertDialog.alertViewStyle=UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alertDialog textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [alertDialog show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
      if (buttonIndex == 0){
        if ([[alertView textFieldAtIndex:0] text]){         
            [self.variablesSet setValue:[[alertView textFieldAtIndex:0] text] forKey:self.variableBeingSet];
        }
    }
    [self promptForVariables];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.variablesSet = [[NSMutableDictionary alloc] init];
    self.hasCompleteEquationJustBeenSolved = NO;
    
    // restore saved expression if it exists
    [[self calcModel] expressionForPropertyList:nil];
    self.expressionDisplay.text = [[self calcModel] descriptionOfExpression:self.calcModel.expression];
    
    @try
    {
        // solve restored expression
        if (self.expressionDisplay.text.length > 0)
            if (![CalcModel variablesInExpression:self.calcModel.expression])
                [self solveExpression];
    }
    
    @catch (NSException *ex) {
        NSLog(@"CalcViewController.viewDidLoad error: %@", ex);
        UIAlertView *alertDialog;
        alertDialog=[[UIAlertView alloc]
                     initWithTitle:@"Operation Error"
                     message:@"Problem reloading saved expression. Values have been reset"
                     delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
        [alertDialog show];
        [self solveEquation:@"C"];
    }
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
