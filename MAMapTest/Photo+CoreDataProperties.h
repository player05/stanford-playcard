//
//  Photo+CoreDataProperties.h
//  
//
//  Created by msp on 1/22/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Photo.h"

NS_ASSUME_NONNULL_BEGIN

@interface Photo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *subtitle;
@property (nonatomic) NSTimeInterval thumnailDate;
@property (nullable, nonatomic, retain) NSString *pictureUrl;
@property (nullable, nonatomic, retain) NSData *picture;
@property (nullable, nonatomic, retain) NSManagedObject *whotake;

@end

NS_ASSUME_NONNULL_END
