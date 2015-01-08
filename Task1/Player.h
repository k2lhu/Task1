//
//  Player.h
//  Task1
//
//  Created by Roman on 1/5/15.
//  Copyright (c) 2015 Rechich Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Team;

@interface Player : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * goals;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) Team *team;

@end
