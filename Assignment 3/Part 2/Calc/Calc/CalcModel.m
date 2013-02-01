//
//  CalcModel.m
//  Calc
//
//  Created by darren cullen on 28/01/2013.
//  Copyright (c) 2013 95674454. All rights reserved.
//

#import "CalcModel.h"

@implementation CalcModel


- (double)performOperation:(NSString *)operation
{
    self.operationError = NO;
    
    if (([self.waitingOperation isEqual:@"/"]) && (self.operand == 0)){
        self.operationError = YES;
        self.operationErrorMessage = @"Division by zero not allowed";
        self.operand = 0;
        self.waitingOperand = 0;
        self.waitingOperation = nil;
        return 0;
    }
    
    if (([operation isEqual:@"sqrt"]) && (self.operand < 0)){
        self.operationError = YES;
        self.operationErrorMessage = @"Square root of negative number not allowed";
        self.operand = 0;
        self.waitingOperand = 0;
        self.waitingOperation = nil;
        return 0;
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
        self.valueInMemory = self.valueInMemory + self.operand;
    else if ([operation isEqual:@"C"]){
        self.operand = 0;
        self.waitingOperand = 0;
        self.waitingOperation = nil;
        self.valueInMemory = 0;
    }
    else {
        [self performWaitingOperation];
        self.waitingOperation = operation;
        self.waitingOperand = self.operand;
    }
    
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

@end
