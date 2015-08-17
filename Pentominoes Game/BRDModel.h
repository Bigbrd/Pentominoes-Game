//
//  BRDModel.h
//  Assignment 2: Pentominoes
//
//  Created by MTSS User on 9/12/14.
//  Copyright (c) 2014 Bryan Dickens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRDModel : NSObject
    @property (nonatomic, strong) NSArray *playingPiecesArray;
-(NSInteger)getIndexForPlayingPieceWithLetter:(NSString*)letter;
@end
