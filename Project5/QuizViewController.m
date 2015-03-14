//
//  QuizViewController.m
//  Project5
//
//  Created by Derrick J Chie on 3/11/15.
//  Copyright (c) 2015 Derrick J Chie. All rights reserved.
//

#import "QuizViewController.h"

@interface QuizViewController ()

@end

@implementation QuizViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"moviedb.sql"];
    self.dataManager = [DataManager sharedManager];

    UIBarButtonItem *quitButton = [[UIBarButtonItem alloc] initWithTitle:@"Quit"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(quitButtonPressed)];
    self.navigationItem.leftBarButtonItem = quitButton;

    [self newGame];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)quitButtonPressed
{
    if (self.timeLeft > 0)
    {
        NSString* title = @"Do you really want to quit?";
        NSString* message = @"Your current quiz will not be saved";
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Quit", nil];
        [alertView show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSString *)timeFormatted:(int)totalSeconds
{

    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    NSString* formattedString = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    formattedString = [formattedString substringFromIndex:1];

    return formattedString;
}

- (void)resetTimer
{
    self.timeLeft = 180;
    self.navigationItem.title = [self timeFormatted:self.timeLeft];
}

- (void)onTick
{
    if (self.paused == NO)
    {
        if (self.timeLeft > 0)
        {
            self.timeLeft--;
            self.navigationItem.title = [self timeFormatted:self.timeLeft];
        }
        else
        {
            // Handle game over
            [self.timer invalidate];
            self.timer = nil;

            self.gameOverView.hidden = NO;
            float averageTimePerQuestion = 180.0 / (self.correctCount + self.incorrectCount);
            self.averageTimePerQuestionLabel.text = [NSString stringWithFormat:@"Average Time Per Question: %.02f seconds", averageTimePerQuestion];
            self.navigationItem.leftBarButtonItem.title = @"Back";
            self.navigationItem.rightBarButtonItem.title = @"New Game";
            self.navigationItem.rightBarButtonItem.action = @selector(newGame);

            [self recordStatistics];
        }
    }
}

- (void)recordStatistics
{
    [self.dataManager incrementQuizAttemptCount];
    [self.dataManager addCorrectAnswerCount:self.correctCount];
    [self.dataManager addIncorrectAnswerCount:self.incorrectCount];
    int totalQuizAttemptCount = [[self.dataManager quizAttemptCount] intValue];
    int totalCorrectAnswerCount = [[self.dataManager correctAnswerCount] intValue];
    int totalIncorrectAnswerCount = [[self.dataManager incorrectAnswerCount] intValue];
    float averageTimePerQuestion = (180.0 * totalQuizAttemptCount) / (totalCorrectAnswerCount + totalIncorrectAnswerCount);
    [self.dataManager setAverageTimePerQuestion:[NSNumber numberWithFloat:averageTimePerQuestion]];
}

- (void)newGame
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTick) userInfo: nil repeats:YES];

    self.gameOverView.hidden = YES;

    self.navigationItem.leftBarButtonItem.title = @"Quit";
    UIBarButtonItem *pauseButton = [[UIBarButtonItem alloc] initWithTitle:@"Pause"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(pauseGame)];
    self.navigationItem.rightBarButtonItem = pauseButton;

    [self resetTimer];
    self.correctCount = 0;
    self.incorrectCount = 0;
    [self updateCorrectIncorrectCount];
    self.paused = NO;

    [self generateQuestion];
}

- (void)pauseGame
{
    self.paused = YES;
    self.pausedGameView.hidden = NO;
    self.navigationItem.rightBarButtonItem.title = @"Resume";
    self.navigationItem.rightBarButtonItem.action = @selector(resumeGame);
}

- (void)resumeGame
{
    self.paused = NO;
    self.pausedGameView.hidden = YES;
    self.navigationItem.rightBarButtonItem.title = @"Pause";
    self.navigationItem.rightBarButtonItem.action = @selector(pauseGame);
}

- (void)updateCorrectIncorrectCount
{
    self.correctCountLabel.text = [NSString stringWithFormat:@"%i", self.correctCount];
    self.incorrectCounterLabel.text = [NSString stringWithFormat:@"%i", self.incorrectCount];
}

