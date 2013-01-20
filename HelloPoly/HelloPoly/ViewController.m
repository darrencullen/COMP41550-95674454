//
//  ViewController.m
//  HelloPoly
//
//  Created by darren cullen on 15/01/2013.
//  Copyright (c) 2013 COMP41550. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize numberOfSidesLabel = _numberOfSidesLabel;
@synthesize model = _model;

//- (IBAction)decrease:(UIButton *)sender {
//    NSLog(@"I'm in the decrease method");
//    self.model.numberOfSides -=1;
//    self.stepperSides.value = self.model.numberOfSides;
//
//    [self updateNumberOfSidesDisplay];
//    [self enableDisableButtons];
//}

//- (IBAction)increase:(UIButton *)sender {
//    NSLog(@"I'm in the decrease method");
//    self.model.numberOfSides +=1;
//    self.stepperSides.value = self.model.numberOfSides;
//    
//    [self updateNumberOfSidesDisplay];
//    [self enableDisableButtons];
//}

- (IBAction)stepNumberOfSides:(UIStepper *)sender {
    self.model.numberOfSides = self.stepperSides.value;
    [self updateNumberOfSidesDisplay];
//    [self enableDisableButtons];
}

- (IBAction)swipeIncrease:(UISwipeGestureRecognizer *)sender {
    self.stepperSides.value = self.model.numberOfSides += 1;
    [self updateNumberOfSidesDisplay];
}

- (IBAction)swipeDecrease:(UISwipeGestureRecognizer *)sender {
    self.stepperSides.value = self.model.numberOfSides -= 1;
    [self updateNumberOfSidesDisplay];
}

- (void)viewDidLoad{
    // configure polygon from saved value
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger restoredNumberOfSides = [defaults integerForKey:@"numberOfSides"];
    
    // configure polygon from label
    if (!restoredNumberOfSides){
        self.model.numberOfSides = [self.numberOfSidesLabel.text integerValue];
        self.stepperSides.value = self.model.numberOfSides;
    } else {
        self.model.numberOfSides = self.stepperSides.value = restoredNumberOfSides;
    }
    
    [self updateNumberOfSidesDisplay];
    self.polygonNameView.backgroundColor = self.polygonView.backgroundColor;
    [super viewDidLoad];
}

// TODO AWAKE FROM NIB!

- (void)updateNumberOfSidesDisplay{
    self.numberOfSidesLabel.text = [NSString stringWithFormat:@"%d", self.model.numberOfSides];
    
    // save default
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.model.numberOfSides forKey:@"numberOfSides"];
    
    [self.polygonView setNumberOfSides:self.model.numberOfSides];
    self.polygonName.text = self.model.name;
}

//- (void)enableDisableButtons{
//    if (self.model.numberOfSides < 4){
//        self.decreaseButton.enabled = NO;
//        self.increaseButton.enabled = YES;
//        [self.decreaseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [self.increaseButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        
//    } else if (self.model.numberOfSides > 11){
//        self.decreaseButton.enabled = YES;
//        self.increaseButton.enabled = NO;
//        [self.decreaseButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [self.increaseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        
//    } else {
//        self.decreaseButton.enabled = YES;
//        self.increaseButton.enabled = YES;
//        [self.decreaseButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [self.increaseButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//
//    }
//    
//    NSLog(@"My polygon: %@", self.model.name);
//}
- (IBAction)showPolygonName:(UISwitch *)sender {
    self.polygonNameView.hidden=![sender isOn];
}
@end
