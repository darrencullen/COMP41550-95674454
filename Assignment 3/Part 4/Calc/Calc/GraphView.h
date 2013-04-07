//
//  GraphView.h
//  AxisDrawing
//
//  Created by CSI COMP41550 on 10/02/2012.
//  Copyright (c) 2012 UCD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDelegate <NSObject>
- (double) getValueForYAxisFromValueForXAxis:(GraphView *) graphViewDelegator xAxisValue:(double)value;
- (void) setGraphScale:(GraphView *) graphViewDelegator graphScale:(double)scale;
- (void) setGraphOrigin:(GraphView *) graphViewDelegator graphAxisOrigin:(CGPoint)origin;
@end

@interface GraphView : UIView
@property (nonatomic, assign) id <GraphViewDelegate> delegate;
@property (nonatomic) double graphScale;
@property (nonatomic) CGPoint graphOrigin;
@end

