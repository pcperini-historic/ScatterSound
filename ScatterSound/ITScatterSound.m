//
//  ITScatterSound.m
//  ITScatterSoundTests
//
//  Created by Patrick Perini on 3/4/12.
//  Copyright (c) 2012 Inspyre Technologies. All rights reserved.
//

#import "ITScatterSound.h"

#pragma mark - Notifications
NSString *const ITScatterSoundDidStartNotification = @"ITScatterSoundDidStartNotification";
NSString *const ITScatterSoundDidPlayNotification  = @"ITScatterSoundDidPlayNotification";
NSString *const ITScatterSoundDidStopNotification  = @"ITScatterSoundDidStopNotification";

#pragma mark - Keys
NSString *const ITScatterSoundDidPlay = @"ITScatterSoundDidPlay";

#pragma mark - Private Variables
NSTimeInterval const ITInfiniteTimeInterval = -1;

#pragma mark - Public Implementation
@implementation ITScatterSound

@synthesize sound;
@synthesize longestPeriod;
@synthesize shortestPeriod;
@synthesize duration;

#pragma mark Initializers
- (id)initWithSound:(NSSound *)aSound
{
    return [self initWithSound: aSound
                        period: [aSound duration]
                      duration: ITInfiniteTimeInterval];
}

- (id)initWithSound:(NSSound *)aSound period:(NSTimeInterval)period
{
    return [self initWithSound: aSound
                        period: period
                      duration: ITInfiniteTimeInterval];
}

- (id)initWithSound:(NSSound *)aSound longestPeriod:(NSTimeInterval)longest shortestPeriod:(NSTimeInterval)shortest
{
    return [self initWithSound: aSound
                 longestPeriod: longest
                shortestPeriod: shortest
                      duration: ITInfiniteTimeInterval];
}

- (id)initWithSound:(NSSound *)aSound period:(NSTimeInterval)period duration:(NSTimeInterval)aDuration
{
    return [self initWithSound: aSound
                 longestPeriod: period
                shortestPeriod: period
                      duration: aDuration];
}

- (id)initWithSound:(NSSound *)aSound longestPeriod:(NSTimeInterval)longest shortestPeriod:(NSTimeInterval)shortest duration:(NSTimeInterval)aDuration
{
    self = [super init];
    
    if (self)
    {
        lastPlayTime   = [NSDate date];
        
        sound          = aSound;
        longestPeriod  = longest;
        shortestPeriod = shortest;
        duration       = aDuration;
    }
    
    return self;
}

#pragma mark Controllers
- (void)start
{
    endTime = (duration == ITInfiniteTimeInterval)? [NSDate distantFuture] : [NSDate dateWithTimeIntervalSinceNow: duration];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: ITScatterSoundDidStartNotification
                                                        object: self];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^()
    {
        NSDate *currentTime;
        do
        {
            int sleepPeriod = arc4random_uniform(longestPeriod - shortestPeriod) + shortestPeriod;
            sleep(sleepPeriod);
            
            currentTime = [NSDate date];
            dispatch_async(dispatch_get_main_queue(), ^()
            {
               BOOL soundDidPlay = [sound play];
               lastPlayTime = soundDidPlay? [NSDate date] : lastPlayTime;
               
               [[NSNotificationCenter defaultCenter] postNotificationName: ITScatterSoundDidPlayNotification
                                                                   object: self
                                                                 userInfo: [NSDictionary dictionaryWithObject: [NSNumber numberWithBool: soundDidPlay]
                                                                                                       forKey: ITScatterSoundDidPlay]];
            });
            
            sleep(ceil([sound duration]));
        } while ([currentTime isLessThan: endTime]);
    });
}

- (void)stop
{
    endTime = [NSDate distantPast];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: ITScatterSoundDidStopNotification
                                                        object: self];
}

@end
