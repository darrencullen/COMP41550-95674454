//
//  GraphCalcViewController.m
//  GraphCalc
//
//  Created by darren cullen on 15/02/2013.
//  Copyright (c) 2013 95674454. All rights reserved.
//

#import "GraphCalcViewController.h"

@interface GraphCalcViewController ()

@property (weak, nonatomic) IBOutlet UILabel *expressionLabel;
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (nonatomic, strong) CalcModel *calcModel;
@property (nonatomic, strong) NSString *defaultPropertyIdentifier;

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
    
    // add gesture recognition
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self.graphView action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired=2;
    [self.graphView addGestureRecognizer:doubleTap];
    
    self.defaultPropertyIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        
    // restore values
    float restoredGraphScale = [[NSUserDefaults standardUserDefaults] floatForKey:[self.defaultPropertyIdentifier stringByAppendingString:@".graphScale"]];
    float restoredXAxisOrigin = [[NSUserDefaults standardUserDefaults] floatForKey:[self.defaultPropertyIdentifier stringByAppendingString:@".xAxisOrigin"]];
    float restoredYAxisOrigin = [[NSUserDefaults standardUserDefaults] floatForKey:[self.defaultPropertyIdentifier stringByAppendingString:@".yAxisOrigin"]];
    
    if (restoredGraphScale)
        self.graphView.graphScale = restoredGraphScale;
    else
        self.graphView.graphScale = 16;
    
    if (restoredXAxisOrigin && restoredYAxisOrigin) {
        CGPoint axisOrigin;
        
        axisOrigin.x = restoredXAxisOrigin;
        axisOrigin.y = restoredYAxisOrigin;
        
        self.graphView.graphOrigin = axisOrigin;
    } else
        self.graphView.graphOrigin = CGPointZero;
    
    // Refresh the graph View
    [self.graphView setNeedsDisplay];
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
}

- (IBAction)zoomIn:(id)sender
{ 
    [self setGraphZoomLevel:self.graphView.graphScale * 1.1];
}

- (IBAction)zoomOut:(id)sender
{
    [self setGraphZoomLevel:self.graphView.graphScale / 1.1];
}

- (double) getValueForYAxisFromValueForXAxis:(GraphView *) graphViewDelegator xAxisValue:(double)value{
    // solve the expression with the value supplied from the view
    NSDictionary *variableSet = @{@"x" : [NSNumber numberWithDouble:value]};
    return [CalcModel evaluateExpression:self.expressionToPlot usingVariableValues:variableSet];
}

- (void) setGraphZoomLevel:(double) zoomLevel
{
    self.graphView.graphScale = zoomLevel;
    [self.graphView setNeedsDisplay];
}

- (void) setGraphOrigin:(GraphView *) graphViewDelegator graphAxisOrigin:(CGPoint)origin
{
    NSLog(@"GraphCalcViewController.m - setGraphOrigin (delegate)");
    self.graphView.graphOrigin = origin;
    
    NSUserDefaults *standardUserDefaults=[NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setFloat:origin.x forKey:[self.defaultPropertyIdentifier stringByAppendingString:@".xAxisOrigin"]];
        [standardUserDefaults setFloat:origin.y forKey:[self.defaultPropertyIdentifier stringByAppendingString:@".yAxisOrigin"]];
        [standardUserDefaults synchronize];
    }
}

- (void) setGraphScale:(GraphView *) graphViewDelegator graphScale:(double)scale;
{
    NSLog(@"GraphCalcViewController.m - setGraphScale (delegate)");
    
    self.graphView.graphScale = scale;
    
    NSUserDefaults *standardUserDefaults=[NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setFloat:scale forKey:[self.defaultPropertyIdentifier stringByAppendingString:@".graphScale"]];
        [standardUserDefaults synchronize];
    }
}

- (void) setExpressionToPlot:(NSArray *)expressionToPlot
{
    _expressionToPlot = expressionToPlot;
    [self.graphView setNeedsDisplay];
    
    // dismiss popover if present
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
    self.popover = pc;
    barButtonItem.title = @"Calc";
    [_navBarItem setLeftBarButtonItem:barButtonItem animated:YES];
    
}

-(void)splitViewController:(UISplitViewController *)svc
    willShowViewController:(UIViewController *)aViewController
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [_navBarItem setLeftBarButtonItem:nil animated:YES];
    _popover = nil;
}
@end
