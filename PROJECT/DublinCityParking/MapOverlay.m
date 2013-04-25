//
//  MapOverlay.m
//  DublinCityParking
//
//  Created by darren cullen on 27/02/2013.
//  Copyright (c) 2013 dcdevstudios. All rights reserved.
//

#import "MapOverlay.h"

@implementation MapOverlay
@synthesize overlayTitle = _overlayTitle;
@synthesize overlaySubTitle = _overlaySubTitle;
@synthesize overlayTitleAddendum = _overlayTitleAddendum;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)title subTitle:(NSString *)subTitle titleAddendum:(NSString*)titleAddendum coordinate:(CLLocationCoordinate2D)overlayCoordinate {
    if ((self = [super init])) {
        _overlayTitle = [title copy];
        _overlaySubTitle = [subTitle copy];
        _overlayTitleAddendum = [titleAddendum copy];
        _coordinate = overlayCoordinate;
    }
    return self;
}

- (NSString *)title {
    if ([_overlayTitle isKindOfClass:[NSNull class]])
        return @"Location Unknown";
    else
    {
        if (!_overlayTitleAddendum)
            return [NSString stringWithFormat:@"%@", _overlayTitle];
        else
            return [NSString stringWithFormat:@"%@ (%@)", _overlayTitle, _overlayTitleAddendum];
    }
        
}

- (NSString *)subtitle {
    return _overlaySubTitle;
}

@end
