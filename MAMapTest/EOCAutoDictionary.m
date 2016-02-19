//
//  EOCAutoDictionary.m
//  MAMapTest
//
//  Created by msp on 1/12/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import "EOCAutoDictionary.h"

@interface EOCAutoDictionary()
@property (nonatomic,strong)NSMutableDictionary * backingStore;

@end

@implementation EOCAutoDictionary

@dynamic string,number,opaqueObject,date;

-(id)init{
    if(self = [super init])
    {
        _backingStore = [NSMutableDictionary new];
    }
 //   [self mustOverrideMethod];
    return self;
}

-(void)mustOverrideMethod
{
    NSString * reason = [NSString stringWithFormat:@"%@ must be overriden",NSStringFromSelector(_cmd)];
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
    
 //   NSError
}

id autoDictionaryGetter(id self, SEL _cmd) {
    // Get the backing store from the object
    EOCAutoDictionary *typedSelf = (EOCAutoDictionary*)self;
    NSMutableDictionary *backingStore = typedSelf.backingStore;
    
    // The key is simply the selector name
    NSString *key = NSStringFromSelector(_cmd);
    
    // Return the value
    return [backingStore objectForKey:key];
}

void autoDictionarySetter(id self, SEL _cmd, id value) {
    // Get the backing store from the object
    EOCAutoDictionary *typedSelf = (EOCAutoDictionary*)self;
    NSMutableDictionary *backingStore = typedSelf.backingStore;
    
    /** The selector will be for example, "setOpaqueObject:".
     *  We need to remove the "set", ":" and lowercase the first
     *  letter of the remainder.
     */
    NSString *selectorString = NSStringFromSelector(_cmd);
    NSMutableString *key = [selectorString mutableCopy];
    
    // Remove the ':' at the end
    [key deleteCharactersInRange:NSMakeRange(key.length - 1, 1)];
    
    // Remove the 'set' prefix
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    
    // Lowercase the first character
    NSString *lowercaseFirstChar =
    [[key substringToIndex:1] lowercaseString];
    [key replaceCharactersInRange:NSMakeRange(0, 1)
                       withString:lowercaseFirstChar];
    
    if (value) {
        [backingStore setObject:value forKey:key];
    } else {
        [backingStore removeObjectForKey:key];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return nil;
}

+(BOOL)resolveInstanceMethod:(SEL)sel
{
    NSString * selectorString = NSStringFromSelector(sel);
    if([selectorString hasPrefix:@"set"])
    {
      //  autoDictionarySetter
        class_addMethod(self, sel, (IMP)autoDictionarySetter, "v@:@");
    }
    else{
        class_addMethod(self, sel, (IMP)autoDictionaryGetter, "@@:");
    }
    return YES;
}

@end
