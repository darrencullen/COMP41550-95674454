//
//  CalcModel.m
//  Calc
//
//  Created by darren cullen on 28/01/2013.
//  Copyright (c) 2013 95674454. All rights reserved.
//

#import "CalcModel.h"
#import "DDMathParser.h"

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

+ (double)evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variable
{
    NSMutableString *expressionToEvaluate = [[NSMutableString alloc] init];
    
    // TODO: at this point, use waiting operand etc
    // loop. if numeric - set operand. if not - performoperation.
    
    for (NSString *item in anExpression) {
        if (variable[item]){
            [expressionToEvaluate appendString:[variable objectForKey:item]];
        } else {
            [expressionToEvaluate appendString:item];
        }
        NSLog(@"expression: %@:",expressionToEvaluate);
    }
    
    expressionToEvaluate = [[expressionToEvaluate stringByReplacingOccurrencesOfString:@"="
                                                                            withString:@""]
                            mutableCopy];
    
    double result = [[expressionToEvaluate numberByEvaluatingString] doubleValue];
    return result;
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

- (double)performOperation:(NSString *)operation
{
    // TODO: fix solving of expression
    
    _operationError = NO;
    
    if ([operation isEqual:@"C"]){
        self.operand = 0;
        self.waitingOperand = 0;
        self.waitingOperation = nil;
        _valueInMemory = 0;
        [_expression removeAllObjects];
        
        return 0;
    }
    
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
    
    [self buildExpression:operation];
    
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
    else {
        [self performWaitingOperation];
        self.waitingOperation = operation;
        self.waitingOperand = self.operand;
    }
    
    if ([self doesExpressionHaveVariable]){
        if ([operation isEqualToString:@"="]){
            _operationError = YES;
            _operationErrorMessage = @"Variable value required - use Solve expression";
        }
        return 0;
    }
    else
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

- (void)buildExpression:(NSString *)operation
{
    // if expression being built from property list then waitingOperation is nil
    if (!(self.waitingOperation) && (self.operand == 0) && (self.waitingOperand == 0)){
        NSString *lastExpressionItem = [[NSString alloc] initWithString:[_expression lastObject]];
        if ([lastExpressionItem isEqual:@"="]){
            [_expression removeLastObject];
            [_expression addObject:operation];
        }
        return;

    }
    
    // if operation pressed after =, then replace = with operation and allow expression to be built upon
    if ([self.waitingOperation isEqual:@"="]){
        if (![operation isEqual:@"="]){
            [_expression removeLastObject];
            [_expression addObject:operation];
        }
        return;
    }
    
    // if previous operation was sqrt, sin or cos, just append operation
    if ([_expression count] > 0){
        NSString *previousItemInExpression = [[NSString alloc] initWithString:[_expression lastObject]];
        if ([self isScientificFunction:previousItemInExpression]){
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
    return;
}

- (BOOL)isScientificFunction:(NSString *)function
{
    if (([function isEqual:@"sin"]) || ([function isEqual:@"cos"]) || ([function isEqual:@"sin"]))
        return YES;
    else return NO;
}

- (BOOL)isVariableExpressionItem:(NSString *)function
{
    if (([function isEqual:@"a"]) || ([function isEqual:@"b"]) || ([function isEqual:@"x"]))
        return YES;
    else return NO;
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
    //self.expressionVariableSet = YES;
    self.latestVariableIndex = [_expression count];
}

- (NSString *)descriptionOfExpression:(id)anExpression
{
    NSMutableArray *describeExpression = [[NSMutableArray alloc] init];
    NSMutableString *expressionDescription = [[NSMutableString alloc] init];
    
    for (NSString *item in anExpression) {
        if ([self isScientificFunction:item]){
            [describeExpression insertObject:@"(" atIndex:0];
            [describeExpression insertObject:item atIndex:0];
            [describeExpression addObject:@")"];
        } else {
            [describeExpression addObject:item];
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
