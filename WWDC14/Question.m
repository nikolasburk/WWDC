//
//  Question.m
//  WWDC14
//
//  Created by Nikolas Burk on 04/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "Question.h"

//@class LocationQuestion, MultipleChoiceQuestion;

@implementation Question

const NSInteger NUMBER_OF_GUESSES = 3;


- (id)init
{
    self = [super init];
    if (self)
    {
        _answered = NO;
        _triesLeft = NUMBER_OF_GUESSES;
    }
    return self;
}

- (id)initWithQuestionString:(NSString *)questionString answerString:(NSString *)answerString category:(QuestionCategory)category
{
    self = [self init];
    if (self)
    {
        _questionString = questionString;
        _answerString = answerString;
        _questionCategory = category;
    }
    return self;
}

- (BOOL)answer:(id)answer
{
    BOOL answerCorrect = [self verifyAnswer:answer];
    _answered = answerCorrect;
    _triesLeft = _answered ? _triesLeft : _triesLeft-1;
    if (!_answered)
    {
        NSLog(@"DEBUG | %s | Tries left: _triesLeft = %d, self.triesLeft = %d", __func__, _triesLeft, self.triesLeft);
    }
    return _answered;
}

- (void)reset
{
    _answered = NO;
    _triesLeft = NUMBER_OF_GUESSES;
}

- (BOOL)verifyAnswer:(id)answer
{
    [NSException raise:@" - (BOOL)verifyAnswer:(id)answer has to be implemented in subclass" format:nil];
    return NO;
}

- (NSString *)readableName
{
    [NSException raise:@" -  (NSString *)readableName has to be implemented in subclass" format:nil];
    return nil;
}

- (NSString *)questionCategoryString
{
    NSString *questionCategoryString;
    switch (self.questionCategory)
    {
        case QC_Personal:
            questionCategoryString = NSLocalizedString(@"Personal", nil);
            break;
        case QC_Education:
            questionCategoryString = NSLocalizedString(@"Education", nil);
            break;
        case QC_Professional:
            questionCategoryString = NSLocalizedString(@"Professional experience", nil);
            break;
        case QC_iOS:
            questionCategoryString = NSLocalizedString(@"iOS", nil);
            break;
        default:
            break;
    }
    return questionCategoryString;
}

- (NSString *)instructionTextString
{
    [NSException raise:@" - (NSString *)instructionTextString has to be implemented in subclass" format:nil];
    return @"";
}

- (NSString *)description
{
//    NSString *description = [NSString stringWithFormat:@"[%@ | %@] | Q: %@, A: %@ | Tries left: %d", NSStringFromClass([self class]), [self questionCategoryString], self.questionString, self.answerString, self.triesLeft];
    NSString *description = [NSString stringWithFormat:@"[%@] | Q: %@ | Answered: %@ | Tries left: %d", [super description], self.questionString, self.answered ? @"YES" : @"NO", self.triesLeft];

    return description;
}

@end
