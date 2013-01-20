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
@property (strong, nonatomic) IBOutlet PolygonView *polygonView;
@property (weak, nonatomic) IBOutlet UIStepper *stepperSides;
@property (weak, nonatomic) IBOutlet UIView *polygonNameView;
@property (weak, nonatomic) IBOutlet UILabel *polygonName;
@property (weak, nonatomic) IBOutlet UISwitch *switchPolygonName;


- (IBAction)showPolygonName:(UISwitch *)sender;
- (IBAction)stepNumberOfSides:(UIStepper *)sender;
- (IBAction)swipeIncrease:(UISwipeGestureRecognizer *)sender;
- (IBAction)swipeDecrease:(UISwipeGestureRecognizer *)sender;

/* obsoleted due to replacing buttons with stepper
 //@property (weak, nonatomic) IBOutlet UIButton *decreaseButton;
 //@property (weak, nonatomic) IBOutlet UIButton *increaseButton;
 //- (IBAction)decrease:(id)sender;
 //- (IBAction)increase:(id)sender;
*/
@end
