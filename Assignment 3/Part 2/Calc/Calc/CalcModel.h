//
//  CalcModel.h
//  Calc
//
//  Created by darren cullen on 28/01/2013.
//  Copyright (c) 2013 95674454. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalcModel : NSObject

// store operation and operand
@property (nonatomic) double operand;
@property (nonatomic) double waitingOperand;
@property (nonatomic, strong) NSString *waitingOperation;

// store value in memory
@property (nonatomic) double valueInMemory;

// relay error details to controller
@property (readonly) BOOL operationError;
@property (readonly, strong) NSString *operationErrorMessage;

// build expression as operands and operations entered
@property (readonly, strong) id expression;

// perform calculations
- (double)performOperation:(NSString *)operation;
+ (double)evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variable;

// set variable
- (void)setVariableAsOperand:(NSString *)variableName;


+ (id)propertyListForExpression:(id)anExpression;
- (id)expressionForPropertyList:(id)propertyList;


// utility methods
+ (NSSet *)variablesInExpression:(id)anExpression;
- (NSString *)descriptionOfExpression:(id)anExpression;
@end
