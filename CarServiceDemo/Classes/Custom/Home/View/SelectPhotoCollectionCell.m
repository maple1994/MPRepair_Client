//
//  LSUploadComplainCertificateCollectionCell.m
//  
//
//  Created by lj on 2017/11/24.
//  Copyright © 2017年 com.. All rights reserved.
//

#import "SelectPhotoCollectionCell.h"

@interface SelectPhotoCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@property (weak, nonatomic) IBOutlet UIView *selectedView;

@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UILabel *addNumLabel;

@property (nonatomic ,strong)SelectPhotoStatusModel *model;

@property (nonatomic ,assign)NSInteger index;
@property (weak, nonatomic) IBOutlet UIView *addImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation SelectPhotoCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.addView.layer.borderWidth = 1.0;
    self.addView.layer.borderColor = [UIColor colorwithHexString:@""].CGColor;
//    UILongPressGestureRecognizer *longPressGR =
//
//    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress2:)];
//    longPressGR.allowableMovement=NO;
//    longPressGR.minimumPressDuration = 0.2;
//    [self.selectImageView addGestureRecognizer:longPressGR];
    
    
//    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
//    [self.selectImageView addGestureRecognizer:tapGesturRecognizer];
}

//-(void)tapAction:(id)tap
//
//{
//
//    NSLog(@"点击了tapView");
//    self.deleteBtn.hidden = YES;
//}


//响应的事件
//
//-(void)handleLongPress2:(id)sender{
//
//
////    UIButton *button=(UIButton*)[(UILongPressGestureRecognizer *)sender view];
////
////    NSInteger ttag=[button tag];
//    self.deleteBtn.hidden = NO;
//
//
//
//}

- (void)setCellParamsWithModel:(SelectPhotoStatusModel *)model andIndexPath:(NSInteger)index{
    self.model = model;
    self.index = index;
    if (model.isAdd) {
        if (model.isShowImg) {
            self.addView.hidden = YES;
            self.selectedView.hidden = YES;
            self.addImageView.hidden = NO;
        } else {
            self.addView.hidden = NO;
            self.selectedView.hidden = YES;
            self.addImageView.hidden = YES;
            self.addNumLabel.text = [NSString stringWithFormat:@"%ld/6", self.index ==1 ? 1 : self.index];
        }
    }else{
        self.addView.hidden = YES;
        self.addImageView.hidden = YES;
        self.selectedView.hidden = NO;
        if (model.imageData) {
            self.selectImageView.image = model.imageData;
        } else {
            
//            [NetWorkingUtil setImage:self.selectImageView url:model.imageUrl defaultIconName:DefaultBannerImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//                model.imageData = image;
//            }];
//            self.selectImageView
//            [self.selectImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]
//                                    placeholderImage:[UIImage imageNamed:@"img_pws_bg"]];
        }
        
    }
    if (model.isCanDelete) {
        self.deleteBtn.hidden = NO;
    }else{
        self.deleteBtn.hidden = YES;
    }
 
}


- (IBAction)deleteBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteImageWithSelectIndex:andImage:)]) {
        [self.delegate deleteImageWithSelectIndex:self.index andImage:self.model.imageData];
    }
    
    if ([self.delegate respondsToSelector:@selector(deleteImageWithSelectIndex:andImageModel:)]) {
        [self.delegate deleteImageWithSelectIndex:self.index andImageModel:self.model];
    }
    
}

@end
