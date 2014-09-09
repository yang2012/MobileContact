//
//  ISUAutocompleteManager.h
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-8.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "HTAutocompleteTextField.h"

typedef enum {
    ISUAutocompleteTypeEmail // Default
} ISUAutocompleteType;

@interface ISUAutocompleteManager : NSObject <HTAutocompleteDataSource>

+ (ISUAutocompleteManager *)sharedManager;

@end