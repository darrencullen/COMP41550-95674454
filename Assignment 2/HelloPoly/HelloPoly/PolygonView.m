//
//  PolygonView.m
//  HelloPoly
//
//  Created by darren cullen on 16/01/2013.
//  Copyright (c) 2013 COMP41550. All rights reserved.
//

#import "PolygonView.h"

@interface PolygonView ()
@property (nonatomic, strong) NSArray *objectPoints;
@end

@implementation PolygonView

- (void)setNumberOfSides:(int)numberOfSides{   
    self.objectPoints = [PolygonView pointsForPolygonInRect:self.bounds numberOfSides:numberOfSides];
    [self setNeedsDisplay];
    NSLog(@"Number of sides = %d", numberOfSides);
}

+ (NSArray *)pointsForPolygonInRect:(CGRect)rect numberOfSides:(int)numberOfSides {
    CGPoint center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
    float radius = 0.9 * center.x; NSMutableArray *result = [NSMutableArray array];
    float angle = (2.0 * M_PI) / numberOfSides;
    float exteriorAngle = M_PI - angle;
    float rotationDelta = angle - (0.5 * exteriorAngle);
    for (int currentAngle = 0; currentAngle < numberOfSides; currentAngle++) {
        float newAngle = (angle * currentAngle) - rotationDelta;
        float curX = cos(newAngle) * radius;
        float curY = sin(newAngle) * radius;
        [result addObject:[NSValue valueWithCGPoint:
                           CGPointMake(center.x+curX,center.y+curY)]];
    }
    return result;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setStroke];
    CGContextSetLineWidth(context, 3.0);
    
    CGPoint point = [[self.objectPoints objectAtIndex:0] CGPointValue];
    CGContextMoveToPoint(context, point.x, point.y);
    for (int i = 0; i < self.objectPoints.count; i++){
        point = [[self.objectPoints objectAtIndex:i] CGPointValue];
        CGContextAddLineToPoint(context, point.x, point.y);
    }
    CGContextClosePath(context);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor lightTextColor].CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
