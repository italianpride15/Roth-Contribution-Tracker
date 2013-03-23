//
//  AppDelegate.m
//  Roth Contribution Tracker
//
//  Created by ItalianPride15 on 3/9/13.
//  Copyright (c) 2013 Nathan Pantaleo. All rights reserved.
//

#import "AppDelegate.h"
#import "RothData.h"
#import "Database.h"

@implementation AppDelegate

double totalFromDB;
NSString *dateString;
RothData *rData;
Database *rDB = NULL;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    rDB = [[Database alloc] init];
    rData = [[RothData alloc] init];
    [rDB createEditableCopyOfDatabaseIfNeeded];
    [self.dateAdded setDateValue:[NSDate date]];
    totalFromDB = [rData getAmountFromDB];
    [self.totalLeftToContributeField setStringValue:[NSString stringWithFormat:@"%f", totalFromDB]];
}

- (IBAction)madeButton:(NSButton *)sender {

    dateString = [self getFormattedDate];
    //optional: validating the text in the UITextField delegate method
    double amount = [[self.amountField stringValue] doubleValue];
    //NSLog(@"%f", amount);
    totalFromDB += amount;
    //NSLog(@"%f", totalFromDB);
    [rData saveAmountToDB:totalFromDB transAmount:amount transType:@"Made" date:dateString];
    
    [self.totalLeftToContributeField setStringValue:[NSString stringWithFormat:@"%f", totalFromDB]];

}

- (IBAction)contributedButton:(NSButton *)sender {
    
    dateString = [self getFormattedDate];
    //optional: validating the text in the UITextField delegate method
    double amount = [[self.amountField stringValue] doubleValue];
    //NSLog(@"%f", amount);
    totalFromDB -= amount;
    //NSLog(@"%f", totalFromDB);
    [rData saveAmountToDB:totalFromDB transAmount:amount transType:@"Contributed" date:dateString];
    [self.totalLeftToContributeField setStringValue:[NSString stringWithFormat:@"%f", totalFromDB]];

}

- (NSString *)getFormattedDate {
    NSDate *selectedDate = [self.dateAdded dateValue];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:selectedDate];
    return dateString;
}
@end
