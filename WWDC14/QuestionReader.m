//
//  QuestionReader.m
//  WWDC14
//
//  Created by Nikolas Burk on 05/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "QuestionReader.h"
#import "Game.h" // for enum Level
#import "NSArray+Util.h"

@implementation QuestionReader

#pragma mark - Singleton

static QuestionReader *questionReaderSharedInstance = nil;

- (id)init
{
    self = [super init];
    if (self)
    {
        _questions = [self readQuestionsFromPropertyList];
    }
    return self;
}

+ (QuestionReader *)questionReaderSharedInstance
{
    @synchronized(self) {
        if (questionReaderSharedInstance == nil)
            questionReaderSharedInstance = [[self alloc] init];
    }
    return questionReaderSharedInstance;
}

- (NSDictionary *)questionsForNewGame
{
    NSMutableArray *shuffledQuestions = [[NSMutableArray alloc] initWithArray:self.questions];
    [shuffledQuestions shuffle];
    NSMutableDictionary *gameQuestions = [[NSMutableDictionary alloc] init];
    const int numberOfQuestions = Level_One + Level_Two + Level_Three;
    
    NSMutableArray *questionsForCurrentLevel = [[NSMutableArray alloc] init];

    Level currentLevel = Level_One;
    
    for (int i = 0; i < numberOfQuestions; i++)
    {
        NSLog(@"DEBUG | %s | Current level: %d (index: %d)", __func__, currentLevel, i);
        [questionsForCurrentLevel addObject:shuffledQuestions[i]];
        
        Level nextLevel = [Game nextLevelForLevel:currentLevel];
        NSInteger sumOfPreviousLevels = [self sumOfPreviousLevelsForLevel:currentLevel];
        
        if (i == currentLevel+sumOfPreviousLevels-1)
        {
            NSArray *questionsForCurrentLevelToAdd = [[NSMutableArray alloc] initWithArray:questionsForCurrentLevel];
            [gameQuestions setObject:questionsForCurrentLevelToAdd forKey:@(currentLevel)];
            [questionsForCurrentLevel removeAllObjects];
            
            currentLevel = nextLevel;
            if (currentLevel == Level_One)
            {
                NSLog(@"DEBUG | %s | Questions for new game: \n%@", __func__, gameQuestions);
                break;
            }
        }
    }
    return gameQuestions;
}

- (void)resetQuestions
{
    for (Question *question in self.questions)
    {
        [question reset];
    }
}

- (NSInteger)sumOfPreviousLevelsForLevel:(Level)level
{
    NSInteger sumOfPreviousLevels = 0;
    switch (level)
    {
        case Level_Two:
            sumOfPreviousLevels = Level_One;
            break;
        case Level_Three:
            sumOfPreviousLevels = Level_One+Level_Two;
            break;
        default:
            break;
    }
    return sumOfPreviousLevels;
}

- (NSArray *)readQuestionsFromPropertyList
{
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    
    // Path to the plist (in the application bundle)
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:QUESTIONS_FILE_PATH ofType:SUFFIX_PLIST];
    
    // Build the array from the plist
    NSMutableArray *questionDictionaries = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    for (NSDictionary *questionDictionary in questionDictionaries)
    {
        [questions addObject:[self questionForDictionary:questionDictionary]];
    }
    
    //NSLog(@"DEBUG | %s | Read questions from property lists: '%@'\n%@", __func__, plistPath, questions);
    
    return questions;
}

- (Question *)questionForDictionary:(NSDictionary *)dictionary
{
    QuestionCategory questionCategory = [dictionary[kCategory] intValue];
    NSString *questionString = dictionary[kQuestion];
    NSString *answerString = dictionary[kAnswer];
    
    Question *question;
    
    if ([dictionary[kType] isEqualToString:LOCATION_SHORT])
    {
        NSDictionary *coordinates = dictionary[kCoordinates];
        question = [[LocationQuestion alloc] initWithQuestionString:questionString answerString:answerString category:questionCategory coordinates:coordinates];
    }
    else if ([dictionary[kType] isEqualToString:MULTIPLE_CHOICE_SHORT])
    {
        NSArray *options = dictionary[kOptions];
        question = [[MultipleChoiceQuestion alloc] initWithQuestionString:questionString answerString:answerString category:questionCategory options:options];
    }
    
    return question;
}
                          
- (Class)classForQuestionTypeShort:(NSString *)questionTypeShort
{
    Class questionClass;
    if ([questionTypeShort isEqualToString:LOCATION_SHORT])
    {
        questionClass = [LocationQuestion class];
    }
    else if ([questionTypeShort isEqualToString:MULTIPLE_CHOICE_SHORT])
    {
        questionClass = [MultipleChoiceQuestion class];
    }
    
    return questionClass;
}

@end