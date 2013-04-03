//
//  CalcModel.m
//  Calc
//
//  Created by darren cullen on 28/01/2013.
//  Copyright (c) 2013 95674454. All rights reserved.
//

#import "CalcModel.h"
#import "NSArray+DCMathExpressionParsing.h"

@interface CalcModel()
//@property (nonatomic) BOOL expressionVariableSet;
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

+ (double)evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variables
{
    NSArray *describeExpression = [[NSArray alloc] init];
    double result = [describeExpression evaluateMathematicalExpressionWithVariables:anExpression usingVariableValues:variables];
    
    return result;
}

+ (NSSet *)variablesInExpression:(id)anExpression
{
    NSMutableSet *expressionVariables = [[NSMutableSet alloc] init];
    
    for (NSString *item in anExpression) {
        if (([item isEqualToString:@"a"]) || ([item isEqualToString:@"b"]) || ([item isEqualToString:@"x"])){
            if (![expressionVariables containsObject:item])
                [expressionVariables addObject:item];
        }
    }
    
    if ([expressionVariables count] == 0)
        return nil;
    else
        return expressionVariables;
}

- (double)performOperation:(NSString *)operation
{
    _operationError = NO;
    
    if ([operation isEqualToString:@"C"]){
        self.operand = 0;
        self.waitingOperand = 0;
        self.waitingOperation = nil;
        _valueInMemory = 0;
        [_expression removeAllObjects];
        
        return 0;
    }
    
    if (([self.waitingOperation isEqualToString:@"/"]) && (self.operand == 0)){
        _operationError = YES;
        _operationErrorMessage = @"Division by zero not allowed";
        self.operand = 0;
        self.waitingOperand = 0;
        self.waitingOperation = nil;
        return 0;
    }
    
    if (([operation isEqualToString:@"sqrt"]) && (self.operand < 0)){
        _operationError = YES;
        _operationErrorMessage = @"Square root of negative number not allowed";
        self.operand = 0;
        self.waitingOperand = 0;
        self.waitingOperation = nil;
        return 0;
    }
    
    [self buildExpression:operation];
    
    if ([operation isEqualToString:@"sqrt"])
        self.operand = sqrt(self.operand);
    else if ([operation isEqualToString:@"+/-"])
        self.operand = - self.operand;
    else if ([operation isEqualToString:@"1/x"])
        self.operand = 1 / self.operand;
    //    else if ([operation isEqualToString:@"sin"])
    //        self.operand = sin(self.operand);
    //    else if ([operation isEqualToString:@"cos"])
    //        self.operand = cos(self.operand);
    else if ([operation isEqualToString:@"mem+"])
        _valueInMemory = self.valueInMemory + self.operand;
    else if ([self doesExpressionHaveVariable]){
        if ([operation isEqualToString:@"="]){
            _operationError = YES;
            _operationErrorMessage = @"Variable value required - use Solve expression";
        }
        return 0;
        
    } else {
        if ([self isExpressionComplex])
            [self solveExpression:_expression];
        else
            [self performWaitingOperation];
        
        self.waitingOperation = operation;
        self.waitingOperand = self.operand;
    }
    
    NSLog(@"performOperation: %@", _expression);
    return self.operand;
}

- (BOOL)doesExpressionHaveVariable
{
    for (NSString *item in _expression) {
        if ([self isVariableExpressionItem:item])
            return YES;
    }
    return NO;
}

- (BOOL)doesExpressionHaveScientificNotation
{
    for (NSString *item in _expression) {
        if ([self isScientificOperation:item])
            return YES;
    }
    return NO;
}

- (BOOL)isExpressionComplex
{
    if (([self doesExpressionHaveScientificNotation]) || ([self doesExpressionHaveVariable]))
        return YES;
    else
        return NO;
}

