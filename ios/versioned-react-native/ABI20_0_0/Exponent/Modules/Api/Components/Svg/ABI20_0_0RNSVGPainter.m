/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI20_0_0RNSVGPainter.h"
#import "ABI20_0_0RNSVGPercentageConverter.h"

@implementation ABI20_0_0RNSVGPainter
{
    NSArray<NSString *> *_points;
    NSArray<NSNumber *> *_colors;
    ABI20_0_0RNSVGBrushType _type;
    BOOL _useObjectBoundingBox;
    CGAffineTransform _transform;
    CGRect _userSpaceBoundingBox;
}

- (instancetype)initWithPointsArray:(NSArray<NSString *> *)pointsArray
{
    if ((self = [super init])) {
        _points = pointsArray;
    }
    return self;
}

ABI20_0_0RCT_NOT_IMPLEMENTED(- (instancetype)init)

- (void)setUnits:(ABI20_0_0RNSVGUnits)unit
{
    _useObjectBoundingBox = unit == kRNSVGUnitsObjectBoundingBox;
}

- (void)setUserSpaceBoundingBox:(CGRect)userSpaceBoundingBox
{
    _userSpaceBoundingBox = userSpaceBoundingBox;
}

- (void)setTransform:(CGAffineTransform)transform
{
    _transform = transform;
}

- (void)setLinearGradientColors:(NSArray<NSNumber *> *)colors
{
    if (_type != kRNSVGUndefinedType) {
        // todo: throw error
        return;
    }
    
    _type = kRNSVGLinearGradient;
    _colors = colors;
}

- (void)setRadialGradientColors:(NSArray<NSNumber *> *)colors
{
    if (_type != kRNSVGUndefinedType) {
        // todo: throw error
        return;
    }
    
    _type = kRNSVGRadialGradient;
    _colors = colors;
}

- (void)paint:(CGContextRef)context
{
    if (_type == kRNSVGLinearGradient) {
        [self paintLinearGradient:context];
    } else if (_type == kRNSVGRadialGradient) {
        [self paintRidialGradient:context];
    } else if (_type == kRNSVGPattern) {
        // todo:
    }
}

- (CGRect)getPaintRect:(CGContextRef)context
{
    CGRect rect = _useObjectBoundingBox ? CGContextGetClipBoundingBox(context) : _userSpaceBoundingBox;
    float height = CGRectGetHeight(rect);
    float width = CGRectGetWidth(rect);
    float x = 0.0;
    float y = 0.0;
    
    if (_useObjectBoundingBox) {
        x = CGRectGetMinX(rect);
        y = CGRectGetMinY(rect);
    }
    
    return CGRectMake(x, y, width, height);
}

- (void)paintLinearGradient:(CGContextRef)context
{
    
    CGGradientRef gradient = CGGradientRetain([ABI20_0_0RCTConvert ABI20_0_0RNSVGCGGradient:_colors offset:0]);
    CGGradientDrawingOptions extendOptions = kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation;
    
    CGRect rect = [self getPaintRect:context];
    float height = CGRectGetHeight(rect);
    float width = CGRectGetWidth(rect);
    float offsetX = CGRectGetMinX(rect);
    float offsetY = CGRectGetMinY(rect);
    
    CGFloat x1 = [ABI20_0_0RNSVGPercentageConverter stringToFloat:(NSString *)[_points objectAtIndex:0]
                                                relative:width
                                                  offset:offsetX];
    CGFloat y1 = [ABI20_0_0RNSVGPercentageConverter stringToFloat:(NSString *)[_points objectAtIndex:1]
                                                relative:height
                                                  offset:offsetY];
    CGFloat x2 = [ABI20_0_0RNSVGPercentageConverter stringToFloat:(NSString *)[_points objectAtIndex:2]
                                                relative:width
                                                  offset:offsetX];
    CGFloat y2 = [ABI20_0_0RNSVGPercentageConverter stringToFloat:(NSString *)[_points objectAtIndex:3]
                                                relative:height
                                                  offset:offsetY];
    
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(x1, y1), CGPointMake(x2, y2), extendOptions);
    CGGradientRelease(gradient);
}

- (void)paintRidialGradient:(CGContextRef)context
{
    CGGradientRef gradient = CGGradientRetain([ABI20_0_0RCTConvert ABI20_0_0RNSVGCGGradient:_colors offset:0]);
    CGGradientDrawingOptions extendOptions = kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation;
    
    CGRect rect = [self getPaintRect:context];
    float height = CGRectGetHeight(rect);
    float width = CGRectGetWidth(rect);
    float offsetX = CGRectGetMinX(rect);
    float offsetY = CGRectGetMinY(rect);
    
    CGFloat rx = [ABI20_0_0RNSVGPercentageConverter stringToFloat:(NSString *)[_points objectAtIndex:2]
                                                relative:width
                                                  offset:0];
    CGFloat ry = [ABI20_0_0RNSVGPercentageConverter stringToFloat:(NSString *)[_points objectAtIndex:3]
                                                relative:height
                                                  offset:0];
    CGFloat fx = [ABI20_0_0RNSVGPercentageConverter stringToFloat:(NSString *)[_points objectAtIndex:0]
                                                relative:width
                                                  offset:offsetX];
    CGFloat fy = [ABI20_0_0RNSVGPercentageConverter stringToFloat:(NSString *)[_points objectAtIndex:1]
                                                relative:height
                                                  offset:offsetY] / (ry / rx);
    CGFloat cx = [ABI20_0_0RNSVGPercentageConverter stringToFloat:(NSString *)[_points objectAtIndex:4]
                                                relative:width
                                                  offset:offsetX];
    CGFloat cy = [ABI20_0_0RNSVGPercentageConverter stringToFloat:(NSString *)[_points objectAtIndex:5]
                                                relative:height
                                                  offset:offsetY] / (ry / rx);
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1, ry / rx);
    CGContextConcatCTM(context, transform);
    
    CGContextDrawRadialGradient(context, gradient, CGPointMake(fx, fy), 0, CGPointMake(cx, cy), rx, extendOptions);
    CGGradientRelease(gradient);
}

@end

