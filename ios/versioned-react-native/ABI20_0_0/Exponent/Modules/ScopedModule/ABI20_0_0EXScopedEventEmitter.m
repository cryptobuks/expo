// Copyright 2015-present 650 Industries. All rights reserved.

#import "ABI20_0_0EXScopedEventEmitter.h"

@implementation ABI20_0_0EXScopedEventEmitter

+ (NSString *)moduleName
{
  NSAssert(NO, @"ABI20_0_0EXScopedEventEmitter is abstract, you should only export subclasses to the bridge.");
  return @"ExponentScopedEventEmitter";
}

+ (NSString *)getExperienceIdFromEventEmitter:(id)eventEmitter
{
  if (eventEmitter) {
    return ((ABI20_0_0EXScopedEventEmitter *)eventEmitter).experienceId;
  }
  return nil;
}

- (instancetype)initWithExperienceId:(NSString *)experienceId kernelServiceDelegate:(id)kernelServiceInstance params:(NSDictionary *)params
{
  if (self = [super init]) {
    _experienceId = experienceId;
  }
  return self;
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[];
}

@end
