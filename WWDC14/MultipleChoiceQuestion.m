//
//  MultipleChoiceQuestion.m
//  WWDC14
//
//  Created by Nikolas Burk on 04/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "MultipleChoiceQuestion.h"

@implementation MultipleChoiceQuestion

- (id)initWithQuestionString:(NSString *)questionString answerString:(NSString *)answerString category:(QuestionCategory)category options:(NSArray *)options
{
    self = [super initWithQuestionString:questionString answerString:answerString category:category];
    if (self)
    {
        _options = options;
    }
    return self;
}

- (NSString *)instructionTextString
{
    return NSLocalizedString(@"This is a multiple choice question, please answer by tapping on the button that represents your answer.", nil);
}

- (NSString *)readableName
{
    return NSLocalizedString(@"Multiple choice question", nil);
}

//- (BOOL)answer:(id)answer
//{
//    NSString *answerString = answer;
//    _answered = [answerString isEqualToString:self.answerString];
//    _triesLeft = _answered ? _triesLeft : _triesLeft--;
//    return _answered;
//}

- (BOOL)verifyAnswer:(id)answer
{
    NSString *answerString = answer;
    return [answerString isEqualToString:self.answerString];
}

@end
