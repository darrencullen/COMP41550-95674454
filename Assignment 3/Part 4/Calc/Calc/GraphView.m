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

- (void) setGraphScale:(double) scale
{    
    // Do nothing if the scale hasn't changed
	if (self.graphScale == scale) return;
	
	_graphScale = scale;
    [self.delegate setGraphScale:self graphScale:_graphScale];
     
	[self setNeedsDisplay];
}

- (void) setGraphOrigin:(CGPoint) origin
{
    // Do nothing if the origin hasn't changed
	if (CGPointEqualToPoint(self.graphOrigin,origin)) return;
	
	_graphOrigin = origin;
     [self.delegate setGraphOrigin:self graphAxisOrigin:_graphOrigin];
    
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{    
    //Get the CGContext from this view
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    int scale = self.graphScale;
    CGPoint center = self.graphOrigin;
    center.x += self.bounds.size.width / 2 + self.bounds.origin.x;
    center.y += self.bounds.size.height / 2 + self.bounds.origin.y;
        
    [AxesDrawer drawAxesInRect:rect originAtPoint:center scale:self.graphScale];
    
    // Set the line width and colour of the graph lines
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor]CGColor]);
    
    CGContextBeginPath(context);

    BOOL firstPoint = YES;
    
    CGFloat firstXAxisValue = self.bounds.origin.x;
    CGFloat lastXAxisValue = self.bounds.origin.x + self.bounds.size.width;
    CGFloat increment = 1/self.contentScaleFactor; // To enable iteration over pixels
    
    // Iterate over the horizontal pixels, plotting the corresponding y values
    for (CGFloat x = firstXAxisValue; x<= lastXAxisValue; x+=increment) {
        // for each x, calculate y based upon center and scale of graph
        CGPoint coordinate;
        coordinate.x = x;
        coordinate.y = -[self.delegate getValueForYAxisFromValueForXAxis:self xAxisValue:(x - center.x) / scale] * scale + center.y;
        
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

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state != UIGestureRecognizerStateChanged) &&
        (gesture.state != UIGestureRecognizerStateEnded)) return;
    [self.delegate setGraphScale:self graphScale:self.graphScale *= gesture.scale];
    gesture.scale = 1;
}

- (void)doubleTap:(UITapGestureRecognizer *)gesture
{
    self.graphOrigin = CGPointZero;
}

-(void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state==UIGestureRecognizerStateChanged || gesture.state==UIGestureRecognizerStateEnded) {
        CGPoint panLocation=[gesture translationInView:self];
        
        self.graphOrigin=CGPointMake(self.graphOrigin.x + panLocation.x, self.graphOrigin.y+ panLocation.y);
        [gesture setTranslation:CGPointZero inView:self];
    }
}

@end
