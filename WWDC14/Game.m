//
//  Game.m
//  WWDC14
//
//  Created by Nikolas Burk on 04/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "Game.h"
#import "ImageProvider.h"
#import "NSArray+Util.h"
#import "PuzzlePiece.h"

@interface Game ()

@property (nonatomic, strong, readonly) NSDictionary *questions;
@property (nonatomic, strong, readonly) NSDictionary *imagesForLevels;

@end

@implementation Game

+ (Level)nextLevelForLevel:(Level)level
{
    Level nextLevel;
    switch (level)
    {
        case Level_One:
            nextLevel = Level_Two;
            break;
        case Level_Two:
            nextLevel = Level_Three;
            break;
        case Level_Three:
            nextLevel = Level_One;
            break;
        default:
            break;
    }
    return nextLevel;
}

- (id)initWithQuestions:(NSDictionary *)questions
{
    self = [super init];
    if (self)
    {
        _questions = questions;
        _currentLevel = Level_One;
        _questionsForCurrentLevel = self.questions[@(self.currentLevel)];
        _imagesForLevels = [self generateImagesForGame];
        _imagePiecesForCurrentLevel = @[_imagesForLevels[@(Level_One)]];
        NSLog(@"DEBUG | %s | Questions: \n%@", __func__, _questions);
    }
    return self;
}

- (void)incrementLevel
{
    _currentLevel = [Game nextLevelForLevel:_currentLevel];
    _questionsForCurrentLevel = self.questions[@(self.currentLevel)];
    UIImage *newImage = self.imagesForLevels[@(self.currentLevel)];
    NSArray *imagePieces = [newImage splitIntoPieces:_currentLevel];
    NSMutableArray *mutableImagePieces = [[NSMutableArray alloc] initWithArray:imagePieces];
    
    [mutableImagePieces shuffle];
    _imagePiecesForCurrentLevel = mutableImagePieces;
}

- (NSDictionary *)generateImagesForGame
{
    NSMutableDictionary *imagesForLevels = [[NSMutableDictionary alloc] init];
    NSArray *puzzleBackgrounds = [[ImageProvider imageProviderSharedInstance] randomMemeImages:NUMBER_OF_LEVELS];
    for (int i = 1; i < NUMBER_OF_LEVELS+1; i++)
    {
        Level level = (Level)i*i;
        [imagesForLevels setObject:puzzleBackgrounds[i-1] forKey:@(level)];
    }
    return imagesForLevels;
}

@end
