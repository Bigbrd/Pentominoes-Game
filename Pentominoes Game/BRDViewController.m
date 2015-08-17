//
//  BRDViewController.m
//  Assignment 2: Pentominoes
//
//  Created by MTSS User on 9/11/14.
//  Copyright (c) 2014 Bryan Dickens. All rights reserved.
//  Notes: Researched and learned how to use CollectionViews as I thought it was a more elequant solution for storing the pieces, hopefully that's okay :)


#define initImageTag 0
#define kAnimationDuration 1.3
#define kButtonFrameSize 105
#define kButtonToViewScaleFactor 4.0
#define maxWidthPlayingPieceCell 150
#define maxHeightPlayingPieceCell 90
#define kVerticalMargins 40
#define kHorizontalMargins 20
#define kNumberOfBoardsToPlay 5
#define kSquareLength 30
#define yCoordinateOffScreen 1500

#import "BRDViewController.h"
#import "BRDModel.h"
#import "BRDPlayingPiece.h"

@interface BRDViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIButton *board0Button;
@property (weak, nonatomic) IBOutlet UIButton *board1Button;
@property (weak, nonatomic) IBOutlet UIButton *board2Button;
@property (weak, nonatomic) IBOutlet UIButton *board3Button;
@property (weak, nonatomic) IBOutlet UIButton *board4Button;
@property (weak, nonatomic) IBOutlet UIButton *board5Button;
@property (weak, nonatomic) IBOutlet UIImageView *mainBoardImageView;
@property (weak, nonatomic) IBOutlet UILabel *directionsLabel;

@property NSInteger currentUIImageViewTag;
@property NSArray *mainSolutionsArray;
@property CGPoint mainBoardImageViewCenter;
@property (weak, nonatomic) UIView *currentCellSuperView;
@property NSDictionary *playingPiecesDictionary;
@property NSArray *playingPiecesArray;

@property (weak, nonatomic) IBOutlet UIButton *solveButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UICollectionView *playingPiecesCollectionView;
-(IBAction)switchBoardButtonPressed:(UIButton*)sender;
-(IBAction)solveButtonPressed:(id)sender;
-(IBAction)resetButtonPressed:(id)sender;

@property (nonatomic,strong) BRDModel *model;
@end



@implementation BRDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// additional setup
    [self setUpView];
}

//initializes the decoder model
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _model = [[BRDModel alloc] init];
    }
    return self;
}

- (void)setUpView
{
    //Takes background image and fits to screen.
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"matrixBackgroundImage.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Applies background image into the loading view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    self.currentUIImageViewTag = initImageTag;
    self.mainBoardImageViewCenter = self.mainBoardImageView.center;
    [self.solveButton setUserInteractionEnabled:NO];
    [self.resetButton setUserInteractionEnabled:NO];
    
    self.directionsLabel.text = @"Welcome to the Pentominoes! Select a board to start.";
    [self setUpPlayingPieces];
    [self readInSolutions];
}

-(void)setUpPlayingPieces
{
    //add the 12 playing pieces to the board as UIImageViews in the CollectionView as Cells
    [self.playingPiecesCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PlayingPieceCell"];
}

-(void)readInSolutions
{
    NSString *mainBundleString = [[NSBundle mainBundle] pathForResource:@"Solutions" ofType:@"plist"];
    self.mainSolutionsArray = [NSArray arrayWithContentsOfFile:mainBundleString];
}


#pragma mark - Button Pressed Methods

//function sends the new image from the button to the center main Image View
-(void)switchBoardButtonPressed:(UIButton*) sender
{
    self.directionsLabel.text = NULL;
    [self.solveButton setUserInteractionEnabled:NO];
    [self.resetButton setUserInteractionEnabled:NO];
    
    //board image selection
    NSInteger tagFromButtonPressed = [sender tag];
    
    NSString *nextImageString = [NSString stringWithFormat:@"Board%d.png",tagFromButtonPressed];
    UIImage *nextImage = [UIImage imageNamed:nextImageString];
    UIImageView *nextImageView = [[UIImageView alloc] initWithImage:nextImage];
    [self.view addSubview:nextImageView];
    nextImageView.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y, kButtonFrameSize , kButtonFrameSize);

    //animation that scales and moves the button image to the board
    [UIView animateWithDuration:kAnimationDuration animations:^
     {
         [self disableButtonsForSwitchingBoards];
         nextImageView.center = self.mainBoardImageViewCenter;
         nextImageView.transform = CGAffineTransformMakeScale(kButtonToViewScaleFactor, kButtonToViewScaleFactor);
         
     }completion:^(BOOL finished)
     {
         self.mainBoardImageView.image = nextImage;
         [nextImageView removeFromSuperview];
         self.currentUIImageViewTag = tagFromButtonPressed;
         
         if (self.currentUIImageViewTag != 0)
         {
             //enable the solve button
             [self.solveButton setUserInteractionEnabled:YES];
         }
        [self enableButtonsForSwitchingBoards];
     }
     ];
}