- (void)buildExpression:(NSString *)operation
{
    // if expression being built from property list then waitingOperation is nil
    if (!(self.waitingOperation) && (self.operand == 0) && (self.waitingOperand == 0)){
        if ([_expression count] > 0){
            NSString *lastExpressionItem = [[NSString alloc] initWithString:[_expression lastObject]];
            if ([lastExpressionItem isEqualToString:@"="]){
                [_expression removeLastObject];
                [_expression addObject:operation];
            }
        } else
            [_expression addObject:operation];
        
        return;
    }
    
    // if operation pressed after =, then replace = with operation and allow expression to be built upon
    if ([self.waitingOperation isEqualToString:@"="]){
        if (![operation isEqual:@"="]){
            [_expression removeLastObject];
            [_expression addObject:operation];
        }
        return;
    }
    
    if ([self isScientificOperation:operation]){
        [_expression addObject:operation];
        self.waitingOperand = 0;
        return;
    }
    
    // if previous operation was sqrt, sin or cos, just append operation
    if ([_expression count] > 0){
        NSString *previousItemInExpression = [[NSString alloc] initWithString:[_expression lastObject]];
        if ([self isScientificOperation:previousItemInExpression]){
            NSString *trimmedOperand = [NSString stringWithFormat:@"%g",self.operand];
            [_expression addObject:trimmedOperand];
            [_expression addObject:operation];
            
            return;
        }
    }
    
    // only add operand if last object in expression wasn't a variable
    if ((self.latestVariableIndex != [_expression count]) || (self.latestVariableIndex == 0)){
        NSString *trimmedOperand = [NSString stringWithFormat:@"%g",self.operand];
        [_expression addObject:trimmedOperand];
        [_expression addObject:operation];
        return;
    }
    
    [_expression addObject:operation];
    
    NSLog(@"buildExpression: %@", _expression);
    return;
}

- (BOOL)isScientificOperation:(NSString *)operation
{
    if (([operation isEqualToString:@"sin"]) || ([operation isEqualToString:@"cos"]))
        return YES;
    else return NO;
}

- (BOOL)isRegularOperation:(NSString *)operation
{
    if (([operation isEqualToString:@"+"]) || ([operation isEqualToString:@"-"]) || ([operation isEqualToString:@"*"]) || ([operation isEqualToString:@"/"]))
        return YES;
    else return NO;
}

- (BOOL)isTotalExpressionOperation:(NSString *)operation
{
    if (([operation isEqualToString:@"sqrt"]) || ([operation isEqualToString:@"1/x"]) || ([operation isEqualToString:@"+/-"]))
        return YES;
    else return NO;
}

- (BOOL)isOperandItem:(NSString *)item
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number = [formatter numberFromString:item];
    return number != nil;
}

- (BOOL)isVariableExpressionItem:(NSString *)function
{
    if (([function isEqualToString:@"a"]) || ([function isEqualToString:@"b"]) || ([function isEqualToString:@"x"]))
        return YES;
    else return NO;
}

- (void)solveExpression:(id)anExpression
{
    NSMutableArray *waitingExpressionOperations;
    NSMutableString *waitingScientificOperation;
    
    self.operand = 0;
    self.waitingOperand = 0;
    self.waitingOperation = nil;
    
    for (NSString *item in anExpression){
        if ([self isOperandItem:item]){
            if ((!self.waitingOperation) && (!waitingScientificOperation))
                self.operand = [item doubleValue];
            else {
                self.waitingOperand = [item doubleValue];
                if (waitingScientificOperation){
                    if ([waitingScientificOperation isEqualToString:@"sin"])
                        self.operand += sin(self.waitingOperand);
                    else if ([waitingScientificOperation isEqualToString:@"cos"])
                        self.operand += cos(self.waitingOperand);
                    
                    waitingScientificOperation = nil;
                    
                } else [self performWaitingOperation];
            }
            
        } else if ([self isRegularOperation:item]){
            self.waitingOperation = item;
            
        } else if ([self isTotalExpressionOperation:item]){
            if (!waitingExpressionOperations){
                waitingExpressionOperations = [[NSMutableArray alloc] init];
                [waitingExpressionOperations addObject:item];
            }
        } else if ([self isScientificOperation:item]){
            if (!waitingScientificOperation){
                waitingScientificOperation = [[NSMutableString alloc] initWithString:item];
            }
        }
    }
    
    // perform operations that impact the whole expression i.e. are performed on the whole expression rather than an operand within it
    if (waitingExpressionOperations){
        NSString *totalExpressionOperation;
        for (int i=[waitingExpressionOperations count]; i>0; i--) {
            totalExpressionOperation = waitingExpressionOperations[i];
            if ([totalExpressionOperation isEqualToString:@"sqrt"])
                self.operand = sqrt(self.operand);
            else if ([totalExpressionOperation isEqualToString:@"+/-"])
                self.operand = - self.operand;
            else if ([totalExpressionOperation isEqualToString:@"1/x"])
                self.operand = 1 / self.operand;
        }
    }
}

