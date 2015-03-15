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
    if ([self.timeLeft intValue] > 0)
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

- (NSString *)timeFormatted:(NSNumber*)totalSeconds
{
    int seconds = [totalSeconds intValue] % 60;
    int minutes = ([totalSeconds intValue] / 60) % 60;
    NSString* formattedString = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    formattedString = [formattedString substringFromIndex:1];

    return formattedString;
}

- (void)resetTimer
{
    self.timeLeft = [NSNumber numberWithInt:180];
    self.navigationItem.title = [self timeFormatted:self.timeLeft];
}

- (void)onTick
{
    if (self.paused == NO)
    {
        if ([self.timeLeft intValue] > 0)
        {
            int value = [self.timeLeft intValue];
            self.timeLeft = [NSNumber numberWithInt:(value - 1)];
            self.navigationItem.title = [self timeFormatted:self.timeLeft];
        }
        else
        {
            // Handle game over
            [self.timer invalidate];
            self.timer = nil;

            self.gameOverView.hidden = NO;
            float averageTimePerQuestion = 180.0 / ([self.correctCount intValue] + [self.incorrectCount intValue]);
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
    self.correctCountLabel.text = [NSString stringWithFormat:@"%i", [self.correctCount intValue]];
    self.incorrectCounterLabel.text = [NSString stringWithFormat:@"%i", [self.incorrectCount intValue]];
}

- (void)generateQuestion
{
    // Randomly selects 1 out of 10 question formats

    // Creates a random number between 1 and 10
    int questionType = (arc4random() % 10) + 1;
    questionType = 6;

    if (questionType == 1)
    {
        [self generateWhoDirectedMovieX];
    }
    else if (questionType == 2)
    {
        [self generateWhenMovieXReleased];
    }
    else if (questionType == 3)
    {
        [self generateWhichStarInMovieX];
    }
    else if (questionType == 4)
    {
        [self generateWhichStarNotInMovieX];
    }
    else if (questionType == 5)
    {
        [self generateWhichMovieXYTogether];
    }
    else if (questionType == 6)
    {
        [self generateWhoDirectedStarX];
    }
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

// Question 1
- (void)generateWhoDirectedMovieX
{
    NSString* query = @"SELECT * FROM movies GROUP BY director ORDER BY random() LIMIT 4";
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

// Question 2
- (void)generateWhenMovieXReleased
{
#warning Need to clean up query where two movies might have the same year
    NSString* query = @"SELECT * FROM movies GROUP BY year ORDER BY random() LIMIT 4";
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

// Question 3
- (void)generateWhichStarInMovieX
{
    NSString* movieQuery = @"SELECT * FROM movies ORDER BY random() LIMIT 1";
    NSArray* movieResult = [self loadResultsWithQuery:movieQuery];
    NSArray* movie = [[NSArray alloc] initWithArray:movieResult[0]];

    NSString* answerStarQuery = [NSString stringWithFormat:@"SELECT * FROM stars WHERE id IN (SELECT star_id FROM stars_in_movies WHERE movie_id IN (SELECT id FROM movies WHERE title = \"%@\"))", movie[1]];
    NSArray* answerStarResult = [self loadResultsWithQuery:answerStarQuery];
    NSArray* answerStar = [[NSArray alloc] initWithArray:answerStarResult[0]];

    NSString* starOptionQuery = @"SELECT * FROM stars ORDER BY random() LIMIT 3";
    NSArray* starOptionResult = [self loadResultsWithQuery:starOptionQuery];
    NSArray* star1 = [[NSArray alloc] initWithArray:starOptionResult[0]];
    NSArray* star2 = [[NSArray alloc] initWithArray:starOptionResult[1]];
    NSArray* star3 = [[NSArray alloc] initWithArray:starOptionResult[2]];

    NSString* questionString = [NSString stringWithFormat:@"Which star was in the movie %@?", movie[1]];
    self.questionLabel.text = questionString;

    self.correctAnswerString = [NSString stringWithFormat:@"%@ %@", answerStar[1], answerStar[2]];
    NSString* option1 = [NSString stringWithFormat:@"%@ %@", star1[1], star1[2]];
    NSString* option2 = [NSString stringWithFormat:@"%@ %@", star2[1], star2[2]];
    NSString* option3 = [NSString stringWithFormat:@"%@ %@", star3[1], star3[2]];

    [self loadOptions:option1 secondOption:option2 thirdOption:option3 withAnswer:self.correctAnswerString];
}

// Question 4
- (void)generateWhichStarNotInMovieX
{
    NSString* movieQuery = @"SELECT movies.title FROM movies WHERE id IN (SELECT movie_id FROM stars_in_movies GROUP BY movie_id HAVING count(movie_id) > 2) ORDER BY random() LIMIT 1";
    NSArray* movieResult = [self loadResultsWithQuery:movieQuery];
    NSArray* movie = [[NSArray alloc] initWithArray:movieResult[0]];

    NSString* starOptionQuery = [NSString stringWithFormat:@"SELECT s.first_name, s.last_name FROM stars AS s WHERE s.id IN (select sm.star_id FROM stars_in_movies AS sm WHERE sm.movie_id IN (select m.id FROM movies AS m where title = \"%@\")) LIMIT 3", movie[0]];
    NSArray* starOptionResult = [self loadResultsWithQuery:starOptionQuery];
    NSArray* star1 = [[NSArray alloc] initWithArray:starOptionResult[0]];
    NSArray* star2 = [[NSArray alloc] initWithArray:starOptionResult[1]];
    NSArray* star3 = [[NSArray alloc] initWithArray:starOptionResult[2]];

    NSString* answerStarQuery = [NSString stringWithFormat:@"SELECT s.first_name, s.last_name FROM stars AS s WHERE s.id NOT IN (SELECT sm.star_id FROM stars_in_movies AS sm WHERE sm.movie_id IN (SELECT m.id FROM movies AS m WHERE title = \"%@\")) ORDER BY random() LIMIT 1", movie[0]];
    NSArray* answerStarResult = [self loadResultsWithQuery:answerStarQuery];
    NSArray* answerStar = [[NSArray alloc] initWithArray:answerStarResult[0]];

    NSString* questionString = [NSString stringWithFormat:@"Which star was not in the movie %@?", movie[0]];
    self.questionLabel.text = questionString;

    self.correctAnswerString = [NSString stringWithFormat:@"%@ %@", answerStar[0], answerStar[1]];
    NSString* option1 = [NSString stringWithFormat:@"%@ %@", star1[0], star1[1]];
    NSString* option2 = [NSString stringWithFormat:@"%@ %@", star2[0], star2[1]];
    NSString* option3 = [NSString stringWithFormat:@"%@ %@", star3[0], star3[1]];

    [self loadOptions:option1 secondOption:option2 thirdOption:option3 withAnswer:self.correctAnswerString];
}

// Question 5
- (void)generateWhichMovieXYTogether
{
    NSString* movieQuery = @"SELECT movies.title FROM movies WHERE id IN (SELECT movie_id FROM stars_in_movies GROUP BY movie_id HAVING count(movie_id) > 1) ORDER BY random() LIMIT 1";
    NSArray* answerMovieResult = [self loadResultsWithQuery:movieQuery];
    NSArray* answerMovie = [[NSArray alloc] initWithArray:answerMovieResult[0]];

    NSString* starQuery = [NSString stringWithFormat:@"SELECT s.first_name, s.last_name, s.id FROM stars AS s WHERE s.id IN (SELECT sm.star_id FROM stars_in_movies AS sm WHERE sm.movie_id IN (SELECT m.id FROM movies AS m WHERE title = \"%@\")) LIMIT 2", answerMovie[0]];
    NSArray* starResult = [self loadResultsWithQuery:starQuery];
    NSArray* star1 = [[NSArray alloc] initWithArray:starResult[0]];
    NSArray* star2 = [[NSArray alloc] initWithArray:starResult[1]];
    NSString* star1Name = [NSString stringWithFormat:@"%@ %@", star1[0], star1[1]];
    NSString* star2Name = [NSString stringWithFormat:@"%@ %@", star2[0], star2[1]];

    NSString* questionString = [NSString stringWithFormat:@"In which movie the stars %@ and %@ appear together?", star1Name, star2Name];
    self.questionLabel.text = questionString;

    NSString* movieOptionQuery = [NSString stringWithFormat:@"SELECT movies.title FROM movies WHERE movies.title <> \"%@\" ORDER BY random() LIMIT 3", answerMovie[0]];
    NSArray* movieOptionResult = [self loadResultsWithQuery:movieOptionQuery];
    NSArray* movie1 = [[NSArray alloc] initWithArray:movieOptionResult[0]];
    NSArray* movie2 = [[NSArray alloc] initWithArray:movieOptionResult[1]];
    NSArray* movie3 = [[NSArray alloc] initWithArray:movieOptionResult[2]];

    self.correctAnswerString = answerMovie[0];
    NSString* option1 = movie1[0];
    NSString* option2 = movie2[0];
    NSString* option3 = movie3[0];

    [self loadOptions:option1 secondOption:option2 thirdOption:option3 withAnswer:self.correctAnswerString];
}

// Question 6
- (void)generateWhoDirectedStarX
{
    NSString* movieQuery = @"SELECT title, director FROM movies ORDER BY random() LIMIT 1";
    NSArray* answerMovieResult = [self loadResultsWithQuery:movieQuery];
    NSArray* answerMovie = [[NSArray alloc] initWithArray:answerMovieResult[0]];

    NSString* starQuery = [NSString stringWithFormat:@"SELECT s.first_name, s.last_name FROM stars AS s WHERE s.id IN (SELECT sm.star_id FROM stars_in_movies AS sm WHERE sm.movie_id IN (SELECT m.id FROM movies AS m WHERE title = \"%@\")) LIMIT 1", answerMovie[0]];
    NSArray* starResult = [self loadResultsWithQuery:starQuery];
    NSArray* star = [[NSArray alloc] initWithArray:starResult[0]];

    NSString* starName = [NSString stringWithFormat:@"%@ %@", star[0], star[1]];

    NSString* questionString = [NSString stringWithFormat:@"Who directed the star %@?", starName];
    self.questionLabel.text = questionString;

    NSString* movieOptionQuery = [NSString stringWithFormat:@"SELECT movies.title FROM movies WHERE movies.title <> \"%@\" ORDER BY random() LIMIT 3", answerMovie[0]];
    NSArray* movieOptionResult = [self loadResultsWithQuery:movieOptionQuery];
    NSArray* movie1 = [[NSArray alloc] initWithArray:movieOptionResult[0]];
    NSArray* movie2 = [[NSArray alloc] initWithArray:movieOptionResult[1]];
    NSArray* movie3 = [[NSArray alloc] initWithArray:movieOptionResult[2]];

    self.correctAnswerString = answerMovie[1];
    NSString* option1 = movie1[0];
    NSString* option2 = movie2[0];
    NSString* option3 = movie3[0];

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
        int value = [self.correctCount intValue];
        self.correctCount = [NSNumber numberWithInt:(value + 1)];
        title = @"Correct!";
        message = @"You are one smart cookie :]";
    }
    else
    {
        // Answer is incorrect :(
        int value = [self.incorrectCount intValue];
        self.incorrectCount = [NSNumber numberWithInt:(value + 1)];
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
