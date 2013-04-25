//
//  AvailableSpacesDownloader.m
//  DublinCityParkingCoreData
//
//  Created by darren cullen on 01/03/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import "AvailableSpacesDownloader.h"

@interface AvailableSpacesDownloader()
@property (nonatomic, readwrite, strong) NSMutableArray *carparks;
@end

@implementation AvailableSpacesDownloader
{
    NSXMLParser *parser;
    Carpark *currentCarpark;
}

-(id) loadXMLByURL:(NSString *)urlString delegate:(id<AvailableSpacesDownloaderDelegate>)theDelegate
{
    _carparks = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    return self;
}

- (void)main {
    
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.photoRecord.URL];
        
        if (self.isCancelled) {
            imageData = nil;
            return;
        }
        
        if (imageData) {
            UIImage *downloadedImage = [UIImage imageWithData:imageData];
            self.photoRecord.image = downloadedImage;
        }
        else {
            self.photoRecord.failed = YES;
        }
        
        imageData = nil;
        
        if (self.isCancelled)
            return;
        
        // 5
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(imageDownloaderDidFinish:) withObject:self waitUntilDone:NO];
        
    }
}
@end
