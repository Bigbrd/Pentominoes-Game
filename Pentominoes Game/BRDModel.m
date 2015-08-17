//
//  BRDModel.m
//  Assignment 2: Pentominoes
//
//  Created by MTSS User on 9/12/14.
//  Copyright (c) 2014 Bryan Dickens. All rights reserved.
//

#import "BRDModel.h"
static NSArray *playingPieceLetters;

@interface BRDModel ()

//@property (nonatomic, strong) NSArray *playingPiecesArray;
@property NSInteger currentPlayingPiece;

@end

@implementation BRDModel

-(id)init {
    self = [super init];
    if (self) {
        [self initializePlayingPieces];
    }
    return self;
}

-(void)initializePlayingPieces {
    NSMutableArray *temporaryPlayingPiecesArray = [NSMutableArray array];
    
    playingPieceLetters = @[@"F",@"I",@"L",@"N",@"P",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    for (id object in playingPieceLetters)
    {
        NSString *nextPlayingPieceString = [NSString stringWithFormat:@"tile%@.png",object];
        UIImage *nextPlayingPiece = [UIImage imageNamed:nextPlayingPieceString];
        if (nextPlayingPiece)
        {
            [temporaryPlayingPiecesArray addObject:nextPlayingPiece];
        }
    }
    self.playingPiecesArray = temporaryPlayingPiecesArray;
}

#pragma mark - Public Methods
-(NSInteger)getIndexForPlayingPieceWithLetter:(NSString*)letter
{
    NSInteger index = 0;
    for (id object in playingPieceLetters)
    {
        if([object isEqualToString:letter])
        {
            index = [playingPieceLetters indexOfObject:object];
        }
    }
    return index;
}

@end
