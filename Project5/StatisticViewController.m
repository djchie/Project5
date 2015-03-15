//
//  StatisticViewController.m
//  Project5
//
//  Created by Derrick J Chie on 3/11/15.
//  Copyright (c) 2015 Derrick J Chie. All rights reserved.
//

#import "StatisticViewController.h"

@interface StatisticViewController ()

@end

@implementation StatisticViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"Statistics";

    self.dataManager = [DataManager sharedManager];

    NSNumber* quizAttemptCount = [self.dataManager quizAttemptCount];
    NSNumber* correctAnswerCount = [self.dataManager correctAnswerCount];
    NSNumber* incorrectAnswerCount = [self.dataManager incorrectAnswerCount];
    NSNumber* averageTimePerQuestion = [self.dataManager averageTimePerQuestion];

    self.quizAttemptCountLabel.text = [NSString stringWithFormat:@"%i times", [quizAttemptCount intValue]];
    self.correctAnswerCountLabel.text = [NSString stringWithFormat:@"%i questions", [correctAnswerCount intValue]];
    self.incorrectAnswerCountLabel.text = [NSString stringWithFormat:@"%i questions", [incorrectAnswerCount intValue]];
    self.averageTimePerQuestionLabel.text = [NSString stringWithFormat:@"%.02f seconds", [averageTimePerQuestion floatValue]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
