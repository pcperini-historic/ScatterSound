//
//  ITTimeIntervalFormatter.m
//  ScatterSound
//
//  Created by Patrick Perini on 3/9/12.
//  Copyright (c) 2012 Inspyre Technologies. All rights reserved.
//

#import "ITTimeIntervalFormatter.h"

@implementation ITTimeIntervalFormatter

- (BOOL)isPartialStringValid:(NSString *__autoreleasing *)partialStringPtr proposedSelectedRange:(NSRangePointer)proposedSelRangePtr originalString:(NSString *)origString originalSelectedRange:(NSRange)origSelRange errorDescription:(NSString *__autoreleasing *)error
{
    return ([*partialStringPtr integerValue] >= 0 && [*partialStringPtr integerValue] <= 99);
}

- (NSString *)stringFromNumber:(NSNumber *)number
{
    return [NSString stringWithFormat: @"%02d", [number integerValue]];
}

- (NSString *)stringForObjectValue:(id)obj
{
    return [NSString stringWithFormat: @"%02d", [obj integerValue]];
}

@end
