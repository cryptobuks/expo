#import "EXAppLoadingCancelView.h"

const NSTimeInterval kEXTimeUntilCancelAppears = 5.0f;

@interface EXAppLoadingCancelView ()

@property (nonatomic, strong) UILabel *lblStatus;
@property (nonatomic, strong) UILabel *lblAdvice;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) NSTimer *tmrShowCancel;

@end

@implementation EXAppLoadingCancelView

- (instancetype)init
{
  if (self = [super init]) {
    [self _setUpViews];
  }
  return self;
}

- (void)dealloc
{
  [self _invalidateTimer];
}

- (void)setFrame:(CGRect)frame
{
  [super setFrame:frame];
  _lblStatus.frame = CGRectMake(16.0f, 0, self.bounds.size.width - 32.0f, 24.0f);

  _btnCancel.frame = CGRectMake(0, 0, 84.0f, 36.0f);
  _btnCancel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(_lblStatus.frame) + 48.0f);

  _lblAdvice.frame = CGRectMake(_lblStatus.frame.origin.x, 0, MIN(_lblStatus.frame.size.width, 300.0f), CGFLOAT_MAX);
  [_lblAdvice sizeToFit];
  _lblAdvice.center = CGPointMake(CGRectGetMidX(_lblAdvice.frame), CGRectGetMaxY(_btnCancel.frame) + CGRectGetMidY(_lblAdvice.frame) + 24.0f);
}

- (void)_setUpViews
{
  self.backgroundColor = [UIColor clearColor];
  _lblStatus = [[UILabel alloc] init];
  _lblStatus.text = @"Opening project...";
  _lblStatus.font = [UIFont boldSystemFontOfSize:14.0f];
  _lblStatus.textColor = [UIColor blackColor];
  _lblStatus.textAlignment = NSTextAlignmentCenter;
  [self addSubview:_lblStatus];
  
  _lblAdvice = [[UILabel alloc] init];
  _lblAdvice.text = @"This is taking much longer than it should. You might want to check your internet connectivity.";
  _lblAdvice.numberOfLines = 0;
  _lblAdvice.font = [UIFont systemFontOfSize:14.0f];
  _lblAdvice.textColor = [UIColor darkGrayColor];
  _lblAdvice.textAlignment = NSTextAlignmentCenter;
  [self addSubview:_lblAdvice];
  
  _btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [_btnCancel setTitle:@"Go back" forState:UIControlStateNormal];
  _btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
  [_btnCancel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  _btnCancel.layer.borderWidth = 1.0f;
  _btnCancel.layer.borderColor = [UIColor darkGrayColor].CGColor;
  _btnCancel.layer.cornerRadius = 3.0f;
  [_btnCancel addTarget:self action:@selector(_onTapCancel) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_btnCancel];
  
  _lblAdvice.hidden = YES;
  _tmrShowCancel = [NSTimer scheduledTimerWithTimeInterval:kEXTimeUntilCancelAppears
                                                    target:self
                                                  selector:@selector(_onCancelTimerFinished)
                                                  userInfo:nil repeats:NO];
  
  [self setNeedsLayout];
}

- (void)_onTapCancel
{
  if (_delegate) {
    [_delegate appLoadingCancelViewDidCancel:self];
  }
}

#pragma mark - cancel timer

- (void)_invalidateTimer
{
  if (_tmrShowCancel) {
    [_tmrShowCancel invalidate];
    _tmrShowCancel = nil;
  }
}

- (void)_onCancelTimerFinished
{
  [self _invalidateTimer];
  _lblAdvice.hidden = NO;
}

@end
