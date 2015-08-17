//
//  BRDPlayingPiece.m
//  Assignment 2: Pentominoes
//
//  Created by MTSS User on 9/14/14.
//  Copyright (c) 2014 Bryan Dickens. All rights reserved.
//

#import "BRDPlayingPiece.h"

@interface BRDPlayingPiece ()



@end

@implementation BRDPlayingPiece
@synthesize letter;
@synthesize movesDictionary;
@synthesize imageView;
@synthesize cellSuperView;

-(id)initWithLetter:(NSString*)playingPieceLetter movesDictionary:(NSDictionary*)pieceMovesDictionary imageView:(UIImageView*)playingPieceImageView cellSuperView: (UIView*)currentCellSuperView
{
    self = [super init];
    if (self) {
        self.letter = playingPieceLetter;
        self.movesDictionary = pieceMovesDictionary;
        self.imageView = playingPieceImageView;
        self.cellSuperView = currentCellSuperView;
    }
    return self;
}

@end
