//
//  DetailViewController.h
//  Task1
//
//  Created by Roman on 1/3/15.
//  Copyright (c) 2015 Rechich Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerDetailViewController : UITableViewController < UITextViewDelegate >

@property (strong, nonatomic) id detailItem;
@property (nonatomic, retain) NSManagedObjectContext *context;

@end

