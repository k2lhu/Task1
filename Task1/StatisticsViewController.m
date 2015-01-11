//
//  StatisticsViewController.m
//  Task1
//
//  Created by Roman on 1/8/15.
//  Copyright (c) 2015 Rechich Roman. All rights reserved.
//

#import "StatisticsViewController.h"

@interface StatisticsViewController ()

@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAxis];
    [self setTitle];
    [self setNavigationBar];

    [self initPlot];
}


- (void)initPlot{
    self.hostView.allowPinchScaling = NO;
    [self configureGraph];
    [self configurePlot];
    [self configureAxes];
}

- (void)configureGraph{
    //Create Graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    graph.plotAreaFrame.masksToBorder = NO;
    self.hostView.hostedGraph = graph;
    
    //Configure the graph
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    graph.paddingTop = 0.0f;
    graph.paddingRight = 0.0f;
    graph.paddingBottom = 0.0f;
    graph.paddingLeft = 0.0f;
    
    graph.plotAreaFrame.paddingTop = 15.0f;
    graph.plotAreaFrame.paddingRight = 10.0f;
    graph.plotAreaFrame.paddingBottom = 60.0f;
    graph.plotAreaFrame.paddingLeft = 45.0f;
    
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 13.0f;
    
    NSString *title = self.teamName;
    
    graph.title = title;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    
    CGFloat xMin = 0.0f;
    CGFloat yMin = 0.0f;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(xMin) length:CPTDecimalFromCGFloat([self.names count])];
    
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(yMin) length:CPTDecimalFromCGFloat([self maxGoals])];
}

- (void)configurePlot{
    self.teamBarPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor grayColor] horizontalBars:NO];
    self.teamBarPlot.identifier = @"Team";
    
    CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];
    lineStyle.lineColor = [CPTColor whiteColor];
    lineStyle.lineWidth = 1.0f;
    
    
    //Add plots to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    self.teamBarPlot.delegate = self;
    self.teamBarPlot.dataSource = self;
    self.teamBarPlot.lineStyle = lineStyle;
    self.teamBarPlot.fill = [CPTFill fillWithColor:[[CPTColor redColor] colorWithAlphaComponent:0.6f]];
    self.teamBarPlot.barCornerRadius = 2.2f;
    self.teamBarPlot.barWidth = CPTDecimalFromFloat(0.50f);
    
    [graph addPlot:self.teamBarPlot toPlotSpace:graph.defaultPlotSpace];
}

- (void)configureAxes{
    CPTMutableTextStyle *axisTitleStyle = [[CPTMutableTextStyle alloc] init];
    axisTitleStyle.color = [CPTColor blackColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [[CPTMutableLineStyle alloc] init];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [[CPTColor blackColor] colorWithAlphaComponent:0.8f];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    
    
    NSMutableArray *labels = [[NSMutableArray alloc] init];
    NSArray *playersName = self.names;
    
    for (int i = 0; i < [playersName count]; ++i) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[playersName objectAtIndex:i] textStyle:axisTitleStyle];
        label.rotation = M_PI_4;
        label.tickLocation = CPTDecimalFromInt(i);
        label.alignment = CPTAlignmentTop;
        [labels addObject:label];
    }
    
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.xAxis.axisLabels = [NSSet setWithArray:labels];
    axisSet.xAxis.labelOffset = 0.0f;
    axisSet.xAxis.titleTextStyle = axisTitleStyle;
    axisSet.xAxis.axisLineStyle = axisLineStyle;
    
    
    axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    axisSet.yAxis.titleTextStyle = axisTitleStyle;
    axisSet.yAxis.axisLineStyle = axisLineStyle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTitle {
    NSString *title = [NSString stringWithFormat:@"Statistics"];
    [self setTitle:title];
}

- (void)setNavigationBar {
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:self.title];
    [navigationItem setHidesBackButton:YES];
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64.0f)];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    
    [self.view addSubview:navigationBar];
    [navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:nil action:@selector(goBackToMainView)] animated:YES];
}

- (void)goBackToMainView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.names count];
}

-(NSArray *)numbersForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndexRange:(NSRange)indexRange{
    NSArray *nums = nil;
    
    switch ( fieldEnum ) {
        case CPTBarPlotFieldBarLocation:
            nums = [NSMutableArray arrayWithCapacity:indexRange.length];
            for ( NSUInteger i = indexRange.location; i < NSMaxRange(indexRange); i++ ) {
                [(NSMutableArray *)nums addObject : @(i)];
            }
            break;
        case CPTBarPlotFieldBarTip:
            nums = [self.goals objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:indexRange]];
            break;
        default:
            break;
    }
    return nums;
}

- (void)getAxis {
    NSEntityDescription *teamEntity = [NSEntityDescription entityForName:@"Player"
                                                  inManagedObjectContext:self.context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:teamEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(team.name = %@)", self.teamName];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *objects = [self.context executeFetchRequest:request error:&error];
    
    self.goals = [objects valueForKey:@"goals"];
    for (NSString *str in self.goals) {
        NSLog(@"%@", str);
    }
    self.names = [objects valueForKey:@"name"];
    for (NSString *str in self.names) {
        NSLog(@"%@", str);
    }
}

- (NSUInteger)maxGoals {
    NSNumber *max = 0;
    for (NSNumber *value in self.goals) {
        if (max < value) {
            max = value;
        }
    }
    return [max intValue];
}

@end