-(void) disableButtonsForSwitchingBoards
{
    [self.board0Button setUserInteractionEnabled:NO];
    [self.board1Button setUserInteractionEnabled:NO];
    [self.board2Button setUserInteractionEnabled:NO];
    [self.board3Button setUserInteractionEnabled:NO];
    [self.board4Button setUserInteractionEnabled:NO];
    [self.board5Button setUserInteractionEnabled:NO];
}
-(void) enableButtonsForSwitchingBoards
{
    [self.board0Button setUserInteractionEnabled:YES];
    [self.board1Button setUserInteractionEnabled:YES];
    [self.board2Button setUserInteractionEnabled:YES];
    [self.board3Button setUserInteractionEnabled:YES];
    [self.board4Button setUserInteractionEnabled:YES];
    [self.board5Button setUserInteractionEnabled:YES];
}

-(IBAction)solveButtonPressed:(id)sender
{
    
    if (self.currentUIImageViewTag > 0 && self.currentUIImageViewTag <= kNumberOfBoardsToPlay)
    {
        [self disableButtonsForSwitchingBoards];
        
        //set dictionary to the correct board
        self.playingPiecesDictionary = [self.mainSolutionsArray objectAtIndex:(self.currentUIImageViewTag - 1)];
        
        [self movePlayingPieces];
        [self.resetButton setUserInteractionEnabled:YES];
        [self.solveButton setUserInteractionEnabled:NO];
    }
    
}

-(IBAction)resetButtonPressed:(id)sender
{
    if (self.currentUIImageViewTag > 0 && self.currentUIImageViewTag <= kNumberOfBoardsToPlay)
    {
        [self replacePlayingPieces];
        
        [self.resetButton setUserInteractionEnabled:NO];
        [self.solveButton setUserInteractionEnabled:YES];
        [self enableButtonsForSwitchingBoards];
    }
}

