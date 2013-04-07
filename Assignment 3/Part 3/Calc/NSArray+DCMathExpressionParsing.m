//
//  NSArray+DCMathExpressionParsing.m
//  Calc2
//
//  Created by darren cullen on 19/03/2013.
//  Copyright (c) 2013 95674454. All rights reserved.
//

#import "NSArray+DCMathExpressionParsing.h"

@implementation NSArray (DCMathExpressionParsing)

- (double)evaluateMathematicalExpressionWithVariables:(NSArray *)anExpression usingVariableValues:(NSDictionary *)variables
{
    double operand = 0;
    double waitingOperand = 0;
    NSString *waitingOperation;
    NSMutableArray *describeExpression = [[NSMutableArray alloc] init];
    
    // substitute the variable values
    for (NSString *item in anExpression) {        
        if (([item isEqualToString:@"a"]) || ([item isEqualToString:@"b"]) || ([item isEqualToString:@"x"])){
            if (variables[item]){
                [describeExpression addObject:[[NSString alloc] initWithFormat:@"%@", [variables objectForKey:item]]];
            } else {
                [describeExpression addObject:item];
            }
        } else [describeExpression addObject:item];
    }
    
    // iterate through the expression and solve
    NSMutableArray *waitingExpressionOperations;
    NSMutableString *waitingScientificOperation;

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    for (NSString *item in describeExpression){
        NSNumber *number = [formatter numberFromString:item];
        
        if (number != nil){
            if ((!waitingOperation) && (!waitingScientificOperation))
                operand = [item doubleValue];
            else {
                waitingOperand = [item doubleValue];
                if (waitingScientificOperation){
                    if ([waitingScientificOperation isEqualToString:@"sin"])
                        operand += sin(waitingOperand);
                    else if ([waitingScientificOperation isEqualToString:@"cos"])
                        operand += cos(waitingOperand);
                    
                    waitingScientificOperation = nil;
                    
                } else {
                    
                    if([@"+" isEqualToString:waitingOperation])
                        operand = waitingOperand + operand;
                    else if([@"-" isEqualToString:waitingOperation])
                        operand = waitingOperand - operand;
                    else if([@"*" isEqualToString:waitingOperation])
                        operand = waitingOperand * operand;
                    else if ([waitingOperation isEqualToString:@"sin"])
                        operand = sin(operand);
                    else if ([waitingOperation isEqualToString:@"cos"])
                        operand = cos(operand);
                    else if([@"/" isEqualToString:waitingOperation])
                        if(operand) operand = waitingOperand / operand;
                }
            }
            
        } else if (([item isEqualToString:@"+"]) || ([item isEqualToString:@"-"]) || ([item isEqualToString:@"*"]) || ([item isEqualToString:@"/"])){
            waitingOperation = item;
            
        } else if (([item isEqualToString:@"sqrt"]) || ([item isEqualToString:@"1/x"]) || ([item isEqualToString:@"+/-"])){
            if (!waitingExpressionOperations){
                waitingExpressionOperations = [[NSMutableArray alloc] init];
                [waitingExpressionOperations addObject:item];
            }
        } else if (([item isEqualToString:@"sin"]) || ([item isEqualToString:@"cos"])){
            if (!waitingScientificOperation){
                waitingScientificOperation = [[NSMutableString alloc] initWithString:item];
            }
        }
    }
    
    // perform operations that impact the whole expression i.e. are performed on the whole expression rather than an operand within it
    if (waitingExpressionOperations){
        NSString *totalExpressionOperation;
        for (int i=[waitingExpressionOperations count]; i>0; i--) {
            totalExpressionOperation = waitingExpressionOperations[i-1];
            if ([totalExpressionOperation isEqualToString:@"sqrt"]){
                if (operand < 0)
                    operand = 0;
                else
                    operand = sqrt(operand);
            }
            else if ([totalExpressionOperation isEqualToString:@"+/-"]){
                if (operand < 0)
                    operand = 0;
                else
                    operand = - operand;
            }
            else if ([totalExpressionOperation isEqualToString:@"1/x"]){
                if (operand < 0)
                    operand = 0;
                else
                    operand = 1 / operand;
            }
        }
    }
    
    return operand;
}

@end


