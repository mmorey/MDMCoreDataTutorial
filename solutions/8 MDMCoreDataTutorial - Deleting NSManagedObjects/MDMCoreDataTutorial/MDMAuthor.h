//
//  MDMAuthor.h
//  MDMCoreDataTutorial
//
//  Created by Matthew Morey on 3/4/14.
//  Copyright (c) 2014 Matthew Morey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MDMBook;

@interface MDMAuthor : NSManagedObject

@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) NSSet *books;
@end

@interface MDMAuthor (CoreDataGeneratedAccessors)

- (void)addBooksObject:(MDMBook *)value;
- (void)removeBooksObject:(MDMBook *)value;
- (void)addBooks:(NSSet *)values;
- (void)removeBooks:(NSSet *)values;

@end
