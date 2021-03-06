//
//  QuizViewController.h
//  Project5
//
//  Created by Derrick J Chie on 3/11/15.
//  Copyright (c) 2015 Derrick J Chie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "DataManager.h"

@interface QuizViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) DataManager *dataManager;
@property (nonatomic) int correctAnswer;
@property (nonatomic, strong) NSString* correctAnswerString;
@property (nonatomic, strong) NSNumber* correctCount;
@property (nonatomic, strong) NSNumber* incorrectCount;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) NSNumber* timeLeft;
@property (nonatomic) BOOL paused;
@property (nonatomic, strong) NSString* option1String;
@property (nonatomic, strong) NSString* option2String;
@property (nonatomic, strong) NSString* option3String;

@property (weak, nonatomic) IBOutlet UILabel *correctCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *incorrectCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *optionButton;
@property (weak, nonatomic) IBOutlet UIView *pausedGameView;
@property (weak, nonatomic) IBOutlet UIView *gameOverView;
@property (weak, nonatomic) IBOutlet UILabel *averageTimePerQuestionLabel;

- (IBAction)optionButtonPressed:(id)sender;
- (void)pauseGame;

@end
