//
//  NSManagedObject+MDMAdditions.h
//  MDMCoreDataTutorial
//
//  Created by Matthew Morey on 3/4/14.
//  Copyright (c) 2014 Matthew Morey. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (MDMAdditions)

+ (NSString *)MDMCoreDataAdditionsEntityName;
+ (instancetype)MDMCoreDataAdditionsInsertNewObjectIntoContext:(NSManagedObjectContext *)context;

@end
