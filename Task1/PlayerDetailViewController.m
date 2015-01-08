//
//  DetailViewController.m
//  Task1
//
//  Created by Roman on 1/3/15.
//  Copyright (c) 2015 Rechich Roman. All rights reserved.
//

#import "PlayerDetailViewController.h"
#import "Team.h"

@interface PlayerDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UITextField *goalsField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end

@implementation PlayerDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
        [self configureView];
    }
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)newContext {
    if (_context != newContext) {
        _context = newContext;
    }
}

- (void)configureView {
    if (self.detailItem) {
        self.nameField.text = [[self.detailItem valueForKey:@"name"]description];
        self.goalsField.text = [[self.detailItem valueForKey:@"goals"]description];
        self.numberField.text = [[self.detailItem valueForKey:@"number"]description];
        self.title = @"Detail";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        [self.detailItem setValue:self.nameField.text forKey:@"name"];
        [self.detailItem setValue:@([self.goalsField.text integerValue]) forKey:@"goals"];
        [self.detailItem setValue:@([self.numberField.text integerValue]) forKey:@"number"];
        [self saveContext];
    }
}

- (void)saveContext {
    NSError *error = nil;
    if (![_context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
