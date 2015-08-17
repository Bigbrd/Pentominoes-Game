//
//  BRDInfoViewController.h
//  Pentominoes Game
//
//  Created by MTSS User on 9/18/14.
//  Copyright (c) 2014 Bryan Dickens. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BRDInfoViewController;

@protocol InfoDelegate <NSObject>

-(void)dismissMe:(BRDInfoViewController*)infoViewController;

@end

@interface BRDInfoViewController : UIViewController

@property (assign, nonatomic) id <InfoDelegate> delegate;
@property (nonatomic) NSInteger currentBackgroundSelected;
@property BOOL timerOn;
@end

