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
    NSNumber* currentTimeLeft;
    NSNumber* currentCorrectCount;
    NSNumber* currentIncorrectCount;

    NSString* currentQuestion;
    NSNumber* currentCorrectAnswerNumber;
    NSString* currentCorrectAnswer;
    NSString* currentOption1;
    NSString* currentOption2;
    NSString* currentOption3;
}

@property (nonatomic, retain) NSNumber* quizAttemptCount;
@property (nonatomic, retain) NSNumber* correctAnswerCount;
@property (nonatomic, retain) NSNumber* incorrectAnswerCount;
@property (nonatomic, retain) NSNumber* averageTimePerQuestion;

@property (nonatomic, retain) NSNumber* currentTimeLeft;
@property (nonatomic, retain) NSNumber* currentCorrectCount;
@property (nonatomic, retain) NSNumber* currentIncorrectCount;

@property (nonatomic, retain) NSString* currentQuestion;
@property (nonatomic, retain) NSNumber* currentCorrectAnswerNumber;
@property (nonatomic, retain) NSString* currentCorrectAnswer;
@property (nonatomic, retain) NSString* currentOption1;
@property (nonatomic, retain) NSString* currentOption2;
@property (nonatomic, retain) NSString* currentOption3;

+ (id)sharedManager;
- (void)incrementQuizAttemptCount;
- (void)addCorrectAnswerCount:(NSNumber*)addCount;
- (void)addIncorrectAnswerCount:(NSNumber*)addCount;

- (void)saveData;
- (void)loadData;
- (void)saveCurrentGame;
- (void)loadCurrentGame;

@end
