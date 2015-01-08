//
//  CreatePlayerViewController.h
//  Task1
//
//  Created by Roman on 1/3/15.
//  Copyright (c) 2015 Rechich Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CreatePlayerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *playerTeamField;
@property (weak, nonatomic) IBOutlet UITextField *numberInTeamField;
@property (weak, nonatomic) IBOutlet UITextField *goalsField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
