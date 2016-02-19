//
//  EOCPerson.m
//  MAMapTest
//
//  Created by msp on 1/13/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import "EOCPerson.h"

@interface EOCPerson()
{
    NSMutableSet * _friends;
}
@end

@implementation EOCPerson
@synthesize name = _name;

-(id)initWithName:(NSString *)name andAddress:(NSString*)address
{
    if(self = [super init])
    {
        _name = name ;
        _address = [address copy];
        _friends = [NSMutableSet new];
    }
    return self;
}

-(void)addFriend:(EOCPerson*)person
{
    [_friends addObject:person];
}

-(void)removeFriend:(EOCPerson *)person
{
    [_friends removeObject:person];
}

-(id)copyWithZone:(NSZone *)zone
{
    EOCPerson * person = [[[self class] allocWithZone:zone]initWithName:_name andAddress:_address];
  //  person->_friends = [_friends mutableCopy];
    person->_friends = [[NSMutableSet alloc] initWithSet:_friends copyItems:YES];
    
    return person;
}

-(NSString*)description
{
    NSString * des = [NSString stringWithFormat:@"name:%@ ,address:%@",_name,_address];
    for (EOCPerson * person in _friends) {
        NSString * friend = [NSString stringWithFormat:@"name:%@ ,address:%@",person.name,person.address];
        des = [des stringByAppendingString:@"\nfriend-->"];
        des = [des stringByAppendingString:friend];
    }
    return des;
}
@end
