//
//  Question.h
//  WWDC14
//
//  Created by Nikolas Burk on 04/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <Foundation/Foundation.h>


#define LOCATION_SHORT @"L"
#define MULTIPLE_CHOICE_SHORT @"MC"

typedef enum {
    QC_Personal = 0,
    QC_Education,
    QC_Professional,
    QC_iOS
} QuestionCategory;

@interface Question : NSObject

@property (nonatomic, strong, readonly) NSString *questionString;
@property (nonatomic, strong, readonly) NSString *answerString;
@property (nonatomic, assign, readonly) QuestionCategory questionCategory;

@property (nonatomic, assign, readonly) BOOL answered;
@property (nonatomic, assign, readonly) NSInteger triesLeft;

- (id)initWithQuestionString:(NSString *)questionString answerString:(NSString *)answerString category:(QuestionCategory)category;

- (BOOL)answer:(id)answer;
- (void)reset;
- (NSString *)questionCategoryString;
- (NSString *)instructionTextString;
- (NSString *)readableName;
- (UIColor *)categoryColor;
@end
