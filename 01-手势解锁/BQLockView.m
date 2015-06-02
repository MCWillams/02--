//
//  BQLockView.m
//  01-手势解锁
//
//  Created by 严必庆 on 15-5-30.
//  Copyright (c) 2015年 严必庆. All rights reserved.
//

#import "BQLockView.h"

@interface BQLockView ()<BQLockViewDelegate>
@property (nonatomic,strong) NSMutableArray *selectedBtns;
@property (nonatomic,assign) CGPoint currentMovePoint;
@end
@implementation BQLockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];

        }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;

}

-(void)setup{
    for (int index = 0; index<9; index++) {
    UIButton *btn = [[UIButton alloc]init];
    btn.userInteractionEnabled = NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        btn.tag = index;
    [self addSubview:btn];
    }
}

//设置frame
-(void)layoutSubviews{
    [super layoutSubviews];
    for (int index = 0; index<self.subviews.count; index++) {
        UIButton *btn = self.subviews[index];
        int totalCols = 3;
        int totalRows = 3;
        int colNo = index % totalCols;
        int rowNo = index / totalRows;
        CGFloat btnW = 74;
        CGFloat btnH = 74;
        CGFloat margin = (self.frame.size.width - 3 * btnW) / 4;
        CGFloat btnX = margin + colNo * (btnW + margin);
        CGFloat btnY = rowNo *(btnW + margin);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

//懒加载
-(NSMutableArray *)selectedBtns{
    if (_selectedBtns == nil) {
        _selectedBtns = [NSMutableArray array];
    }
    return _selectedBtns;
}

/*
私有方法
*/
//1.取得当前点
-(CGPoint)pointWithTouches:(NSSet *)touches{
    UITouch *touch = [touches anyObject];
    return  [touch locationInView:touch.view];
}
//2.判断当前点的位置，返回一个按钮
-(UIButton *)buttonWithPoint:(CGPoint)point{
    for (UIButton *btn in self.subviews) {
        CGFloat circleX = btn.frame.origin.x + (btn.frame.size.width -20) / 2;
        CGFloat circleY = btn.frame.origin.y + (btn.frame.size.height -20) / 2;
        CGFloat circleW = 20;
        CGFloat circleH = 20;
        CGRect circle = CGRectMake(circleX, circleY, circleW, circleH);
        
    if (CGRectContainsPoint(circle, point)) {
        return btn;
        }
    }
    return nil;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.currentMovePoint = CGPointZero;
    //1.取得当前点
    CGPoint pos = [self pointWithTouches:touches];
    //2.获取当前点所在位置，返回按钮
    UIButton *btn = [self buttonWithPoint:pos];
    //3.设置按钮
    if (btn && btn.selected == NO) {
        //1.选中btn
        btn.selected = YES;
        //2.将选中btn加入数组
        [self.selectedBtns addObject:btn];
    }
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //1.取得当前点
    CGPoint pos = [self pointWithTouches:touches];
    //2.获取当前点所在位置，返回按钮
    UIButton *btn = [self buttonWithPoint:pos];
    //3.设置按钮
    if (btn && btn.selected == NO) {//摸到按钮
        //1.选中btn
        btn.selected = YES;
        //2.将选中btn加入数组
        [self.selectedBtns addObject:btn];
    }
    else{//没有摸到按钮
        self.currentMovePoint = pos;
    }
    [self setNeedsDisplay];

    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesMoved:touches withEvent:event];
    //1.代理方法
    if ([self.delegate respondsToSelector:@selector(lockView:didFinishPath:) ]) {
        //如果代理实现了方法，取出路径，将str传给代理
        NSMutableString  *str = [NSMutableString string];
        for (UIButton *btn in self.selectedBtns) {
        [str appendFormat:@"%d",btn.tag];
        }
        [self.delegate lockView:self didFinishPath:str];
    }
    //取消所有选中按钮
    [self.selectedBtns makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
    //将选中按钮的数组情况
    [self.selectedBtns removeAllObjects];
    //重绘
    [self setNeedsDisplay];

}

-(void)drawRect:(CGRect)rect{
    //如果选中按钮等于0.直接返回（清空绘图）
    if (self.selectedBtns.count == 0) return;
    //绘图
    //1.添加贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    //2.遍历选中按钮
    for (int index = 0; index<self.selectedBtns.count; index++) {
        //2.1 取出按钮
        UIButton *btn = self.selectedBtns[index];
        if (index == 0) {//如果是第一个按钮
            //2.2 设置曲线起点
            [path moveToPoint:btn.center];
        }
        else //非第一个按钮
            //2.3 添加线段
            [path addLineToPoint:btn.center];
    }
    //3.绘制一条延伸线段（未到下一个按钮）
    if (CGPointEqualToPoint(self.currentMovePoint,CGPointZero) == NO) {
        [path addLineToPoint:self.currentMovePoint];
    }
    //4.
    [path setLineCapStyle:kCGLineCapRound];
    //5. 设置线宽
    [path setLineWidth:8];
    //6. 设置连接点
    [path setLineJoinStyle:kCGLineJoinBevel];
    //7. 设置线段颜色
    [[UIColor greenColor]set];
    //8. 绘制路径
    [path stroke];

}

@end






