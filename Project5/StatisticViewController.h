//
//  StatisticViewController.h
//  Project5
//
//  Created by Derrick J Chie on 3/11/15.
//  Copyright (c) 2015 Derrick J Chie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface StatisticViewController : UIViewController

@property (nonatomic, strong) DataManager *dataManager;

@property (weak, nonatomic) IBOutlet UILabel *quizAttemptCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *correctAnswerCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *incorrectAnswerCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageTimePerQuestionLabel;


@end
