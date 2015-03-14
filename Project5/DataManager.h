//
//  StatisticManager.h
//  Project5
//
//  Created by Derrick J Chie on 3/13/15.
//  Copyright (c) 2015 Derrick J Chie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject
{
    // For overall stats
    NSNumber* quizAttemptCount ;
    NSNumber* correctAnswerCount;
    NSNumber* incorrectAnswerCount;
    NSNumber* averageTimePerQuestion;

    // For question persistency
    NSString* currentQuestion;
    int correctAnswer;
    NSString* correctAnswerString;
}

@property (nonatomic, retain) NSNumber* quizAttemptCount;
@property (nonatomic, retain) NSNumber* correctAnswerCount;
@property (nonatomic, retain) NSNumber* incorrectAnswerCount;
@property (nonatomic, retain) NSNumber* averageTimePerQuestion;

+ (id)sharedManager;
- (void)incrementQuizAttemptCount;
- (void)addCorrectAnswerCount:(int)addCount;
- (void)addIncorrectAnswerCount:(int)addCount;
- (int)getQuizAttemptCount;
- (int)getCorrectAnswerCount;
- (int)getIncorrectAnswerCount;
- (float)getAverageTimePerQuestion;

@end
