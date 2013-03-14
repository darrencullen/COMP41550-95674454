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
- (void) pointsOnGraph:(GraphView *) graphViewDelegator;
- (void) setGraphZoomLevel:(double) graphZoomLevel;
@end

@interface GraphView : UIView
@property (nonatomic, assign) id <GraphViewDelegate> delegate;
@property (nonatomic) double zoomLevel;
@end

