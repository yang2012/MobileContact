//
//  ISUPerson+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-8-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUPerson+function.h"
#import "ISUAddressBookUtility.h"

@implementation ISUPerson (function)

+ (ISUPerson *)findOrCreatePersonWithRecordId:(NSNumber *)recordId
                                    inContext:(NSManagedObjectContext *)context
{
    if (recordId == nil || recordId == 0) {
        NSLog(@"Invalid recrodId: %@", recordId);
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[ISUPerson entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"recordId=%@", recordId];
    fetchRequest.fetchLimit = 1;
    id object = [[context executeFetchRequest:fetchRequest error:NULL] lastObject];
    if (object == nil) {
        object = [NSEntityDescription insertNewObjectForEntityForName:[ISUPerson entityName] inManagedObjectContext:context];
        ((ISUPerson *)object).recordId = recordId;
    }
    return object;
}

- (void)updateWithInfo:(NSDictionary *)info
{
    NSString *fullName = [info valueForKey:kISUPersonFullName];
    if (fullName.length > 0) {
        self.fullName = fullName;
    }

//    NSDictionary *phoneNumbers = [info valueForKey:kISUPersonPhoneNumbers];
//    NSString *phoneNumber = [phoneNumbers objectForKey:kISUPersonPhoneIPhoneLabel];
//    self.phoneNumber = phoneNumber;
}

+ (NSArray *)defaultSortDescriptors
{
    return [NSArray arrayWithObjects:
            [NSSortDescriptor sortDescriptorWithKey:@"fullName" ascending:NO], nil];
}

@end
