//
//  MLViewController.m
//  MapLoadingSample
//
//  Created by katsuhisa.ishii on 2014/05/16.
//  Copyright (c) 2014年 Sparkler Apps. All rights reserved.
//

#import "MLViewController.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "PBTweenAnimation.h"

@interface MLViewController ()
<
MKMapViewDelegate
>

@property(nonatomic,weak) IBOutlet MKMapView* mapView;
@property(nonatomic,weak) IBOutlet UIImageView* loadingImageView;
@property(nonatomic,weak) IBOutlet UIImageView* ringImageView;

@property(nonatomic,strong) CALayer* startAnimationLayer;

@end

@implementation MLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(35.658517, 139.701334);//渋谷
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center,
                                                                   500.0,
                                                                   500.0);
    _mapView.region = region;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionTapButton:(id)sender
{
    for (UIView* subView in self.view.subviews) {
        if( subView.tag >= 1000 ){
            [subView removeFromSuperview];
        }
    }
    
    _loadingImageView.hidden = NO;
    _ringImageView.image = [UIImage imageNamed:@"map_loading_ring.png"];
    _loadingImageView.frame = CGRectMake(_loadingImageView.frame.origin.x,
                                         _loadingImageView.frame.origin.y, 250, 250);
    _ringImageView.frame = CGRectMake(_loadingImageView.frame.origin.x,
                                      _loadingImageView.frame.origin.y, 250, 250);
    
    CAKeyframeAnimation* anim = PBTweenAnimationTypeScale(0.0f, 1.0f, 0.7f, PBTweenFunctionBounceEaseOut);
    [_loadingImageView.layer addAnimation:anim forKey:@"scaleAnimation"];
    [_ringImageView.layer addAnimation:anim forKey:@"scaleAnimation"];
    
    [self performSelector:@selector(startLoadingAnimation)
               withObject:nil afterDelay:0.7f];
}

- (void)startLoadingAnimation
{
    _loadingImageView.image = [UIImage imageNamed:@"map_loading_animation.png"];
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:(M_PI / 180) * 360];
    rotationAnimation.duration = 2.0f;
    rotationAnimation.repeatCount = HUGE_VALF;
    [_loadingImageView.layer addAnimation:rotationAnimation forKey:@"loadingAnimation"];
    
    [self performSelector:@selector(endLoadingAnimation)
               withObject:nil afterDelay:3.0f];
}

- (void)endLoadingAnimation
{
    [_loadingImageView.layer removeAnimationForKey:@"loadingAnimation"];
    
    _loadingImageView.hidden = YES;
    
    _ringImageView.image = [UIImage imageNamed:@"map_loading_fill.png"];
    
    CAKeyframeAnimation* anim = PBTweenAnimationTypeScale(0.9f, 1.0f, 0.3f, PBTweenFunctionBounceEaseOut);
    [_ringImageView.layer addAnimation:anim forKey:@"scaleAnimation"];
    
    for( int i1 = 0; i1 < 10; i1++ ){
        UIImageView* pinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]];
        float x = rand() % 150 + 50;
        float y = rand() % 200 + 150;
        pinImageView.frame = CGRectMake(x, y, 0, 0);
        pinImageView.tag = 1000+i1;
        [self.view addSubview:pinImageView];
        [self performSelector:@selector(startPinAnimation:)
                   withObject:pinImageView afterDelay:0.3f*(i1+1)];
    }
}

- (void)startPinAnimation:(UIImageView*)imageView
{
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 37, 34);
    CAKeyframeAnimation* pinAnim = PBTweenAnimationTypeScale(0.0f, 1.0f, 0.5f, PBTweenFunctionBounceEaseOut);
//    CAKeyframeAnimation* pinAnim = PBTweenAnimationTypeScale(0.0f, 1.0f, 0.5f, PBTweenFunctionElasticEaseOut);
    [imageView.layer addAnimation:pinAnim forKey:@"pinAimation"];
}

//----------------------------------------------------------
#pragma mark - Delegate
#//----------------------------------------------------------
#pragma mark === MKMapViewDelegate ===
//----------------------------------------------------------
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    NSLog(@"mapViewWillStartLoadingMap");
    
    
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"mapViewDidFinishLoadingMap");
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    NSLog(@"mapViewDidFinishRenderingMap");
    
    //_loadingImageView.hidden = YES;
    //_ringImageView.image = [UIImage imageNamed:@"map_loading_fill.png"];
}

@end
