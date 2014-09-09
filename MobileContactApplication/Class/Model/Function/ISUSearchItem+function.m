//
//  ISUSearchItem+function.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUSearchItem+function.h"
#import "NSString+ISUAdditions.h"

@implementation ISUSearchItem (function)

+ (id)newSearchItemWithKey:(NSString *)key
                  property:(NSString *)property
                   context:(NSManagedObjectContext *)context
{
    if (key == nil) {
        return nil;
    }
    
    ISUSearchItem *searchItem = [[ISUSearchItem alloc] initWithContext:context];
    NSString *value = [key normalizedSearchString];
    searchItem.key = key;
    searchItem.value = value;
    searchItem.property = property;
    
    return searchItem;
}



@end
