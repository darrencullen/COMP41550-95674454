//
//  XMLParser.h
//  DublinCityParking
//
//  Created by darren cullen on 23/02/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Carpark.h"
#import "CarparkInfo.h"

@interface XMLParser : NSObject <NSXMLParserDelegate>

//@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, readonly) NSMutableArray *carparks;

-(id) loadXMLByURL:(NSString *)urlString;

@end
