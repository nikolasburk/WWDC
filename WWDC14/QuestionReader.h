//
//  QuestionReader.h
//  WWDC14
//
//  Created by Nikolas Burk on 05/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionTypes.h"

#define QUESTIONS_FILE_PATH @"Questions"
#define SUFFIX_PLIST @"plist"

#define kQuestion @"question"
#define kCategory @"category"
#define kType @"type"
#define kAnswer @"answer"

@interface QuestionReader : NSObject

@property (nonatomic, strong, readonly) NSArray *questions;

+ (QuestionReader *)questionReaderSharedInstance;

- (NSDictionary *)questionsForNewGame;
- (void)resetQuestions;

@end
