//
//  Article+CoreDataProperties.h
//  Squashmag
//
//  Created by Abbin Varghese on 01/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Article.h"

NS_ASSUME_NONNULL_BEGIN

@interface Article (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *website;
@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) NSString *heading;
@property (nullable, nonatomic, retain) NSString *imageurl;
@property (nullable, nonatomic, retain) NSNumber *timestamp;
@property (nullable, nonatomic, retain) NSString *uID;

@end

NS_ASSUME_NONNULL_END