- (void)performWaitingOperation
{
    if([@"+" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand + self.operand;
    else if([@"-" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand - self.operand;
    else if([@"*" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand * self.operand;
    else if ([self.waitingOperation isEqualToString:@"sin"])
        self.operand = sin(self.operand);
    else if ([self.waitingOperation isEqualToString:@"cos"])
        self.operand = cos(self.operand);
    else if([@"/" isEqualToString:self.waitingOperation])
        if(self.operand) self.operand = self.waitingOperand / self.operand;
    
    NSLog(@"performWaitingOperation: %@", _expression);
}

- (void)setVariableAsOperand:(NSString *)variableName
{
    [_expression addObject:variableName];
    //self.expressionVariableSet = YES;
    self.latestVariableIndex = [_expression count];
}

- (NSString *)descriptionOfExpression:(id)anExpression
{
    NSMutableArray *describeExpression = [[NSMutableArray alloc] init];
    NSMutableString *expressionDescription = [[NSMutableString alloc] init];
    BOOL parenthesisedParameter = NO;
    
    for (NSString *item in anExpression) {
        NSLog(@"expression: %@", _expression);
        NSLog(@"descriptionOfExpression: %@", describeExpression);
        
        if ([self isTotalExpressionOperation:item]){
            [describeExpression insertObject:@"(" atIndex:0];
            [describeExpression insertObject:item atIndex:0];
            [describeExpression addObject:@")"];
        } else if ([self isScientificOperation:item]){
            [describeExpression addObject:item];
            [describeExpression addObject:@"("];
            [describeExpression addObject:@")"];
            parenthesisedParameter = YES;
        } else if (parenthesisedParameter == YES){
            [describeExpression insertObject:item atIndex:[describeExpression count]-1];
            parenthesisedParameter = NO;
        } else {
            [describeExpression addObject:item];
            parenthesisedParameter = NO;
        }
    }
    
    for (NSString *item in describeExpression) {
        [expressionDescription appendString:item];
        NSLog(@"expression item: %@",item);
    }
    return expressionDescription;
}

- (id)expressionForPropertyList:(id)propertyList
{
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Expression.plist"];
    
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        // if not in documents, get property list from main bundle
        plistPath = [[NSBundle mainBundle] pathForResource:@"Expression" ofType:@"plist"];
    }
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    // convert static property liost into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    // assign values
    NSArray *savedExpression = [NSMutableArray arrayWithArray:[temp objectForKey:@"expressionItemsArray"]];
    if (savedExpression.count > 0)
        _expression = [savedExpression objectAtIndex:0];
    
    return nil;
}

+ (id)propertyListForExpression:(id)anExpression
{
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Expression.plist"];
    
    NSMutableArray *expressionItems = [[NSMutableArray alloc] init];
    for (NSString *expressionItem in anExpression) {
        [expressionItems addObject:expressionItem];
    }
    
    // create dictionary
    NSArray *keys = @[@"expressionID", @"expressionItemsArray"];
    NSArray *values = @[[NSString stringWithString:plistPath],
                        [NSArray arrayWithObject:expressionItems]];
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    NSString *error = nil;
    // create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    // check if plistData exists
    if(plistData)
    {
        [plistData writeToFile:plistPath atomically:YES];
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
    }
    
    return nil;
}

@end