#pragma mark - Moving Playing Pieces Methods
-(void)movePlayingPieces
{
    //enumerate through the dictionary of Pieces
    NSEnumerator *enumerator = [self.playingPiecesDictionary objectEnumerator];
    id directionsValueDictionary;
    NSMutableArray *tempPlayingPiecesArray = [[NSMutableArray alloc] init];
    
    while ((directionsValueDictionary = [enumerator nextObject]))
    {
        //get the index in the array where the moving playing piece is in the collection view
        NSArray *temp = [self.playingPiecesDictionary allKeysForObject:directionsValueDictionary];
        NSString *keyLetter = [temp lastObject];
        NSInteger index = [self.model getIndexForPlayingPieceWithLetter:keyLetter];
        NSIndexPath *collectionPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        //get collectionView image at this index
        UICollectionViewCell *playingPieceCell = [self.playingPiecesCollectionView cellForItemAtIndexPath:collectionPath];
        NSArray *tempAllSubviews = playingPieceCell.subviews;
        UIImageView *playingPieceImageView = [tempAllSubviews lastObject];
        
        //get point for correct original location
        CGRect originalFrame = [self.mainBoardImageView convertRect:playingPieceImageView.frame fromView:playingPieceImageView];
        playingPieceImageView.frame = originalFrame;
        
        [UIView animateWithDuration:kAnimationDuration animations:^
         {
             //get all values to do to the imageview
             NSInteger xValue = [[directionsValueDictionary objectForKey:@"x"] integerValue];
             NSInteger yValue = [[directionsValueDictionary objectForKey:@"y"] integerValue];
             NSInteger rotationsValue = [[directionsValueDictionary objectForKey:@"rotations"]integerValue];
             NSInteger flipsValue = [[directionsValueDictionary objectForKey:@"flips"]integerValue];
             
             //animate the piece into its correct place
             CGAffineTransform movements = CGAffineTransformRotate(playingPieceImageView.transform, (rotationsValue * (M_PI/2)));
             CGRect newFrame;
             if(rotationsValue % 2)
             {
                 newFrame = CGRectMake(xValue*kSquareLength, yValue*kSquareLength, playingPieceImageView.frame.size.height, playingPieceImageView.frame.size.width);
             }
             else
             {
                 newFrame = CGRectMake(xValue*kSquareLength, yValue*kSquareLength, playingPieceImageView.frame.size.width, playingPieceImageView.frame.size.height);
             }
             if (flipsValue)
             {
                 movements = CGAffineTransformScale(movements, -1.0, 1.0);
             }
             
             
             playingPieceImageView.transform = movements;
             playingPieceImageView.frame = newFrame;
             self.currentCellSuperView = playingPieceImageView.superview;
             [self.mainBoardImageView addSubview:playingPieceImageView];
             
             
         }completion:NULL];
        
        //update our specific playing piece
        BRDPlayingPiece *playingPiece = [[BRDPlayingPiece alloc] init];
        playingPiece.letter = keyLetter;
        playingPiece.imageView =playingPieceImageView;
        playingPiece.movesDictionary = directionsValueDictionary;
        playingPiece.cellSuperView = self.currentCellSuperView;
        [tempPlayingPiecesArray addObject:playingPiece];
    }
    //set the playingPiecesArray that will be used this session
    self.playingPiecesArray = tempPlayingPiecesArray;
}

-(void)replacePlayingPieces
{
    //go through the playing pieces
    for (BRDPlayingPiece *playingPiece in self.playingPiecesArray)
    {
        [UIView animateWithDuration:kAnimationDuration/2 animations:^
        {
            //wipe off the old board
            CGRect temporaryImageViewFrame = CGRectMake(playingPiece.imageView.frame.origin.x, yCoordinateOffScreen, playingPiece.imageView.frame.size.width, playingPiece.imageView.frame.size.height);
            playingPiece.imageView.frame = temporaryImageViewFrame;
            
        }completion:^(BOOL finished)
        {
            [UIView animateWithDuration:kAnimationDuration animations:^
            {
                //set pieces into their Cell container
                [playingPiece.cellSuperView addSubview:playingPiece.imageView];
                
                //change values
                NSInteger rotationsValue = [[playingPiece.movesDictionary objectForKey:@"rotations"]integerValue];
                NSInteger flipsValue = [[playingPiece.movesDictionary objectForKey:@"flips"]integerValue];
                if (flipsValue)
                {
                    playingPiece.imageView.transform = CGAffineTransformScale(playingPiece.imageView.transform, -1.0, 1.0);
                }
                playingPiece.imageView.transform = CGAffineTransformRotate(playingPiece.imageView.transform, (-rotationsValue * (M_PI/2)));
                
                //create final frame and set the imageview to that frame
                CGRect temporaryImageViewFrame = CGRectMake(playingPiece.cellSuperView.bounds.origin.x, playingPiece.cellSuperView.bounds.origin.y, playingPiece.imageView.frame.size.width, playingPiece.imageView.frame.size.height);
                    playingPiece.imageView.frame = temporaryImageViewFrame;
                
            }completion:NULL];
        }];
        
    }

}

#pragma mark - UICollectionViewDataSource Methods

//number of items in the collection view method
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger playingPiecesContainerSize = [self.model.playingPiecesArray count];
    return playingPiecesContainerSize;
}
//get specific cell collection view method
-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingPieceCell" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self.model.playingPiecesArray objectAtIndex:indexPath.row]];
    
    [cell addSubview:imageView];
    return cell;

}
//size of the cell method
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize returnValue = CGSizeMake(maxWidthPlayingPieceCell, maxHeightPlayingPieceCell);
    return returnValue;
}
//margins method
-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kVerticalMargins, kHorizontalMargins, kVerticalMargins, kHorizontalMargins);
}


@end
