//
//  CreatePlayerViewController.m
//  Task1
//
//  Created by Roman on 1/3/15.
//  Copyright (c) 2015 Rechich Roman. All rights reserved.
//

#import "CreatePlayerViewController.h"
#import "Player.h"
#import "Team.h"

@interface CreatePlayerViewController ()

@end

@implementation CreatePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.saveButton setEnabled:NO];
    [self.goalsField addTarget:self action:@selector(textFieldDidChange:)
              forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDidChange:(UITextField *)textField {
    if(textField == self.goalsField)
        self.saveButton.enabled = ([self.nameField.text length] &&
                                   [self.numberInTeamField.text length] &&
                                   [self.playerTeamField.text length] &&
                                   [self.goalsField.text length] > 0) ? YES : NO;
}

#pragma mark - Save player
- (IBAction)save:(id)sender {
    if ([self.nameField.text isEqualToString:@""] ||
        [self.playerTeamField.text isEqualToString:@""] ||
        [self.numberInTeamField.text isEqualToString:@""] ||
        [self.goalsField.text isEqualToString:@""]) {
        self.errorLabel.text = @"Fill all fields";
    } else {
        [self createPlayer];
    }
}

- (void)createPlayer {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    Player *player = [NSEntityDescription insertNewObjectForEntityForName:@"Player"
                                                   inManagedObjectContext:context];
    NSEntityDescription *teamEntity = [NSEntityDescription entityForName:@"Team"
                                                  inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:teamEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name = %@)", self.playerTeamField.text];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if ([objects count] == 0) {
        Team *team = [NSEntityDescription insertNewObjectForEntityForName:@"Team"
                                                   inManagedObjectContext:context];
        team.name = [self.playerTeamField.text capitalizedString];
        player.team = team;
    } else {
        player.team = [objects objectAtIndex:0];
    }
    
    player.name = self.nameField.text;
    player.number = @([self.numberInTeamField.text integerValue]);
    player.goals = @([self.goalsField.text integerValue]);
    
    [self saveContext:context];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}
@end
