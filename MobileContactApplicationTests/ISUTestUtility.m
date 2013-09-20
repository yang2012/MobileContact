//
//  ISUUtility.m
//  MobileContactApplication
//
//  Created by macbook on 13-9-20.
//  Copyright (c) 2013年 Nanjing University. All rights reserved.
//

#import "ISUTestUtility.h"
#import "ISUEmail.h"
#import "ISUUrl.h"
#import "ISUPhone.h"
#import "ISURelatedName.h"
#import "ISUAddress+function.h"
#import "ISUDate.h"
#import "ISUSocialProfile+function.h"

@implementation ISUTestUtility

+ (ISUContact *)fakeContactWithContext:(NSManagedObjectContext *)context
{
    ISUContact *contact = [[ISUContact alloc] initWithContext:context];
    contact.firstName = @"Hello";
    contact.lastName = @"World";
    contact.middleName = @"Big";
    contact.firstNamePhonetic = @"hello";
    contact.lastNamePhonetic = @"world";
    contact.middleNamePhonetic = @"big";
    contact.nickname = @"jiege";
    contact.note = @"I'm jiege";
    contact.jobTitle = @"Engineer";
    contact.department = @"Software Engineering";
    contact.organization = @"Nanjing University";
    contact.birthday = [NSDate date];
    contact.originalImageKey = @"jiage/1-jiege-originalimage";
    contact.thumbnailKey = @"jiege/1-jiege-thumbnail";
    contact.prefix = @"Mr.";
    contact.suffix = @"lala";
    contact.frequence = 13;
    
    ISUEmail *email1 = [[ISUEmail alloc] initWithContext:context];
    email1.label = @"email1";
    email1.value = @"yyj@helloworld.com";
    ISUEmail *email2 = [[ISUEmail alloc] initWithContext:context];
    email2.label = @"email2";
    email2.value = @"yyj2@helloworld.com";
    contact.emails = [NSSet setWithObjects:email1, email2, nil];
    
    ISUUrl *url =  [[ISUUrl alloc] initWithContext:context];
    url.label = @"url";
    url.value = @"192.168.1.1";
    contact.urls = [NSSet setWithObject:url];
    
    ISUPhone *phone = [[ISUPhone alloc] initWithContext:context];
    phone.label = @"home";
    phone.value = @"123123123";
    contact.phones = [NSSet setWithObject:phone];
    
    ISURelatedName *relatedPeople = [[ISURelatedName alloc] initWithContext:context];
    relatedPeople.label = @"Brother";
    relatedPeople.value = @"Jiege";
    contact.relatedNames = [NSSet setWithObject:relatedPeople];
    
    ISUDate *date = [[ISUDate alloc] initWithContext:context];
    date.label = @"University";
    date.value = [NSDate date];
    contact.dates = [NSSet setWithObject:date];
    
    ISUSocialProfile *socialProfile = [[ISUSocialProfile alloc] initWithContext:context];
    socialProfile.service = @"Weibo";
    socialProfile.username = @"Love fly";
    socialProfile.url = @"weibo/weibao";
    socialProfile.userIdentifier = @"http://weibo/weibao";
    contact.socialProfiles = [NSSet setWithObject:socialProfile];
    
    ISUAddress *address = [[ISUAddress alloc] initWithContext:context];
    address.label = @"Home";
    address.street = @"Silver River";
    address.state = @"CN";
    address.country = @"China";
    address.countryCode = @"+86";
    address.city = @"Zhanjiang";
    address.zip = @"unknown";
    contact.addresses = [NSSet setWithObject:address];
    
    return contact;
}

+ (ISUGroup *)fakeGroupWithContext:(NSManagedObjectContext *)context
{
    ISUGroup *group = [[ISUGroup alloc] initWithContext:context];
    group.name = @"College";
    
    return group;
}

+ (ISUContactSource *)fakeContactSourceWithContext:(NSManagedObjectContext *)context
{
    ISUContactSource *source = [[ISUContactSource alloc] initWithContext:context];
    source.name = @"default";
    
    return source;
}

@end