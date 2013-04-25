//
//  MapOverlay.h
//  DublinCityParking
//
//  Created by darren cullen on 27/02/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapOverlay : NSObject <MKAnnotation> {
    NSString *overlayTitle;
    NSString *overlaySubTitle;
    NSString *overlayTitleAddendum;
    CLLocationCoordinate2D coordinate;
}

@property (copy) NSString *overlayTitle;
@property (copy) NSString *overlaySubTitle;
@property (copy) NSString *overlayTitleAddendum;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)title subTitle:(NSString *)subTitle titleAddendum:(NSString*)titleAddendum coordinate:(CLLocationCoordinate2D)coordinate;

@end

