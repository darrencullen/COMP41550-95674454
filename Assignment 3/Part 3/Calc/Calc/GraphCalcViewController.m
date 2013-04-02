//
//  GraphCalcViewController.m
//  GraphCalc
//
//  Created by darren cullen on 15/02/2013.
//  Copyright (c) 2013 95674454. All rights reserved.
//

#import "GraphCalcViewController.h"

@interface GraphCalcViewController ()

@property (nonatomic) CGFloat graphScale;
@property (weak, nonatomic) IBOutlet UILabel *expressionLabel;
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (nonatomic, strong) CalcModel *calcModel;

- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;

@end

@implementation GraphCalcViewController

#define DEFAULT_SCALE 100;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    return self;
}

- (CGFloat)graphScale
{
    
    // Set the scale to the default scale if none already
    if (!_graphScale) _graphScale = DEFAULT_SCALE;
    
    return _graphScale;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setGraphZoomLevel:100];
    
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.expressionLabel.text = [[self calcModel] descriptionOfExpression:self.expressionToPlot];
    self.graphView.delegate = self;
}

- (IBAction)zoomIn:(id)sender
{
    [self setGraphZoomLevel:self.graphView.scale * 10];
}

- (IBAction)zoomOut:(id)sender
{
    [self setGraphZoomLevel:self.graphView.scale * .1];
}

- (double) getValueForYAxisFromValueForXAxis:(GraphView *) graphViewDelegator xAxisValue:(double)value{
    // solve the expression with the value supplied from the view
    NSDictionary *variableSet = @{@"x" : [NSNumber numberWithDouble:value]};
    return [CalcModel evaluateExpression:self.calcModel.expression usingVariableValues:variableSet];
}

- (void) setGraphZoomLevel:(double) zoomLevel
{
    self.graphView.scale = zoomLevel;
    [self.graphView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

- (void)viewDidUnload {
    //[self setGraphView:nil];
    [self setGraphView:nil];
    [self setExpressionLabel:nil];
    [self setGraphView:nil];
    [super viewDidUnload];
}

@end
