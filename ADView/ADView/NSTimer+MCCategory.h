//
//  NSTimer+Addition.h
//  project
//
//  Created by zhaoying on 14-1-24.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (MCCategory)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
- (void)stopTimer;
@end
