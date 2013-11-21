//
//  BlurryModalSegue.m
//  BlurryModal
//
//  Created by Matthew Hupman on 11/21/13.
//  Copyright (c) 2013 Citrrus. All rights reserved.
//

#import "BlurryModalSegue.h"
#import <QuartzCore/QuartzCore.h>
#import <UIImage+BlurredFrame/UIImage+ImageEffects.h>

@implementation BlurryModalSegue

- (void)perform
{
    UIViewController* source = (UIViewController*)self.sourceViewController;
    UIViewController* destination = (UIViewController*)self.destinationViewController;
    
    CGSize windowSize = source.view.window.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(windowSize, YES, 2.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [source.view.window.layer renderInContext:context];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (self.processBackgroundImage)
    {
        snapshot = self.processBackgroundImage(self, snapshot);
    }
    else
    {
        snapshot = [snapshot applyBlurWithRadius:15 tintColor:nil saturationDeltaFactor:0 maskImage:nil];
    }
    
    destination.view.clipsToBounds = YES;
    
    UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:snapshot];
    backgroundImageView.frame = CGRectMake(0, -windowSize.height, windowSize.width, windowSize.height);
    
    [destination.view addSubview:backgroundImageView];
    [destination.view sendSubviewToBack:backgroundImageView];
    
    [self.sourceViewController presentModalViewController:self.destinationViewController animated:YES];
    
    [destination.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [UIView animateWithDuration:[context transitionDuration] animations:^{
            backgroundImageView.frame = CGRectMake(0, 0, windowSize.width, windowSize.height);
        }];
    } completion:nil];
}

@end