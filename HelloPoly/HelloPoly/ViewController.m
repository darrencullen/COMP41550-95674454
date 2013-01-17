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

- (IBAction)decrease:(UIButton *)sender {
    NSLog(@"I'm in the decrease method");
    self.model.numberOfSides -=1;
    self.stepperSides.value = self.sliderSides.value = self.model.numberOfSides;

    [self updateNumberOfSidesDisplay];
    [self enableDisableButtons];
}

- (IBAction)increase:(UIButton *)sender {
    NSLog(@"I'm in the decrease method");
    self.model.numberOfSides +=1;
    self.stepperSides.value = self.sliderSides.value = self.model.numberOfSides;
    
    [self updateNumberOfSidesDisplay];
    [self enableDisableButtons];
}

- (IBAction)stepNumberOfSides:(UIStepper *)sender {
    self.model.numberOfSides = self.sliderSides.value = self.stepperSides.value;
    [self updateNumberOfSidesDisplay];
    [self enableDisableButtons];
}

- (IBAction)slideNumberOfSides:(UISlider *)sender {
    NSLog(@"Slider value: %f", self.sliderSides.value);
    self.model.numberOfSides = self.stepperSides.value = round(self.sliderSides.value);
    NSLog(@"Slider value: %d", self.model.numberOfSides);

    [self updateNumberOfSidesDisplay];
    [self enableDisableButtons];
}

- (void)viewDidLoad{
    // configure polygon
    self.model.numberOfSides = [self.numberOfSidesLabel.text integerValue];
    self.stepperSides.value = self.model.numberOfSides;
    [self updateNumberOfSidesDisplay];
    [super viewDidLoad];
}

// TODO AWAKE FROM NIB!

- (void)updateNumberOfSidesDisplay{
    self.numberOfSidesLabel.text = [NSString stringWithFormat:@"%d", self.model.numberOfSides];
    [self.polygonView setNumberOfSides:self.model.numberOfSides];
}

- (void)enableDisableButtons{
    if (self.model.numberOfSides < 4){
        self.decreaseButton.enabled = NO;
        self.increaseButton.enabled = YES;
        [self.decreaseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.increaseButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    } else if (self.model.numberOfSides > 11){
        self.decreaseButton.enabled = YES;
        self.increaseButton.enabled = NO;
        [self.decreaseButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.increaseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    } else {
        self.decreaseButton.enabled = YES;
        self.increaseButton.enabled = YES;
        [self.decreaseButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.increaseButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    }
    
    NSLog(@"My polygon: %@", self.model.name);
}
@end
