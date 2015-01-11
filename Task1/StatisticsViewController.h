//
//  StatisticsViewController.h
//  Task1
//
//  Created by Roman on 1/8/15.
//  Copyright (c) 2015 Rechich Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CorePlot-CocoaTouch.h>

@interface StatisticsViewController : UIViewController <CPTBarPlotDataSource>

@property (weak, nonatomic) IBOutlet CPTGraphHostingView *hostView;

@property NSString *teamName;
@property (nonatomic, retain) NSMutableArray *names;
@property (nonatomic, retain) NSMutableArray *goals;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) CPTXYGraph *barChart;
@property (strong, nonatomic) CPTBarPlot *teamBarPlot;

@end
