//
//  GraphView.m
//  AxisDrawing
//
//  Created by CSI COMP41550 on 10/02/2012.
//  Copyright (c) 2012 UCD. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setGraphScale:(double) graphScale
{
    if (graphScale == 0){
        self.scale = 1;
    } else {
        self.scale = graphScale;
    }
}

- (void)drawRect:(CGRect)rect
{
    //[AxesDrawer drawAxesInRect:rect originAtPoint:CGPointMake(CGRectGetMidX(rect),CGRectGetMidY(rect)) scale:self.zoomLevel];
    
    //Get the CGContext from this view
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 3.0);
    
    // Draw the axes using the AxesDrawer helper class.
    //[AxesDrawer drawAxesInRect:self.graphBounds originAtPoint:self.axisOrigin scale:self.scale];
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:CGPointMake(CGRectGetMidX(rect),CGRectGetMidY(rect)) scale:self.scale];
    
//    // Set the line width and colour of the graph lines
//    CGContextSetLineWidth(context, 1.0);
//    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor]CGColor]);
    
    CGContextBeginPath(context);
    
    CGFloat startingX = self.bounds.origin.x;
    CGFloat endingX = self.bounds.origin.x + self.bounds.size.width;
    CGFloat increment = 1/self.contentScaleFactor; // To enable iteration over pixels
    
    BOOL firstPoint = YES;
    
    // Iterate over the horizontal pixels, plotting the corresponding y values
    for (CGFloat x = startingX; x<= endingX; x+=increment) {
        // Identify the starting X point for the curve and convert to graph coordinates.
        // Then retrieve the corresponding Y value and convert it back to view coordindates
        CGPoint coordinate;
        coordinate.x = x;
        //coordinate = [self convertToGraphCoordinateFromViewCoordinate:coordinate];
        coordinate.y = x * 2; //[self.dataSource YValueForXValue:coordinate.x inGraphView:self];
       // coordinate = [self convertToViewCoordinateFromGraphCoordinate:coordinate];
        coordinate.x = x;
        
        // Handle the edge cases
        if (coordinate.y == NAN || coordinate.y == INFINITY || coordinate.y == -INFINITY)
            continue;
        
        if (firstPoint) {
            CGContextMoveToPoint(context, coordinate.x, coordinate.y);
            firstPoint = NO;
        }
        
        CGContextAddLineToPoint(context, coordinate.x, coordinate.y);
        
    }  
    CGContextStrokePath(context);
}

// ==========

//- (void)setAxisOrigin:(CGPoint)axisOrigin {
//    
//    // Do nothing is the axis origin hasn't changed
//    if (_axisOrigin.x == axisOrigin.x && _axisOrigin.y == axisOrigin.y) return;
//    
//    _axisOrigin = axisOrigin;
//    
//    // Ask the delegate to store the scale
//    [self.dataSource storeAxisOriginX:_axisOrigin.x
//                       andAxisOriginY:_axisOrigin.y
//                         ForGraphView:self];
//    
//    // Redraw whenever the axis origin is changed
//    [self setNeedsDisplay];
//}
//
//- (CGPoint)axisOrigin {
//    
//    // Set it to the middle of the graphBounds, if if the current origin is (0,0)
//    if (!_axisOrigin.x && !_axisOrigin.y) {
//        _axisOrigin.x = (self.graphBounds.origin.x + self.graphBounds.size.width) / 2;
//        _axisOrigin.y = (self.graphBounds.origin.y + self.graphBounds.size.height) / 2;
//    }
//    return _axisOrigin;
//}

@end
