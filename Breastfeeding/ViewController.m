//
//  ViewController.m
//  Breastfeeding
//
//  Created by Samantha Cabral on 1/14/16.
//  Copyright © 2016 Samantha Cabral. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Feeding.h"

@interface ViewController ()

@property (nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UILabel *leftCounter;
@property (weak, nonatomic) IBOutlet UILabel *rightCounter;
@property (weak, nonatomic) IBOutlet UILabel *totalCounter;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, assign) int leftCounterLabel;
@property (nonatomic, assign) int rightCounterLabel;
@property (nonatomic, assign) int totalCounterLabel;
@property (nonatomic, assign) bool leftIsPaused;
@property (nonatomic, assign) bool rightIsPaused;
@property (nonatomic, assign) NSTimer *leftTimer;
@property (nonatomic, assign) NSTimer *rightTimer;

@property (weak, nonatomic) IBOutlet UILabel *latestFeeding;
@property (strong, nonatomic) NSDate *totalStartDate;



// need to figure out how to use the data from the fetch request to populate the table.


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.leftCounterLabel = 0;
    self.rightCounterLabel = 0;
    self.totalCounterLabel = 0;
    self.leftIsPaused = true;
    self.rightIsPaused = true;
    
    
    
    // Initialize table data
    [self updateLogList];
    

    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10; //[self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    // Reuse and create cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Update cell data contents
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.results objectAtIndex:indexPath.row]];
    
    
    return cell;
}




- (IBAction)saveButtonPressed:(id)sender {
    Feeding *f = [self.appDelegate createFeeding];
    
    NSNumber *leftVal = [NSNumber numberWithInteger:self.leftCounterLabel];

    NSNumber *rightVal = [NSNumber numberWithInteger:self.rightCounterLabel];
    
    NSNumber *totalVal = [NSNumber numberWithInteger:self.totalCounterLabel];

    
    f.left = leftVal;
    f.right = rightVal;
    f.total = totalVal;
    f.timeSince = self.totalStartDate;
    [self.appDelegate saveContext];
    
    [self updateLogList];
       
    [self.tableView reloadData];
    
}

- (void) updateLogList {
    [self pauseRightTimer];
    [self pauseLeftTimer];
    NSManagedObjectContext *moc = self.appDelegate.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Feeding"];
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    
    if (!results) {
        NSLog(@"Error fetching Feeding objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }

    self.leftCounterLabel =0;
    [self updateLeftTicker];
    self.rightCounterLabel =0;
    [self updateRightTicker];
    self.totalCounterLabel =0;
    [self updateTotalTicker];
    
    
    self.results = results;
    
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"timeSince"
                                        ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSArray *sortedEventArray = [self.results
                                 sortedArrayUsingDescriptors:sortDescriptors];

    self.results = sortedEventArray;
    
}


- (IBAction)leftButtonPressed:(id)sender {

    if (self.leftIsPaused) {
        self.leftIsPaused = false;
        [sender setTitle:@"Pause" forState:UIControlStateNormal];
        self.rightButton.enabled = NO;
        self.leftTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(leftTicker) userInfo:nil repeats:YES];
        if (self.rightCounterLabel == 0 ) {
            self.totalStartDate = [NSDate date];
        }
    } else {
    
        [self pauseLeftTimer];
        
    }
}

-(void)leftTicker {
    self.leftCounterLabel++;
    
    [self updateLeftTicker];
    
    [self totalTicker];
    
    
}


-(void)pauseLeftTimer {

    self.leftIsPaused = true;
    [self.leftTimer invalidate];
    self.leftTimer = nil;
    self.rightButton.enabled = YES;
    [self.leftButton setTitle:@"Left" forState:UIControlStateNormal];

    
}

-(void)pauseRightTimer {
    
    self.rightIsPaused = true;
    [self.rightTimer invalidate];
    self.rightTimer = nil;
    self.leftButton.enabled = YES;
    [self.rightButton setTitle:@"Right" forState:UIControlStateNormal];    
    
}


-(void)updateLeftTicker {
    NSUInteger h = self.leftCounterLabel / 3600;
    NSUInteger m = (self.leftCounterLabel / 60) % 60;
    NSUInteger s = self.leftCounterLabel % 60;
    
    NSString *leftTimeString = [NSString stringWithFormat:@"%lu:%02lu:%02lu", (unsigned long)h, (unsigned long)m, (unsigned long)s];
    
    self.leftCounter.text = leftTimeString;

}


- (IBAction)rightButtonPressed:(id)sender {
    
    if (self.rightIsPaused) {
        self.rightIsPaused = false;
        [sender setTitle:@"Pause" forState:UIControlStateNormal];
        self.leftButton.enabled = NO;
        self.rightTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(rightTicker) userInfo:nil repeats:YES];
        if (self.leftCounterLabel == 0 ) {
            self.totalStartDate = [NSDate date];
        }
    } else {
        
        [self pauseRightTimer];
        [sender setTitle:@"Right" forState:UIControlStateNormal];
        
    }
}

-(void)updateRightTicker {
    NSUInteger h = self.rightCounterLabel / 3600;
    NSUInteger m = (self.rightCounterLabel / 60) % 60;
    NSUInteger s = self.rightCounterLabel % 60;
    
    NSString *rightTimeString = [NSString stringWithFormat:@"%lu:%02lu:%02lu", (unsigned long)h, (unsigned long)m, (unsigned long)s];
    
    self.rightCounter.text = rightTimeString;
    
}

-(void)rightTicker {

    self.rightCounterLabel++;

    [self updateRightTicker];
    
    [self totalTicker];
   
}

-(void)totalTicker {
    self.totalCounterLabel++;
    [self updateTotalTicker];

    
}
-(void)updateTotalTicker {

    // Create a date formatter
    NSUInteger h = self.totalCounterLabel / 3600;
    NSUInteger m = (self.totalCounterLabel / 60) % 60;
    NSUInteger s = self.totalCounterLabel % 60;
    
    NSString *totalTimeString = [NSString stringWithFormat:@"%lu:%02lu:%02lu", (unsigned long)h, (unsigned long)m, (unsigned long)s];
    
    self.totalCounter.text = totalTimeString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
