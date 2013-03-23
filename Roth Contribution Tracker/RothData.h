//
//  RothData.h
//  Roth Contribution Tracker
//
//  Created by ItalianPride15 on 3/11/13.
//  Copyright (c) 2013 Nathan Pantaleo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RothData : NSObject

- (double)getAmountFromDB;
- (void)saveAmountToDB:(double)balance transAmount:(double)transAmount transType:(NSString *)transType date:(NSString *)date;

@end
