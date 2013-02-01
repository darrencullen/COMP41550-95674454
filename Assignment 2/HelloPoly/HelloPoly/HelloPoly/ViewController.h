//
//  ViewController.h
//  HelloPoly
//
//  Created by darren cullen on 15/01/2013.
//  Copyright (c) 2013 COMP41550. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolygonShape.h"
#import "PolygonView.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *numberOfSidesLabel;
@property (strong, nonatomic) IBOutlet PolygonShape *model;
@property (weak, nonatomic) IBOutlet UIButton *decreaseButton;
@property (weak, nonatomic) IBOutlet UIButton *increaseButton;
@property (strong, nonatomic) IBOutlet PolygonView *polygonView;
@property (weak, nonatomic) IBOutlet UIStepper *stepperSides;
@property (weak, nonatomic) IBOutlet UISlider *sliderSides;

- (IBAction)decrease:(id)sender;
- (IBAction)increase:(id)sender;
- (IBAction)stepNumberOfSides:(UIStepper *)sender;
- (IBAction)slideNumberOfSides:(UISlider *)sender;
@end
