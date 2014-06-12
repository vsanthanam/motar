//
//  MPPinColorTableViewController.m
//  motar
//
//  Created by Varun Santhanam on 4/14/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPPinColorTableViewController.h"

@interface MPPinColorTableViewController ()

@end

@implementation MPPinColorTableViewController

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.view.backgroundColor = [MPColorManager lightColor];
    self.redCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.greenCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    self.purpleCell.backgroundColor = [MPColorManager darkColorLessAlpha];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -  UITableViewDataSource Protocol Instance MEthods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.row == (NSInteger)[MPParkInfoViewController pinColor]) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MKPinAnnotationColor color = (MKPinAnnotationColor)indexPath.row;
    [MPParkInfoViewController setPinColor:color];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
