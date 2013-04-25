//
//  AvailableSpacesDownloader.h
//  DublinCityParkingCoreData
//
//  Created by darren cullen on 01/03/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Carpark.h"
#import "CarparkInfo.h"


@protocol AvailableSpacesDownloaderDelegate;
@interface AvailableSpacesDownloader : NSOperation  <NSXMLParserDelegate>
@property (nonatomic, assign) id <AvailableSpacesDownloaderDelegate> delegate;


@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, readonly) NSMutableArray *carparks;

-(id) loadXMLByURL:(NSString *)urlString;
@end

@protocol AvailableSpacesDownloaderDelegate <NSObject>
- (void) availableSpacesDownloaderDidFinish:(AvailableSpacesDownloader *)downloader;
@end
