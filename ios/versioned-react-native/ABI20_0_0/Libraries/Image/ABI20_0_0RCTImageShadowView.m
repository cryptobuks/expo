/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "ABI20_0_0RCTImageShadowView.h"

#import <ReactABI20_0_0/ABI20_0_0RCTLog.h>

@implementation ABI20_0_0RCTImageShadowView

- (void)insertReactABI20_0_0Subview:(ABI20_0_0RCTShadowView *)subview atIndex:(NSInteger)atIndex
{
  ABI20_0_0RCTLogWarn(@"Using <Image> with children is deprecated "
             "and will be an error in the near future. "
             "Please reconsider the layout or use <ImageBackground> instead.");

  [super insertReactABI20_0_0Subview:subview atIndex:atIndex];
}

@end
