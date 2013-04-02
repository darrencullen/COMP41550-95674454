//
//  GraphView.m
//  AxisDrawing
//
//  Created by CSI COMP41550 on 10/02/2012.
//  Copyright (c) 2012 UCD. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@interface GraphView ()
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic) CGPoint graphOrigin;
@end

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
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{    
    //Get the CGContext from this view
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    int scale = self.scale;
    CGPoint center = self.graphOrigin;
    center.x += self.bounds.size.width / 2 + self.bounds.origin.x;
    center.y += self.bounds.size.height / 2 + self.bounds.origin.y;
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:center scale:scale];
    
 //   self.graphOrigin = CGPointMake(CGRectGetMidX(rect),CGRectGetMidY(rect));
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:center scale:self.scale];
    
    // Set the line width and colour of the graph lines
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor]CGColor]);
    
    CGContextBeginPath(context);

    BOOL firstPoint = YES;
    
    CGFloat startingX = self.bounds.origin.x;
    CGFloat endingX = self.bounds.origin.x + self.bounds.size.width;
    CGFloat increment = 1/self.contentScaleFactor; // To enable iteration over pixels
    
    //Iterate over the horizontal pixels, plotting the corresponding y values
    for (CGFloat x = startingX; x<= endingX; x+=increment) {
        // Identify the starting X point for the curve and convert to graph coordinates.
        // Then retrieve the corresponding Y value and convert it back to view coordindates
        
        CGPoint coordinate;
        coordinate.x = x;

        
       // return -[self.delegate YValueForX:(x - center.x) / scale] * scale + center.y;
        
        
        //coordinate.y = [self.delegate getValueForYAxisFromValueForXAxis:self xAxisValue:coordinate.x];
        coordinate.y = [self yFromX:x withCenter:center andScale:scale];

        
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


- (int)yFromX:(int)x withCenter:(CGPoint)center andScale:(int)scale
{    
    return -[self.delegate getValueForYAxisFromValueForXAxis:self xAxisValue:(x - center.x) / scale] * scale + center.y;
}


@end
