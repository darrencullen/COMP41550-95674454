//
//  CarparkInfo.h
//  DublinCityParkingCoreData
//
//  Created by darren cullen on 21/02/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

//#import <Foundation/Foundation.h>
//#import <CoreData/CoreData.h>

@class CarparkDetails;

@interface CarparkInfo : NSManagedObject

@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *availableSpaces;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *lastUpdated;
@property (nonatomic) Boolean favourite;
@property (nonatomic, retain) CarparkDetails *details;

@end
