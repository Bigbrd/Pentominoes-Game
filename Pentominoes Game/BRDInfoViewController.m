//
//  BRDInfoViewController.m
//  Pentominoes Game
//
//  Created by MTSS User on 9/18/14.
//  Copyright (c) 2014 Bryan Dickens. All rights reserved.
//

#import "BRDInfoViewController.h"
#define indexOfTitleStart 25
#define lengthOfBoldForTitle 12
#define boldFontSize 19

@interface BRDInfoViewController ()

@property (assign, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (assign, nonatomic) IBOutlet UILabel *directionsLabel;
@property (assign, nonatomic) IBOutlet UILabel *signatureLabel;
- (IBAction)dismissByDelegate:(id)sender;
@property (assign, nonatomic) IBOutlet UISegmentedControl *backgroundImageOptionsSegmentedControl;
- (IBAction)imageSelectedOnSegmentedControl:(UISegmentedControl *)sender;
- (IBAction)timerSwitchToggled:(id)sender;
@property (assign, nonatomic) IBOutlet UISwitch *timerToggle;
@property (assign, nonatomic) IBOutlet UISegmentedControl *backgroundImageSelectedSymbolSegmentedControl;


@end


@implementation BRDInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Takes background image and fits to screen.
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"blueFrameImage.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Applies background image into the view
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    [self initAttributedTextDescription];
    
    //Add clear color to mask any bits of a selection state that the object might show around the images
    _backgroundImageOptionsSegmentedControl.tintColor = [UIColor clearColor];
    
    UIImage *matrix;
    UIImage *wooden;
    UIImage *wb;
    UIImage *beach;
    
    //Needed for image uploading in SegControls
    //Setting imageWithRenderingMode: to imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal for iOS7 is key
    if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)]) {
        matrix = [[UIImage imageNamed:@"matrixBackgroundImage.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        wooden = [[UIImage imageNamed:@"wooden.jpeg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        wb = [[UIImage imageNamed:@"wb.jpeg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        beach = [[UIImage imageNamed:@"beach.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    else {
        matrix = [UIImage imageNamed:@"matrixBackgroundImage.jpg"];
        wooden = [UIImage imageNamed:@"wooden.jpeg"];
        wb = [UIImage imageNamed:@"wb.jpeg"];
        beach = [UIImage imageNamed:@"beach.jpg"];
    }
    
    
    [_backgroundImageOptionsSegmentedControl setImage:matrix forSegmentAtIndex:0];
    [_backgroundImageOptionsSegmentedControl setImage:wooden forSegmentAtIndex:1];
    [_backgroundImageOptionsSegmentedControl setImage:wb forSegmentAtIndex:2];
    [_backgroundImageOptionsSegmentedControl setImage:beach forSegmentAtIndex:3];
    
    //set the one currently picked as "selected"
    [_backgroundImageSelectedSymbolSegmentedControl setSelectedSegmentIndex:_currentBackgroundSelected];
    //set timer toggle for its correct position
    [_timerToggle setOn:self.timerOn];
    
}

-(void)initAttributedTextDescription
{
    NSMutableAttributedString *description = [[NSMutableAttributedString alloc] initWithString:@"The name of this game is Pentominoes! Our space ships - the 12 five square pieces you see in front of you, all need to be docked into our station. These space ships, often referred to as a Pentominoe, can only fit into the station together in one specific pattern. Your mission if you choose to accept it is to manipulate our Pentominoes into the correct pattern so that the station of gray squares are completely covered."];
    _directionsLabel.text = @"Directions: \n  \u2022 Click a pentominoe once to rotate 90 degrees clockwise. \n \u2022 Double Click to flip a pentominoe. \n \u2022 Drag a pentominoe to the spot you want it to be parked at.";
    _signatureLabel.text = @"Created by yours truly - Bryan Dickens. Have Fun!";
    
    //makes "Pentominoes!" bold
    NSRange boldRange = NSMakeRange(indexOfTitleStart, lengthOfBoldForTitle);
    [description beginEditing];
    [description addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:boldFontSize] range:boldRange];
    [description endEditing];
    
    _descriptionLabel.attributedText = description;
    [description release];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissByDelegate:(id)sender {
    [_delegate dismissMe:self];
}

- (IBAction)imageSelectedOnSegmentedControl:(UISegmentedControl *)sender
{
    //pass the clicked Segment to the background delegation
    _currentBackgroundSelected = [sender selectedSegmentIndex];
    
}


- (IBAction)timerSwitchToggled:(id)sender
{
    _timerOn = !_timerOn;
}


@end