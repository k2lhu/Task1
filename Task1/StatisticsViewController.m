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
    // Create barChart from theme
    CPTXYGraph *newGraph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme      = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [newGraph applyTheme:theme];
    CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;
    self.barChart = newGraph;
    
    hostingView.hostedGraph              = newGraph;
    newGraph.plotAreaFrame.masksToBorder = NO;
    
    newGraph.paddingLeft   = 70.0;
    newGraph.paddingTop    = 55.0;
    newGraph.paddingRight  = 20.0;
    newGraph.paddingBottom = 80.0;
    
    // Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)newGraph.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromDouble(300.0)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromDouble(16.0)];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)newGraph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.axisLineStyle               = nil;
    x.majorTickLineStyle          = nil;
    x.minorTickLineStyle          = nil;
    x.majorIntervalLength         = CPTDecimalFromDouble(5.0);
    x.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    x.title                       = @"X Axis";
    x.titleLocation               = CPTDecimalFromFloat(7.5f);
    x.titleOffset                 = 55.0;
    
    // Define some custom labels for the data elements
    x.labelRotation  = CPTFloat(M_PI_4);
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    NSArray *customTickLocations = @[@1, @5, @10, @15];
    NSArray *xAxisLabels         = @[@"Пидар A", @"Пидор B", @"Label C", @"Label D"];
    NSUInteger labelLocation     = 0;
    NSMutableSet *customLabels   = [NSMutableSet setWithCapacity:[xAxisLabels count]];
    for ( NSNumber *tickLocation in customTickLocations ) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:xAxisLabels[labelLocation++] textStyle:x.labelTextStyle];
        newLabel.tickLocation = [tickLocation decimalValue];
        newLabel.offset       = x.labelOffset + x.majorTickLength;
        newLabel.rotation     = CPTFloat(M_PI_4);
        [customLabels addObject:newLabel];
    }
    
    x.axisLabels = customLabels;
    
    CPTXYAxis *y = axisSet.yAxis;
    y.axisLineStyle               = nil;
    y.majorTickLineStyle          = nil;
    y.minorTickLineStyle          = nil;
    y.majorIntervalLength         = CPTDecimalFromDouble(50.0);
    y.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    y.title                       = @"Y Axis";
    y.titleOffset                 = 45.0;
    y.titleLocation               = CPTDecimalFromFloat(150.0f);
    
    // First bar plot
    CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor darkGrayColor] horizontalBars:NO];
    barPlot.baseValue  = CPTDecimalFromDouble(0.0);
    barPlot.dataSource = self;
    barPlot.barOffset  = CPTDecimalFromFloat(-0.25f);
    barPlot.identifier = @"Bar Plot 1";
    [newGraph addPlot:barPlot toPlotSpace:plotSpace];
    
    // Second bar plot
    barPlot                 = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
    barPlot.dataSource      = self;
    barPlot.baseValue       = CPTDecimalFromDouble(0.0);
    barPlot.barOffset       = CPTDecimalFromFloat(0.25f);
    barPlot.barCornerRadius = 2.0;
    barPlot.identifier      = @"Bar Plot 2";
    [newGraph addPlot:barPlot toPlotSpace:plotSpace];
    
#ifdef PERFORMANCE_TEST
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changePlotRange) userInfo:nil repeats:YES];
#endif
//    [self setTitle];
//    [self setNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTitle {
    NSString *title = [NSString stringWithFormat:@"%@ stats",self.teamName];
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

- (void)generateBarPlot {
    
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 16;
}

-(id)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num = nil;
    
    if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
        switch ( fieldEnum ) {
            case CPTBarPlotFieldBarLocation:
                num = @(index);
                break;
                
            case CPTBarPlotFieldBarTip:
                num = @( (index + 1) * (index + 1) );
                if ( [plot.identifier isEqual:@"Bar Plot 2"] ) {
                    num = @(num.integerValue - 10);
                }
                break;
        }
    }
    
    return num;
}

- (NSArray *)getYAxis {
    NSEntityDescription *teamEntity = [NSEntityDescription entityForName:@"Player"
                                                  inManagedObjectContext:self.context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:teamEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(team.name = %@)", self.teamName];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *objects = [self.context executeFetchRequest:request error:&error];
    
    NSMutableArray *xAxisLabels = [objects valueForKey:@"name"];
    
    for (NSString *string in xAxisLabels) {
        NSLog(@"%@", string);
    }
    
    return xAxisLabels;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
