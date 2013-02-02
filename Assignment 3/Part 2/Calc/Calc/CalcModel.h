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
@property (readonly, strong) id expression;
@property (readonly) BOOL operationError;
@property (readonly, strong) NSString *operationErrorMessage;

- (double)performOperation:(NSString *)operation;
- (void)setVariableAsOperand:(NSString *)variableName;


+ (double)evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variable;
+ (NSSet *)variablesInExpression:(id)anExpression;
- (NSString *)descriptionOfExpression:(id)anExpression;
+ (id)propertyListForExpression:(id)anExpression;
- (id)expressionForPropertyList:(id)propertyList;

@end
