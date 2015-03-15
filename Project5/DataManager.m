//
//  StatisticManager.m
//  Project5
//
//  Created by Derrick J Chie on 3/13/15.
//  Copyright (c) 2015 Derrick J Chie. All rights reserved.
//

#import "DataManager.h"

NSString* const kQuizAttemptCount = @"kQuizAttemptCount";
NSString* const kCorrectAnswerCount = @"kCorrectAnswerCount";
NSString* const kIncorrectAnswerCount = @"kIncorrectAnswerCount";
NSString* const kAverageTimePerQuestion = @"kAverageTimePerQuestion";

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

- (void)addCorrectAnswerCount:(NSNumber*)addCount
{
    int value = [correctAnswerCount intValue];
    int addValue = [addCount intValue];
    correctAnswerCount = [NSNumber numberWithInt:(value + addValue)];
}

- (void)addIncorrectAnswerCount:(NSNumber*)addCount
{
    int value = [incorrectAnswerCount intValue];
    int addValue = [addCount intValue];
    incorrectAnswerCount = [NSNumber numberWithInt:(value + addValue)];
}

- (void)saveData
{
//    int addValue = [quizAttemptCount intValue];
//    quizAttemptCount = [NSNumber numberWithInt:(addValue + 25)];
//
//    // incrememnt this
//    
    [[NSUserDefaults standardUserDefaults] setObject:quizAttemptCount forKey:kQuizAttemptCount];
    [[NSUserDefaults standardUserDefaults] setObject:correctAnswerCount forKey:kCorrectAnswerCount];
    [[NSUserDefaults standardUserDefaults] setObject:incorrectAnswerCount forKey:kIncorrectAnswerCount];
    [[NSUserDefaults standardUserDefaults] setObject:averageTimePerQuestion forKey:kAverageTimePerQuestion];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadData
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kQuizAttemptCount])
    {
        quizAttemptCount = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:kQuizAttemptCount];
        correctAnswerCount = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:kCorrectAnswerCount];
        incorrectAnswerCount = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:kIncorrectAnswerCount];
        averageTimePerQuestion = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:kAverageTimePerQuestion];
    }
}

@end
