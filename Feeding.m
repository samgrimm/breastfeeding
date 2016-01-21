//
//  Feeding.m
//  Breastfeeding
//
//  Created by Samantha Cabral on 1/15/16.
//  Copyright © 2016 Samantha Cabral. All rights reserved.
//

#import "Feeding.h"

@implementation Feeding

- (NSString *) description {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm 'on' dd-MM"];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:self.timeSince];
    

    return [NSString stringWithFormat:@"L: %@s - R: %@s - Total: %@s - %@", self.left, self.right, self.total, formattedDateString];
}

@end
