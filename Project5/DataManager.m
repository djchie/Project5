//
//  StatisticManager.m
//  Project5
//
//  Created by Derrick J Chie on 3/13/15.
//  Copyright (c) 2015 Derrick J Chie. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

@synthesize quizAttemptCount;
@synthesize correctAnswerCount;
@synthesize incorrectAnswerCount;
@synthesize averageTimePerQuestion;

#pragma mark Singleton Methods

+ (id)sharedManager
{
    static DataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init
{
    if (self = [super init])
    {
        quizAttemptCount = [NSNumber numberWithInt:0];
        correctAnswerCount = [NSNumber numberWithInt:0];
        incorrectAnswerCount = [NSNumber numberWithInt:0];
        averageTimePerQuestion = [NSNumber numberWithFloat:0.0];
    }
    return self;
}

- (void)incrementQuizAttemptCount
{
    int value = [quizAttemptCount intValue];
    quizAttemptCount = [NSNumber numberWithInt:(value + 1)];
}

- (void)addCorrectAnswerCount:(int)addCount
{
    int value = [correctAnswerCount intValue];
    correctAnswerCount = [NSNumber numberWithInt:(value + addCount)];
}

- (void)addIncorrectAnswerCount:(int)addCount
{
    int value = [incorrectAnswerCount intValue];
    incorrectAnswerCount = [NSNumber numberWithInt:(value + addCount)];
}

@end
