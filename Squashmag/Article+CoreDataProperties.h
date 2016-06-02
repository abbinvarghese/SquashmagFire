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

@property (nullable, nonatomic, retain) NSString *articleWebsite;
@property (nullable, nonatomic, retain) NSString *articleAuthor;
@property (nullable, nonatomic, retain) NSString *articleHeading;
@property (nullable, nonatomic, retain) NSString *articleImageUrl;
@property (nullable, nonatomic, retain) NSNumber *articleTimestamp;
@property (nullable, nonatomic, retain) NSString *articleuUID;

@end

NS_ASSUME_NONNULL_END
