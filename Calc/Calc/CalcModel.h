//
//  CalcModel.h
//  Calc
//
//  Created by darren cullen on 28/01/2013.
//  Copyright (c) 2013 95674454. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalcModel : NSObject

@property (nonatomic) double operand;
@property (nonatomic) double waitingOperand;
@property (nonatomic, strong) NSString *waitingOperation;
@property (nonatomic) double valueInMemory;
@property (nonatomic) BOOL operationError;
@property (nonatomic, strong) NSString *operationErrorMessage;

- (double)performOperation:(NSString *)operation;

@end
