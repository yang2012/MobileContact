//
//  ISUSearchItem+function.h
//  MobileContactApplication
//
//  Created by macbook on 13-9-27.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUSearchItem.h"

@interface ISUSearchItem (function)

+ (id)newSearchItemWithKey:(NSString *)key
                  property:(NSString *)property
                   context:(NSManagedObjectContext *)context;

@end
