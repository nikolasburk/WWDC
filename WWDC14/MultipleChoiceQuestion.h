//
//  MultipleChoiceQuestion.h
//  WWDC14
//
//  Created by Nikolas Burk on 04/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "Question.h"

#define kOptions @"options"

@interface MultipleChoiceQuestion : Question

@property (nonatomic, strong) NSArray *options;

- (id)initWithQuestionString:(NSString *)questionString answerString:(NSString *)answerString category:(QuestionCategory)category options:(NSArray *)options;
@end
