//
//  RothData.m
//  Roth Contribution Tracker
//
//  Created by ItalianPride15 on 3/11/13.
//  Copyright (c) 2013 Nathan Pantaleo. All rights reserved.
//

#import "RothData.h"
#import "sqlite3.h"

/*
@interface RothData()

@end
 */

@implementation RothData

sqlite3 *rothDB;
const char *sqlInsertStatement = "INSERT INTO transactions (Balance, Amount, Type, Date) VALUES (?, ?, ?, ?)";
const char *sqlNumOfRowsStatement = "SELECT COUNT(Balance) FROM transactions";



- (double)getAmountFromDB {
    
    double returnValue = 0.0;
    int numOfRows;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"rothdata.sqlite3"];
    if (sqlite3_open([writableDBPath UTF8String], &rothDB) == SQLITE_OK) {
        
        sqlite3_stmt *compiledSelectStatement;
        
        @try {
            sqlite3_prepare(rothDB, sqlNumOfRowsStatement, -1, &compiledSelectStatement, NULL);
            while (sqlite3_step(compiledSelectStatement) == SQLITE_ROW) {
                
                numOfRows = sqlite3_column_int(compiledSelectStatement, 0);
            }
            sqlite3_finalize(compiledSelectStatement);
        }
        @catch (NSException *e) {
            NSLog(@"Exception: %@", e);
        }

        NSString *tempString = @"SELECT Balance FROM transactions WHERE [Index] = ";
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%d", numOfRows]];
        const char *sqlSelectStatement = [tempString cStringUsingEncoding:NSASCIIStringEncoding];
        
        @try {
            sqlite3_prepare(rothDB, sqlSelectStatement, -1, &compiledSelectStatement, NULL);
            while (sqlite3_step(compiledSelectStatement) == SQLITE_ROW) {
                
                returnValue = sqlite3_column_double(compiledSelectStatement, 0);
            }
            sqlite3_finalize(compiledSelectStatement);
        }
        @catch (NSException *e) {
            NSLog(@"Exception: %@", e);
        }
        sqlite3_close(rothDB);
    }
    else {
        //if we received an error, we log it and let the program continue.
        NSLog(@"An error opening the database has occured.");
    }
    return returnValue;
}

- (void)saveAmountToDB:(double)balance transAmount:(double)transAmount transType:(NSString *)transType date:(NSString *)date {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"rothdata.sqlite3"];
    if (sqlite3_open([writableDBPath UTF8String], &rothDB) == SQLITE_OK) {
        
        sqlite3_stmt *compiledInsertStatement;

        @try {
            if(sqlite3_prepare(rothDB, sqlInsertStatement, -1, &compiledInsertStatement, NULL) == SQLITE_OK)    {
                sqlite3_bind_double(compiledInsertStatement, 1, balance);
                sqlite3_bind_double(compiledInsertStatement, 2, transAmount);
                sqlite3_bind_text(compiledInsertStatement, 3, [transType UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledInsertStatement, 4, [date UTF8String], -1, SQLITE_TRANSIENT);
            }
            if(sqlite3_step(compiledInsertStatement) != SQLITE_DONE) {
                NSLog(@"Save Error: %s", sqlite3_errmsg(rothDB));
            }
            sqlite3_finalize(compiledInsertStatement);
        }
        @catch (NSException *e) {
            NSLog(@"Exception: %@", e);
        }
        sqlite3_close(rothDB);
    }
    else {
        //if we received an error, we log it and let the program continue.
        NSLog(@"An error opening the database has occured.");
    }
}

@end
