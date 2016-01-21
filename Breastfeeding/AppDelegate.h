//
//  AppDelegate.h
//  Breastfeeding
//
//  Created by Samantha Cabral on 1/14/16.
//  Copyright © 2016 Samantha Cabral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Feeding.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(Feeding *) createFeeding;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

