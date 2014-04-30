//
//  MPPreviousTableViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/13/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPPreviousTableViewController.h"

@interface MPPreviousTableViewController ()

@end

@implementation MPPreviousTableViewController

@synthesize pageViewController = _pageViewController;

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor = [MPColorManager lightColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iCloudRefresh) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    if ([[MPPark parkArchives] count] == 0) {
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
    } else {
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"PreviousParkSegue"]) {
        
        NSData *parkData = [[MPPark parkArchives] objectAtIndex:((NSIndexPath *)sender).row];
        MPPark *park = [NSKeyedUnarchiver unarchiveObjectWithData:parkData];
        park.index = ((NSIndexPath *)sender).row;
        MPPreviousParkViewController *viewController = [segue destinationViewController];
        viewController.currentPark = park;
        
    }
    
}

#pragma mark - UITableViewDataSource Protocol && UITableViewDelegate Protocol Instance Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[MPPark parkArchives] count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Fetch Cell
    static NSString *cellIdentifier = @"ParkCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Populate Cell
    NSData *parkData = [[MPPark parkArchives] objectAtIndex:indexPath.row];
    MPPark *park = [NSKeyedUnarchiver unarchiveObjectWithData:parkData];
    cell.textLabel.text = park.parkTag;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    cell.detailTextLabel.text = [dateFormatter stringFromDate:park.parkDate];
    
    // Style Cell
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:[MPPark parkArchives]];
        [newArray removeObjectAtIndex:indexPath.row];
        if (![MPPark canUseiCloud]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:@"PreviousKey"];
            
        } else {
            
            [[NSUbiquitousKeyValueStore defaultStore] setObject:newArray forKey:@"PreviousKey"];
            
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"PreviousParkSegue" sender:indexPath];
    
}

#pragma mark - Private Instance Methods

- (void)iCloudRefresh {
    
    [self.tableView reloadData];
    
}

#pragma mark - Actions

- (IBAction)userRefresh:(id)sender {
    
    [self.tableView reloadData];
    UIRefreshControl *refreshControl = (UIRefreshControl *)sender;
    [refreshControl endRefreshing];
    
}

@end
