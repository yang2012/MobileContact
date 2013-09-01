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
    
    NSString *entityName = NSStringFromClass(self);
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"recordId=%@", recordId];
    fetchRequest.fetchLimit = 1;
    id object = [[context executeFetchRequest:fetchRequest error:NULL] lastObject];
    if (object == nil) {
        object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
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

    NSArray *phoneNumbers = [info valueForKey:kISUPersonPhoneNumbers];
    for (NSArray *phone in phoneNumbers) {
        if ([phone count] != 2) {
            NSString *logMessage = [NSString stringWithFormat:@"Invalid phone values: %@", phone];
            ISULog(logMessage, ISULogPriorityHigh);
            return;
        }

//        NSString *phoneLabel = [phone objectAtIndex:0];
        NSString *phoneNumber = [phone objectAtIndex:1];
        
        self.phoneNumber = phoneNumber;
    }
}

@end
