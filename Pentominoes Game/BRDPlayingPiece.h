//
//  BRDPlayingPiece.h
//  Assignment 2: Pentominoes
//
//  Created by MTSS User on 9/14/14.
//  Copyright (c) 2014 Bryan Dickens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRDPlayingPiece : NSObject
@property (nonatomic,strong) NSString *letter;
@property (nonatomic,strong) NSDictionary *movesDictionary;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIView* cellSuperView;
@end
