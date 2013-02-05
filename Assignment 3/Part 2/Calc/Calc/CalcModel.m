//
//  CalcModel.m
//  Calc
//
//  Created by darren cullen on 28/01/2013.
//  Copyright (c) 2013 95674454. All rights reserved.
//

#import "CalcModel.h"

@interface CalcModel()
@property (nonatomic) BOOL doesExpressionHaveVariable;
@property (nonatomic) int latestVariableIndex;
@end

@implementation CalcModel

- (id)init
{
    if (self = [super init])
    {
        _expression = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (double)evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variable
{
    
    // TODO: evaluate expression
    return 33.33;
}

+ (NSSet *)variablesInExpression:(id)anExpression
{
    NSMutableSet *expressionVariables = [[NSMutableSet alloc] init];
    
    for (NSString *item in anExpression) {
        if (([item isEqual:@"a"]) || ([item isEqual:@"b"]) || ([item isEqual:@"x"])){
            if (![expressionVariables containsObject:item])
                [expressionVariables addObject:item];
        }
    }
    
    if ([expressionVariables count] == 0)
        return nil;
    else
        return expressionVariables;
}

+ (id)propertyListForExpression:(id)anExpression
{
    // TODO:
    return nil;
}

- (double)performOperation:(NSString *)operation
{
    _operationError = NO;
    
    if (([self.waitingOperation isEqual:@"/"]) && (self.operand == 0)){
        _operationError = YES;
        _operationErrorMessage = @"Division by zero not allowed";
        self.operand = 0;
        self.waitingOperand = 0;
        self.waitingOperation = nil;
        return 0;
    }
    
    if (([operation isEqual:@"sqrt"]) && (self.operand < 0)){
        _operationError = YES;
        _operationErrorMessage = @"Square root of negative number not allowed";
        self.operand = 0;
        self.waitingOperand = 0;
        self.waitingOperation = nil;
        return 0;
    }
    
    if ([self.waitingOperation isEqual:@"="]){
        if (![operation isEqual:@"="])
            [_expression addObject:operation];
    }
    else{
        // only add operand if last object in expression wasn't a variable
        if ((self.latestVariableIndex != [_expression count]) || (self.latestVariableIndex == 0)){
            NSString *trimmedOperand = [NSString stringWithFormat:@"%g",self.operand];
            [_expression addObject:trimmedOperand];
        }
        [_expression addObject:operation];
    }

    
    // TODO: check for non-negative numbers

    if ([operation isEqual:@"sqrt"])
        self.operand = sqrt(self.operand);
    else if ([operation isEqual:@"+/-"])
        self.operand = - self.operand;
    else if ([operation isEqual:@"1/x"])
        self.operand = 1 / self.operand;
    else if ([operation isEqual:@"sin"])
        self.operand = sin(self.operand);
    else if ([operation isEqual:@"cos"])
        self.operand = cos(self.operand);
    else if ([operation isEqual:@"mem+"])
        _valueInMemory = self.valueInMemory + self.operand;
    else if ([operation isEqual:@"C"]){
        self.operand = 0;
        self.waitingOperand = 0;
        self.waitingOperation = nil;
        _valueInMemory = 0;
        [_expression removeAllObjects];
        self.doesExpressionHaveVariable = NO;
    }
    else {
        [self performWaitingOperation];
        self.waitingOperation = operation;
        self.waitingOperand = self.operand;
    }

    if (self.doesExpressionHaveVariable == YES)
        return 0;
    else
        return self.operand;
}

- (void)performWaitingOperation
{      
    if([@"+" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand + self.operand;
    else if([@"-" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand - self.operand;
    else if([@"*" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand * self.operand;
    else if([@"/" isEqualToString:self.waitingOperation])
        if(self.operand) self.operand = self.waitingOperand / self.operand;
}

- (void)setVariableAsOperand:(NSString *)variableName
{
    [_expression addObject:variableName];
    self.doesExpressionHaveVariable = YES;
    self.latestVariableIndex = [_expression count];
}

- (NSString *)descriptionOfExpression:(id)anExpression
{
    NSMutableString *expressionDescription = [[NSMutableString alloc] init];
    
    for (NSString *item in anExpression) {
        [expressionDescription appendString:item];
         }
    return expressionDescription;
}

- (id)expressionForPropertyList:(id)propertyList
{
    // TODO:
    return nil;
}
@end