- (void)generateQuestion
{
    // Randomly selects 1 out of 10 question formats

    // Creates a random number between 1 and 10
    int questionType = (arc4random() % 10) + 1;
    questionType = 2;

    if (questionType == 1)
    {
        [self generateWhoDirectedMovieX];
    }
    else if (questionType == 2)
    {
        [self generateWhenMovieXReleased];
    }
//    else if (questionType == 3)
//    {
//        [self generateWhichStarInMovieX];
//    }
//    else if (questionType == 4)
//    {
//        [self generateWhichStarNotInMovieX];
//    }
//    else if (questionType == 5)
//    {
//        [self generateWhichMovieXYTogether];
//    }
//    else if (questionType == 6)
//    {
//        [self generateWhoDirectedStarX];
//    }
//    else if (questionType == 7)
//    {
//        [self generateWhoDidNotDirectStarX];
//    }
//    else if (questionType == 8)
//    {
//        [self generateWhichStarAppearsInMovieXY];
//    }
//    else if (questionType == 9)
//    {
//        [self generateWhichStarNotInSameMovieStarX]
//    }
//    else if (questionType == 10)
//    {
//        [self generateWhoDirectedStarXYearY];
//    }
}

- (void)generateWhoDirectedMovieX
{
    NSString* query = @"SELECT * FROM movies ORDER BY random() LIMIT 4";
    NSArray* results = [self loadResultsWithQuery:query];

    NSArray* movie1 = [[NSArray alloc] initWithArray:results[0]];
    NSArray* movie2 = [[NSArray alloc] initWithArray:results[1]];
    NSArray* movie3 = [[NSArray alloc] initWithArray:results[2]];
    NSArray* movie4 = [[NSArray alloc] initWithArray:results[3]];

    NSString* questionString = [NSString stringWithFormat:@"Who directed the movie %@?", movie1[1]];
    self.questionLabel.text = questionString;

    self.correctAnswerString = movie1[3];
    NSString* option1 = movie2[3];
    NSString* option2 = movie3[3];
    NSString* option3 = movie4[3];

    [self loadOptions:option1 secondOption:option2 thirdOption:option3 withAnswer:self.correctAnswerString];
}

- (void)generateWhenMovieXReleased
{
#warning Need to clean up query where two movies might have the same year
    NSString* query = @"SELECT * FROM movies ORDER BY random() LIMIT 4";
    NSArray* results = [self loadResultsWithQuery:query];

    NSArray* movie1 = [[NSArray alloc] initWithArray:results[0]];
    NSArray* movie2 = [[NSArray alloc] initWithArray:results[1]];
    NSArray* movie3 = [[NSArray alloc] initWithArray:results[2]];
    NSArray* movie4 = [[NSArray alloc] initWithArray:results[3]];

    NSString* questionString = [NSString stringWithFormat:@"When was the movie %@ released?", movie1[1]];
    self.questionLabel.text = questionString;

    self.correctAnswerString = movie1[2];
    NSString* option1 = movie2[2];
    NSString* option2 = movie3[2];
    NSString* option3 = movie4[2];

    [self loadOptions:option1 secondOption:option2 thirdOption:option3 withAnswer:self.correctAnswerString];
}

- (void)loadOptions:(NSString *)option1 secondOption:(NSString *)option2 thirdOption:(NSString *)option3 withAnswer:(NSString *)answer
{
    self.correctAnswer = (arc4random() % 4) + 1;
    int falseOption = 0;

    for (int i = 1; i < 5; i++)
    {
        UIButton *currentButton = (UIButton *)[self.view viewWithTag:i];

        if (i == self.correctAnswer)
        {
            [currentButton setTitle:answer forState:UIControlStateNormal];
        }
        else
        {
            if (falseOption == 0)
            {
                [currentButton setTitle:option1 forState:UIControlStateNormal];
            }
            else if (falseOption == 1)
            {
                [currentButton setTitle:option2 forState:UIControlStateNormal];
            }
            else if (falseOption == 2)
            {
                [currentButton setTitle:option3 forState:UIControlStateNormal];
            }

            falseOption++;
        }
    }
}

- (NSArray *)loadResultsWithQuery:(NSString *)query
{
    NSArray* results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];

    return results;
}

- (IBAction)optionButtonPressed:(id)sender
{
    UIButton* selectedButton = (UIButton *)sender;
    NSString* title = @"";
    NSString* message = @"";

    if (selectedButton.tag == self.correctAnswer)
    {
        // Answer is correct!
        self.correctCount++;
        title = @"Correct!";
        message = @"You are one smart cookie :]";
    }
    else
    {
        // Answer is incorrect :(
        self.incorrectCount++;
        title = @"Incorrect :(";
        message = [NSString stringWithFormat:@"The correct answer was %@", self.correctAnswerString];
    }

    [self updateCorrectIncorrectCount];

    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Next Question", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];

    if ([title isEqualToString:@"Next Question"])
    {
        [self generateQuestion];
    }
    else if ([title isEqualToString:@"Quit"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

@end
