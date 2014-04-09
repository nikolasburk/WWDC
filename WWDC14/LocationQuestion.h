//
//  LocationQuestion.h
//  WWDC14
//
//  Created by Nikolas Burk on 05/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "Question.h"
#import <MapKit/MapKit.h>

#define kCoordinates @"coordinates"
#define kLatitude @"latitude"
#define kLongitude @"longitude"

@interface LocationQuestion : Question

@property (nonatomic, strong, readonly) NSDictionary *coordinates;

- (id)initWithQuestionString:(NSString *)questionString answerString:(NSString *)answerString category:(QuestionCategory)category coordinates:(NSDictionary *)coordinates;

@end
