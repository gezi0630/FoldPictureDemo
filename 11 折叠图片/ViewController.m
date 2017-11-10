//
//  ViewController.m
//  11 折叠图片
//
//  Created by MAC on 2017/8/29.
//  Copyright © 2017年 GuoDongge. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *dragView;

/**渐变图层*/
@property(nonatomic,weak)CAGradientLayer * gradLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
     // 通过设置contentsRect可以设置图片显示的尺寸，取值0~1
    _topView.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
    _topView.layer.anchorPoint = CGPointMake(0.5, 1);
    
    _bottomView.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);
    _bottomView.layer.anchorPoint = CGPointMake(0.5, 0);
    
    
    //添加手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [_dragView addGestureRecognizer:pan];
    
    
    

    //渐变图层
    CAGradientLayer * gradLayer = [CAGradientLayer layer];
    //需要设置尺寸
    gradLayer.frame = _bottomView.bounds;
    // 设置不透明度 0
    gradLayer.opacity = 0;
    //从什么颜色渐变为什么颜色
    gradLayer.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor];
    
    _gradLayer = gradLayer;
    
    [_bottomView.layer addSublayer:gradLayer];
    
}

-(void)pan:(UIPanGestureRecognizer*)pan
{
//    //设置偏移量
    CGPoint transP = [pan translationInView:_dragView];
    
    //旋转角度，向下逆时针旋转
    CGFloat angle = -transP.y / 200.0 * M_PI ;
    
    CATransform3D transform = CATransform3DIdentity;
    
    //增加旋转立体感，近大远小
    transform.m34 = - 1 / 500.0;
    //沿X轴旋转
    _topView.layer.transform = CATransform3DRotate(transform, angle, 1, 0, 0);
    
    //设置阴影效果，偏移量的二百分之一
    _gradLayer.opacity = transP.y * 1 / 200.0;
    
    //手势结束时
    if (pan.state == UIGestureRecognizerStateEnded) {
        //弹簧效果动画
        //SpringWithDamping：弹簧系数，越小，效果越明显
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _topView.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
        //阴影消失
        _gradLayer.opacity = 0;
    }
    
    
    
}






@end
