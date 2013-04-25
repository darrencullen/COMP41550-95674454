//
//  main.m
//  DublinCityParkingCoreDataImport
//
//  Created by darren cullen on 21/02/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import "CarparkInfo.h"
#import "CarparkDetails.h"
#import "DisabledParkingSpaceInfo.h"
#import "TrafficCameraInfo.h"

static NSManagedObjectModel *managedObjectModel()
{
    static NSManagedObjectModel *model = nil;
    if (model != nil) {
        return model;
    }
    
    //    NSString *path = @"DublinCityParkingCoreDataImport";
    //    path = [path stringByDeletingPathExtension];
    NSString *path = @"DublinCityParkingCoreData";
    NSURL *modelURL = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"momd"]];
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return model;
}

static NSManagedObjectContext *managedObjectContext()
{
    static NSManagedObjectContext *context = nil;
    if (context != nil) {
        return context;
    }
    
    @autoreleasepool {
        context = [[NSManagedObjectContext alloc] init];
        
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel()];
        [context setPersistentStoreCoordinator:coordinator];
        
        NSString *STORE_TYPE = NSSQLiteStoreType;
        
        NSString *path = [[NSProcessInfo processInfo] arguments][0];
        path = [path stringByDeletingPathExtension];
        NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"sqlite"]];
        
        NSError *error;
        NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:STORE_TYPE configuration:nil URL:url options:nil error:&error];
        
        if (newStore == nil) {
            NSLog(@"Store Configuration Failure %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
        }
        
        //===================================================================================================
        
        NSError* err3 = nil;
        NSString* dataPath3 = [[NSBundle mainBundle] pathForResource:@"TrafficCamerasImport" ofType:@"json"];
        NSArray* trafficCameras = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath3]
                                                                  options:kNilOptions
                                                                    error:&err3];
        
        
        
        NSLog(@"Imported DisabledSpaces: %@", trafficCameras);
        NSLog(@"SQL Database location: %@", url);
        
        for (id trafficCamera in trafficCameras) {
            NSLog(@"%@", trafficCamera);
            
            TrafficCameraInfo *trafficCameraInfo = [NSEntityDescription
                                                          insertNewObjectForEntityForName:@"TrafficCameraInfo"
                                                          inManagedObjectContext:context];
            
            trafficCameraInfo.name = [trafficCamera objectForKey:@"name"];
            trafficCameraInfo.postCode = [trafficCamera objectForKey:@"postCode"];
            trafficCameraInfo.latitude = [trafficCamera objectForKey:@"latitude"];
            trafficCameraInfo.longitude = [trafficCamera objectForKey:@"longitude"];
            trafficCameraInfo.code = [trafficCamera objectForKey:@"code"];
            trafficCameraInfo.url = [trafficCamera objectForKey:@"url"];
            trafficCameraInfo.favourite = NO;
            
            NSError *error;
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
        
        
        //===================================================================================================
        
        NSError* err = nil;
        NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"DisabledSpacesImport" ofType:@"json"];
        NSArray* DisabledSpaces = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                                  options:kNilOptions
                                                                    error:&err];
        
        
        
        NSLog(@"Imported DisabledSpaces: %@", DisabledSpaces);
        NSLog(@"SQL Database location: %@", url);
        
        for (id disabledSpace in DisabledSpaces) {
            NSLog(@"%@", disabledSpace);
            
            DisabledParkingSpaceInfo *disableSpaceInfo = [NSEntityDescription
                                                          insertNewObjectForEntityForName:@"DisabledParkingSpaceInfo"
                                                          inManagedObjectContext:context];
            
            disableSpaceInfo.street = [disabledSpace objectForKey:@"street"];
            disableSpaceInfo.postCode = [disabledSpace objectForKey:@"postCode"];
            disableSpaceInfo.latitude = [disabledSpace objectForKey:@"latitude"];
            disableSpaceInfo.longitude = [disabledSpace objectForKey:@"longitude"];
            disableSpaceInfo.spaces = [disabledSpace objectForKey:@"spaces"];
            disableSpaceInfo.favourite = NO;
            
            
            NSError *error;
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
        
        
        //===================================================================================================
        
        
        NSError* err2 = nil;
        NSString* dataPath2 = [[NSBundle mainBundle] pathForResource:@"CarparksImport" ofType:@"json"];
        NSArray* Carparks = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath2]
                                                            options:kNilOptions
                                                              error:&err2];
        NSLog(@"Imported Carparks: %@", Carparks);
        NSLog(@"SQL Database location: %@", url);
        
        [Carparks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CarparkInfo *carparkInfo = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"CarparkInfo"
                                        inManagedObjectContext:context];
            
            carparkInfo.address = [obj objectForKey:@"address"];
            carparkInfo.availableSpaces = [obj objectForKey:@"availableSpaces"];
            carparkInfo.code = [obj objectForKey:@"code"];
            carparkInfo.name = [obj objectForKey:@"name"];
            carparkInfo.favourite = NO;
            carparkInfo.lastUpdated = @"N/A";
            
            CarparkDetails *carparkDetails = [NSEntityDescription
                                              insertNewObjectForEntityForName:@"CarparkDetails"
                                              inManagedObjectContext:context];
            
            carparkDetails.directions = [obj objectForKey:@"directions"];
            carparkDetails.disabledSpaces = [obj objectForKey:@"disabledSpaces"];
            carparkDetails.heightRestrictions = [obj objectForKey:@"heightRestrictions"];
            carparkDetails.hourlyRate = [obj objectForKey:@"hourlyRate"];
            carparkDetails.latitude = [[obj objectForKey:@"latitude"] doubleValue];
            carparkDetails.longitude = [[obj objectForKey:@"longitude"] doubleValue];
            carparkDetails.openingHours = [obj objectForKey:@"openingHours"];
            carparkDetails.otherRate1 = [obj objectForKey:@"otherRate1"];
            carparkDetails.otherRate2 = [obj objectForKey:@"otherRate2"];
            carparkDetails.phoneNumber = [obj objectForKey:@"phoneNumber"];
            carparkDetails.region = [obj objectForKey:@"region"];
            carparkDetails.services = [obj objectForKey:@"services"];
            carparkDetails.totalSpaces = [obj objectForKey:@"totalSpaces"];
            
            carparkDetails.info = carparkInfo;
            carparkInfo.details = carparkDetails;
            
            NSError *error;
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }];
        
        // Test listing all FailedBankInfos from the store
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CarparkInfo"
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        for (CarparkInfo *info in fetchedObjects) {
            NSLog(@"Name: %@", info.name);
            CarparkDetails *details = info.details;
            NSLog(@"Region: %@", details.region);
            NSLog(@"Rate: %@", details.otherRate1);
            NSLog(@"Hours: %@", details.openingHours);
            NSLog(@"TotalSpaces: %@", details.totalSpaces);
        }
        
        //===================================================================================================
        
    }
    return context;
}

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        // Create the managed object context
        NSManagedObjectContext *context = managedObjectContext();
        
        // Custom code here...
        // Save the managed object context
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error while saving %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
            exit(1);
        }
    }
    return 0;
}

