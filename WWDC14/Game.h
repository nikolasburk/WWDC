//
//  Game.h
//  WWDC14
//
//  Created by Nikolas Burk on 04/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NUMBER_OF_LEVELS 3

typedef enum {
    Level_One = 1,
    Level_Two = 4,
    Level_Three = 9
}Level;

@interface Game : NSObject

@property (nonatomic, strong, readonly) NSArray *questionsForCurrentLevel;
@property (nonatomic, strong, readonly) NSArray *imagePiecesForCurrentLevel;
@property (nonatomic, assign, readonly) Level currentLevel;


+ (Level)nextLevelForLevel:(Level)level;

- (id)initWithQuestions:(NSDictionary *)questions;
- (void)incrementLevel;

@end
