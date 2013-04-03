//
//  NSArray+DCMathExpressionParsing.h
//  Calc2
//
//  Created by darren cullen on 19/03/2013.
//  Copyright (c) 2013 95674454. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (DCMathExpressionParsing)

- (double)evaluateMathematicalExpressionWithVariables:(NSArray *)anExpression usingVariableValues:(NSDictionary *)variables;

@end
