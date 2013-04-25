//
//  TrafficCameraInfo.h
//  DublinCityParkingCoreData
//
//  Created by darren cullen on 11/04/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TrafficCameraInfo : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * postCode;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic) Boolean favourite;

@end
