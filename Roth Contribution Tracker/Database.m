//
//  Database.m
//  Roth Contribution Tracker
//
//  Created by ItalianPride15 on 3/14/13.
//  Copyright (c) 2013 Nathan Pantaleo. All rights reserved.
//

#import "Database.h"
#import "sqlite3.h"

@interface Database()

- (void)initializeDatabaseForUse;

@end

@implementation Database

const char *sqlCreateRothDataTable = "CREATE TABLE IF NOT EXISTS \"transactions\" (\"Index\" INTEGER PRIMARY KEY  NOT NULL , \"Balance\" DOUBLE, \"Amount\" DOUBLE, \"Type\" TEXT, \"Date\" TEXT);";

sqlite3 *rothDB = NULL;

- (BOOL) createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"rothdata.sqlite3"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) {
        if (sqlite3_open([writableDBPath UTF8String], &rothDB) == SQLITE_OK) {
            
            [self initializeDatabaseForUse];
            sqlite3_close(rothDB);
            return YES;
        }
        else {
            NSLog(@"An error opening the database has occured.");
        }
    }
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"rothdata.sqlite3"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    else {
        if (sqlite3_open([writableDBPath UTF8String], &rothDB) == SQLITE_OK) {
            
            [self initializeDatabaseForUse];
            sqlite3_close(rothDB);
            return YES;
        }
        else {
            NSLog(@"An error opening the database has occured.");
        }
    }
    return NO;
}

- (void)initializeDatabaseForUse {
    
    sqlite3_stmt *sqlTableStatement;
    if (sqlite3_prepare(rothDB, sqlCreateRothDataTable, -1, &sqlTableStatement, NULL) != SQLITE_OK)
    {
        NSLog(@"Problem with favoritefoods statement");
    }
    sqlite3_step(sqlTableStatement);
    sqlite3_finalize(sqlTableStatement);
}

@end
