//
//  LocationQuestion.m
//  WWDC14
//
//  Created by Nikolas Burk on 05/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#define MAX_TOTAL_DEVIATION 1.5

#import "LocationQuestion.h"

@implementation LocationQuestion

- (id)initWithQuestionString:(NSString *)questionString answerString:(NSString *)answerString category:(QuestionCategory)category coordinates:(NSDictionary *)coordinates
{
    self = [super initWithQuestionString:questionString answerString:answerString category:category];
    if (self)
    {
        _coordinates = coordinates;
    }
    return self;
}


- (NSString *)instructionTextString
{
    return NSLocalizedString(@"This is a location question. Please find the sought location on the map and perform a long press (hold and release) on it to submit an answer.", nil);
}

- (NSString *)readableName
{
    return NSLocalizedString(@"Location question", nil);
}

- (BOOL)verifyAnswer:(id)answer
{
    BOOL answerCorrect = NO;
    NSDictionary *coordinates = (NSDictionary *)answer;
    float totalDifference = 0.0;
    
    float actualDifference = [self.coordinates[kLatitude] floatValue] - [self.coordinates[kLongitude] floatValue];
    actualDifference = actualDifference < 0 ? actualDifference * -1 :actualDifference;

    float latitudeDifference = [coordinates[kLatitude] floatValue] - [self.coordinates[kLatitude] floatValue];
    latitudeDifference = latitudeDifference < 0 ? latitudeDifference * -1 :latitudeDifference;
    float longitudeDifference = [coordinates[kLongitude] floatValue] - [self.coordinates[kLongitude] floatValue];
    longitudeDifference = longitudeDifference < 0 ? longitudeDifference * -1 :longitudeDifference;
    
    totalDifference = latitudeDifference+longitudeDifference;
    
    NSLog(@"DEBUG | %s | Total difference in coordinates: %f", __func__, totalDifference);
    
    if (totalDifference < MAX_TOTAL_DEVIATION)
    {
        answerCorrect = YES;
    }
    
    return answerCorrect;
}
@end
