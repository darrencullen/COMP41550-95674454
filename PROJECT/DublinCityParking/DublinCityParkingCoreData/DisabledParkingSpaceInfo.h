//
//  DisabledParkingSpaceInfo.h
//  DublinCityParking
//
//  Created by darren cullen on 08/03/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DisabledParkingSpaceInfo : NSManagedObject

@property (nonatomic, retain) NSString *street;
@property (nonatomic, retain) NSString *postCode;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSString *spaces;
@property (nonatomic) Boolean favourite;

@end
