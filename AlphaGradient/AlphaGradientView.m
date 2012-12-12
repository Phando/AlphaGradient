//
//  GradientView.m
//  AssetGrid
//
//  Created by Joe Andolina on 10/18/12.
//
//
#import <QuartzCore/QuartzCore.h>
#import "AlphaGradientView.h"

@implementation AlphaGradientView
{
    CGPoint startPoint;
    CGPoint endPoint;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = false;
        self.backgroundColor = [UIColor clearColor];
        self.color = [UIColor blackColor];
    }
    
    return self;
}

-(void) setColor:(UIColor *)value
{
    _color = value;
    [self createGradient];
}

-(void) setDirection:(GradientDirection)value
{
    _direction = value;
    [self createGradient];
}

-(void) calculateStartAndEndPoints
{
    switch (self.direction)
    {
        case GRADIENT_UP:
            startPoint  = CGPointMake( 0, self.frame.size.height);
            endPoint    = CGPointMake( 0, 0);
            break;
            
        case GRADIENT_DOWN:
            startPoint  = CGPointMake( 0, 0);
            endPoint    = CGPointMake( 0, self.frame.size.height);
            break;
            
        case GRADIENT_LEFT:
            startPoint  = CGPointMake( self.frame.size.width, 0);
            endPoint    = CGPointMake( 0, 0);
            break;
            
        case GRADIENT_RIGHT:
            startPoint  = CGPointMake( 0, 0);
            endPoint    = CGPointMake( self.frame.size.width, 0);
            break;
    }
   
}

-(void) createGradient
{
    CGFloat maskColors[] =
    {
        1.0f, 1.0f, 1.0f, 1.0f,
        0.0f, 0.0f, 0.0f, 1.0f,
    };
    
    // Set up the start and end points for the gradient
    [self calculateStartAndEndPoints];
    
    // Create an image of a solid slab in the desired color
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextFillRect( UIGraphicsGetCurrentContext(), frame);
    CGImageRef colorRef = UIGraphicsGetImageFromCurrentImageContext().CGImage;
    
    // Create an image of a gradient from black to white
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(rgb, maskColors, NULL, sizeof(maskColors) / (sizeof(maskColors[0]) * 4));
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient( context, gradientRef, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGImageRef maskRef = UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
    
    // Blend the solid image and the gradient to produce the final gradient.
    CGImageRef tmpMask = CGImageMaskCreate(
                                           CGImageGetWidth(maskRef),
                                           CGImageGetHeight(maskRef),
                                           CGImageGetBitsPerComponent(maskRef),
                                           CGImageGetBitsPerPixel(maskRef),
                                           CGImageGetBytesPerRow(maskRef),
                                           CGImageGetDataProvider(maskRef),
                                           NULL,
                                           false);
    
    // Apply the new gradient as the UIViews layer content.
    self.layer.contents = (__bridge id)(CGImageCreateWithMask(colorRef, tmpMask));
}

@end
