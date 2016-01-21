//
//  Feeding+CoreDataProperties.h
//  Breastfeeding
//
//  Created by Samantha Cabral on 1/15/16.
//  Copyright © 2016 Samantha Cabral. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Feeding.h"

NS_ASSUME_NONNULL_BEGIN

@interface Feeding (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *left;
@property (nullable, nonatomic, retain) NSNumber *right;
@property (nullable, nonatomic, retain) NSNumber *total;
@property (nullable, nonatomic, retain) NSDate *timeSince;

@end

NS_ASSUME_NONNULL_END
