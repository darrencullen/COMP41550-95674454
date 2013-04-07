//
//  GraphCalcViewController.m
//  GraphCalc
//
//  Created by darren cullen on 15/02/2013.
//  Copyright (c) 2013 95674454. All rights reserved.
//

#import "GraphCalcViewController.h"

@interface GraphCalcViewController ()

//@property (nonatomic) CGFloat graphScale;
@property (weak, nonatomic) IBOutlet UILabel *expressionLabel;
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (nonatomic, strong) CalcModel *calcModel;

- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;

@end

@implementation GraphCalcViewController
@synthesize splitViewBarButtonItem=_splitViewBarButtonItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    return self;
}

-(void)setGraphView:(GraphView *)graphView
{
    _graphView=graphView;
    
    // add gesture recognizers
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self.graphView action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired=2;
    [self.graphView addGestureRecognizer:doubleTap];
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        detailVC = nil;
    }
    return detailVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.expressionLabel.text = self.descriptionOfExpression;
    self.graphView.delegate = self;
    [self setGraphZoomLevel:16];
    [self setGraphOrigin:CGPointZero];
}

- (IBAction)zoomIn:(id)sender
{
    [self setGraphZoomLevel:self.graphView.graphScale + 1];
}

- (IBAction)zoomOut:(id)sender
{
    [self setGraphZoomLevel:self.graphView.graphScale - 1];
}

- (double) getValueForYAxisFromValueForXAxis:(GraphView *) graphViewDelegator xAxisValue:(double)value{
    // solve the expression with the value supplied from the view
    NSDictionary *variableSet = @{@"x" : [NSNumber numberWithDouble:value]};
    return [CalcModel evaluateExpression:self.expressionToPlot usingVariableValues:variableSet];
}

- (void) setGraphZoomLevel:(double) zoomLevel
{
    if ((zoomLevel > 70) || (zoomLevel < 0.1)) return;
    self.graphView.graphScale = zoomLevel;
    [self.graphView setNeedsDisplay];
}

- (void) setGraphOrigin:(CGPoint) origin
{
    self.graphView.graphOrigin = origin;
}

- (void) setGraphScale:(GraphView *) graphViewDelegator graphScale:(double)scale;
{
    self.graphView.graphScale = scale;
}

- (void) setExpressionToPlot:(NSArray *)expressionToPlot
{
    _expressionToPlot = expressionToPlot;
    [self.graphView setNeedsDisplay];
    
    //Dismiss the popover if it's showing.
    if (self.popover) {
        [self.popover dismissPopoverAnimated:YES];
      //  self.popover = nil;
    }
}

- (void) setDescriptionOfExpression:(NSString *)descriptionOfExpression
{
    _descriptionOfExpression = descriptionOfExpression;
    self.expressionLabel.text = _descriptionOfExpression;
    self.navBarItem.title = _descriptionOfExpression;
    [self.graphView setNeedsDisplay];
}


- (void)viewDidUnload {
    [self setGraphView:nil];
    [self setExpressionLabel:nil];
    [self setGraphView:nil];
    [self setGraphView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(void)splitViewController:(UISplitViewController *)svc
    willHideViewController:(UIViewController *)aViewController
         withBarButtonItem:(UIBarButtonItem *)barButtonItem
      forPopoverController:(UIPopoverController *)pc
{
    //Grab a reference to the popover
    self.popover = pc;
    
    //Set the title of the bar button item
    barButtonItem.title = @"Calc";
    
    //Set the bar button item as the Nav Bar's leftBarButtonItem
    [_navBarItem setLeftBarButtonItem:barButtonItem animated:YES];
    
}

-(void)splitViewController:(UISplitViewController *)svc
    willShowViewController:(UIViewController *)aViewController
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    //Remove the barButtonItem.
    [_navBarItem setLeftBarButtonItem:nil animated:YES];
    
    
    //Nil out the pointer to the popover.
    _popover = nil;
    
}


@end
