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

NSString* const kCurrentTimeLeft = @"kCurrentTimeLeft";
NSString* const kCurrentCorrectCount = @"kCurrentCorrectCount";
NSString* const kCurrentIncorrectCount = @"kCurrentIncorrectCount";

NSString* const kCurrentQuestion = @"kCurrentQuestion";
NSString* const kCurrentCorrectAnswer = @"kCurrentCorrectAnswer";
NSString* const kCurrentCorrectAnswerNumber = @"kCurrentCorrectAnswerNumber";
NSString* const kCurrentOption1 = @"kCurrentOption1";
NSString* const kCurrentOption2 = @"kCurrentOption2";
NSString* const kCurrentOption3 = @"kCurrentOption3";

@implementation DataManager

@synthesize quizAttemptCount;
@synthesize correctAnswerCount;
@synthesize incorrectAnswerCount;
@synthesize averageTimePerQuestion;

@synthesize currentTimeLeft;
@synthesize currentCorrectCount;
@synthesize currentIncorrectCount;

@synthesize currentQuestion;
@synthesize currentCorrectAnswerNumber;
@synthesize currentCorrectAnswer;
@synthesize currentOption1;
@synthesize currentOption2;
@synthesize currentOption3;

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

- (void)saveCurrentGame
{
    [[NSUserDefaults standardUserDefaults] setObject:currentTimeLeft forKey:kCurrentTimeLeft];
    [[NSUserDefaults standardUserDefaults] setObject:currentCorrectCount forKey:kCurrentCorrectCount];
    [[NSUserDefaults standardUserDefaults] setObject:currentIncorrectCount forKey:kCurrentIncorrectCount];

    [[NSUserDefaults standardUserDefaults] setObject:currentQuestion forKey:kCurrentQuestion];
    [[NSUserDefaults standardUserDefaults] setObject:currentCorrectAnswerNumber forKey:kCurrentCorrectAnswerNumber];
    [[NSUserDefaults standardUserDefaults] setObject:currentCorrectAnswer forKey:kCurrentCorrectAnswer];
    [[NSUserDefaults standardUserDefaults] setObject:currentOption1 forKey:kCurrentOption1];
    [[NSUserDefaults standardUserDefaults] setObject:currentOption2 forKey:kCurrentOption2];
    [[NSUserDefaults standardUserDefaults] setObject:currentOption3 forKey:kCurrentOption3];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadCurrentGame
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kCurrentTimeLeft])
    {
        currentTimeLeft = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentTimeLeft];
        currentCorrectCount = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentCorrectCount];
        currentIncorrectCount = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentIncorrectCount];

        currentQuestion = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentQuestion];
        currentCorrectAnswerNumber = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentCorrectAnswerNumber];
        currentCorrectAnswer = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentCorrectAnswer];
        currentOption1 = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentOption1];
        currentOption2 = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentOption2];
        currentOption3 = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentOption3];
    }
}

@end
