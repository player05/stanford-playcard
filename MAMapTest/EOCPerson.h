//
//  EOCPerson.h
//  MAMapTest
//
//  Created by msp on 1/13/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EOCPerson : NSObject<NSCopying>

@property (nonatomic,retain) NSString * name;
@property (nonatomic,copy) NSString * address;

-(id)initWithName:(NSString *)name andAddress:(NSString*)address;

-(void)addFriend:(EOCPerson*)person;
-(void)removeFriend:(EOCPerson *)person;



@end

@interface EOCPerson(play)

//play
-(void)goToTheCinema;
-(void)goToSportsGame;

@end
