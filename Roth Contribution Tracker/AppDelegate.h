//
//  AppDelegate.h
//  Roth Contribution Tracker
//
//  Created by ItalianPride15 on 3/9/13.
//  Copyright (c) 2013 Nathan Pantaleo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSTextField *amountField;

@property (weak) IBOutlet NSDatePicker *dateAdded;

@property (weak) IBOutlet NSTextField *totalLeftToContributeField;

@end
