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


- (IBAction)stepNumberOfSides:(UIStepper *)sender {
    self.model.numberOfSides = self.stepperSides.value;
    [self updatePolygonDisplay];
}

- (IBAction)swipeIncrease:(UISwipeGestureRecognizer *)sender {
    self.stepperSides.value = self.model.numberOfSides += 1;
    [self updatePolygonDisplay];
}

- (IBAction)swipeDecrease:(UISwipeGestureRecognizer *)sender {
    self.stepperSides.value = self.model.numberOfSides -= 1;
    [self updatePolygonDisplay];
}

- (void)viewDidLoad{
    self.polygonNameView.backgroundColor = self.polygonView.backgroundColor;
    
    // configure polygon from saved value
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.polygonNameView.hidden = [defaults boolForKey:@"hidePolygonName"];
    self.switchPolygonName.On = ![defaults boolForKey:@"hidePolygonName"];
    
    
    // configure polygon from label
    if (![defaults integerForKey:@"numberOfSides"]){
        self.model.numberOfSides = self.stepperSides.value = [self.numberOfSidesLabel.text integerValue];
    } else {
        self.model.numberOfSides = self.stepperSides.value = [defaults integerForKey:@"numberOfSides"];
    }
    
    [self updatePolygonDisplay];
    [super viewDidLoad];
}


- (void)updatePolygonDisplay{
    self.numberOfSidesLabel.text = [NSString stringWithFormat:@"%d", self.model.numberOfSides];
    
    [self.polygonView setNumberOfSides:self.model.numberOfSides];
    self.polygonName.text = self.model.name;
    
    // store number of sides for use in restart
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.model.numberOfSides forKey:@"numberOfSides"];
    
    [self.polygonView setNeedsDisplay];
}


- (IBAction)showPolygonName:(UISwitch *)sender {
    self.polygonNameView.hidden=![sender isOn];
    
    // store name view choice for use in restart
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.polygonNameView.hidden forKey:@"hidePolygonName"];
    
    [self.polygonView setNeedsDisplay];
}

/* obsoleted due to replacing buttons with stepper
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
*/

@end
