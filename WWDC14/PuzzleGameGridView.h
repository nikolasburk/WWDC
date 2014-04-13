//
//  PuzzleGameGridView.h
//  WWDC14
//
//  Created by Nikolas Burk on 05/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "GridView.h"

@class PuzzleGameGridView, QuestionView, Question;

@protocol PuzzleGameGridViewDelegate <NSObject, GridViewDelegate>

- (void)puzzleGameGridView:(PuzzleGameGridView *)puzzleGameGridView didSelectViewAtIndex:(NSInteger)index;

@optional

- (void)puzzleGameGridView:(PuzzleGameGridView *)puzzleGameGridView didEnterPuzzleMode:(BOOL)puzzleMode;
- (void)puzzleGameGridViewPuzzleSolved:(PuzzleGameGridView *)puzzleGameGridView;

@end

@interface PuzzleGameGridView : GridView

@property (nonatomic, strong) id <PuzzleGameGridViewDelegate> puzzleGridViewDelegate;
@property (nonatomic, assign) BOOL puzzleMode;

- (void)flipQuestionViewAtIndex:(NSInteger)index;
- (QuestionView *)questionViewForQuestion:(Question *)question;


@end
