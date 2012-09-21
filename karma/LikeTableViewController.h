//
//  LikeTableViewController.h
//  karma
//
//  Created by Faridh Mendoza on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DetailViewController;

@interface LikeTableViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
