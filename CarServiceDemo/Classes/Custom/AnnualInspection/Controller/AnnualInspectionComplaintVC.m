//
//  ScheduledRepairVC.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/3.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AnnualInspectionComplaintVC.h"
#import "WKTextView.h"
#import "ZLPhotoActionSheet.h"
#import "ZLDefine.h"
#import <Photos/Photos.h>
#import "ZLPhotoManager.h"
#import "ZLPhotoConfiguration.h"
#import "UIImage+Thumb.h"
#import "SelectPhotoStatusModel.h"
#import "SelectPhotoCollectionCell.h"
#import "MaintenanceRecordController.h"
#import "SubmitMaintainController.h"

static NSString *SelectPhotoCollectionCellID = @"SelectPhotoCollectionCell";

@interface AnnualInspectionComplaintVC ()<UICollectionViewDelegate,UICollectionViewDataSource,SelectPhotoCollectionCellDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet WKTextView *textView;
//  选择相册相关
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic ,strong)NSMutableArray *photoAlbumImageDataSources;
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;
@property (nonatomic, assign) BOOL isOriginal;

@property (weak, nonatomic) IBOutlet UIButton *confrimBtn;
@end

@implementation AnnualInspectionComplaintVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // 初始化属性
    [self setupProperty];
    
    // 初始化页面
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupProperty{
    
    [self.confrimBtn setCornerRadius:4];
    self.textView.placeholder = @"请描述你要投诉的内容";
    self.textView.placeholderColor = [UIColor colorwithHexString:@"A3A3A3"];
    self.title = @"投诉";
    
    [self.photoCollectionView registerNib:[UINib nibWithNibName:@"NoDataCollectionViewCell" bundle:nil]
               forCellWithReuseIdentifier:@"NoDataCollectionViewCell"];
    
    [self.photoCollectionView registerNib:[UINib nibWithNibName:SelectPhotoCollectionCellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:SelectPhotoCollectionCellID];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 18, 0, 0);
    self.photoCollectionView.collectionViewLayout = flowLayout;
    
    if (self.photoAlbumImageDataSources.count <3) {
        SelectPhotoStatusModel *model = [[SelectPhotoStatusModel alloc]init];
        model.imageData = nil;
        model.isAdd = YES;
        model.isShowImg = YES;
        model.isCanDelete = NO;
        [self.photoAlbumImageDataSources addObject:model];
    }
    [self.photoCollectionView reloadData];
    
}




- (NSMutableArray *)photoAlbumImageDataSources{
    if (!_photoAlbumImageDataSources) {
        _photoAlbumImageDataSources = [NSMutableArray array];
    }
    return _photoAlbumImageDataSources;
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.photoAlbumImageDataSources.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SelectPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SelectPhotoCollectionCellID forIndexPath:indexPath];
    cell.delegate = self;
    
    [cell setCellParamsWithModel:self.photoAlbumImageDataSources[indexPath.row] andIndexPath:indexPath.row];
    
    return cell;
}



-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(116, 116);
}


static ZLPhotoActionSheet * extracted(AnnualInspectionComplaintVC *object) {
    return [object getPas];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectPhotoStatusModel *model = self.photoAlbumImageDataSources[indexPath.row];
    if (model.isAdd) {
        [[self getPas] showPhotoLibrary];
    }else{
        
        NSInteger indexTag = indexPath.row;

        [extracted(self) previewSelectedPhotos:self.lastSelectPhotos assets:self.lastSelectAssets index:indexTag isOriginal:self.isOriginal];
    }
    
}


- (ZLPhotoActionSheet *)getPas
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
#pragma mark - 参数配置 optional，可直接使用 defaultPhotoConfiguration
    //以下参数为自定义参数，均可不设置，有默认值
    actionSheet.configuration.sortAscending =0;
    actionSheet.configuration.allowSelectGif = NO;
    actionSheet.configuration.allowSelectVideo = NO;
    //设置相册内部显示拍照按钮
    actionSheet.configuration.allowTakePhotoInLibrary = YES;
    //设置在内部拍照按钮上实时显示相机俘获画面
    actionSheet.configuration.showCaptureImageOnTakePhotoBtn = YES;
    //设置照片最大预览数
    actionSheet.configuration.maxPreviewCount =3;
    //设置照片最大选择数
    actionSheet.configuration.maxSelectCount =3;
    //是否在选择图片后直接进入编辑界面
    actionSheet.configuration.editAfterSelectThumbnailImage = NO;
    //是否在已选择照片上显示遮罩层
    actionSheet.configuration.showSelectedMask = YES;
    //是否允许框架解析图片
    actionSheet.configuration.shouldAnialysisAsset = YES;
    actionSheet.configuration.allowRecordVideo = NO;
    //框架语言
    //是否使用系统相机
    actionSheet.configuration.useSystemCamera = YES;
    actionSheet.configuration.sessionPreset = ZLCaptureSessionPreset1920x1080;
    
#pragma mark - required
    //如果调用的方法没有传sender，则该属性必须提前赋值
    actionSheet.sender = [UIApplication sharedApplication].keyWindow.rootViewController;
    //记录上次选择的图片
    actionSheet.arrSelectedAssets = self.lastSelectAssets;
    zl_weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        zl_strongify(weakSelf);
        strongSelf.isOriginal = isOriginal;
        strongSelf.lastSelectAssets = assets.mutableCopy;
        strongSelf.lastSelectPhotos = images.mutableCopy;
        NSLog(@"image:%@", images);
        [strongSelf anialysisAssets:assets original:isOriginal];
    }];
    return actionSheet;
}

- (void)anialysisAssets:(NSArray<PHAsset *> *)assets original:(BOOL)original
{
    //    [MBProgressHUD showStatusOnView:self withMessage:LoadingMsg];
    //
    if (assets.count >0) {
       
        zl_weakify(self);
        [ZLPhotoManager anialysisAssets:assets original:original completion:^(NSArray<UIImage *> *images) {
            zl_strongify(weakSelf);
            NSMutableArray *imageArr = [NSMutableArray arrayWithArray:images];
            [strongSelf.photoAlbumImageDataSources removeAllObjects];
           
            for (int i = 0; i < images.count; i++) {
                UIImage *image= imageArr[i];
                SelectPhotoStatusModel *model = [[SelectPhotoStatusModel alloc]init];
                model.imageData = image;
                model.isAdd = NO;
                model.isCanDelete = YES;
                [self.photoAlbumImageDataSources addObject:model];
                
            }
            
            
            if (self.photoAlbumImageDataSources.count <3) {
                SelectPhotoStatusModel *model = [[SelectPhotoStatusModel alloc]init];
                model.imageData = nil;
                model.isAdd = YES;
                model.isShowImg = YES;
                model.isCanDelete = NO;
                [strongSelf.photoAlbumImageDataSources addObject:model];
            }
            [strongSelf.photoCollectionView reloadData];
        }];
    }else{
        kWeakSelf(weakSelf);

        weakSelf.photoAlbumImageDataSources = nil;
        
        
        if (self.photoAlbumImageDataSources.count <3) {
            SelectPhotoStatusModel *model = [[SelectPhotoStatusModel alloc]init];
            model.imageData = nil;
            model.isAdd = YES;
            model.isShowImg = YES;
            model.isCanDelete = NO;
            [weakSelf.photoAlbumImageDataSources addObject:model];
        }
        [weakSelf.photoCollectionView reloadData];
        
    }
    
}

- (void)deleteImageWithSelectIndex:(NSInteger)index andImageModel:(SelectPhotoStatusModel *)imageModel{
    NSInteger indexTag = index;
    if (self.photoAlbumImageDataSources.count >=6) {
        indexTag = index;
    }else{
        indexTag = (index==0 ? 0:index);
    }
    if (indexTag < self.photoAlbumImageDataSources.count && self.photoAlbumImageDataSources.count >0 && imageModel) {
        [self.photoAlbumImageDataSources removeObjectAtIndex:indexTag];
        [self.lastSelectAssets removeObjectAtIndex:indexTag];
        [self.lastSelectPhotos removeObjectAtIndex:indexTag];
    }
    
    if (self.photoAlbumImageDataSources.count <3) {
        SelectPhotoStatusModel *model = [[SelectPhotoStatusModel alloc]init];
        model.imageData = nil;
        model.isAdd = YES;
        model.isShowImg = YES;
        model.isCanDelete = NO;
        [self.photoAlbumImageDataSources addObject:model];
    }
    
    [self.photoCollectionView reloadData];
}

- (NSMutableArray *)selectedImageDealWithArr:(NSArray *)arr{
    SelectPhotoStatusModel *addModel = nil;
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:arr];
    for (SelectPhotoStatusModel *model in array) {
        if (model.isAdd) {
            addModel = model;
        }
    }
    if (addModel) {
        [array removeObject:addModel];
    }
    return array;
}



- (IBAction)confirmBtnAction:(UIButton *)sender {
    
    if ([ValidateUtil isEmptyStr:self.textView.text]) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请描述您要投诉的内容！"];
        return;
    }
    
    if ([self selectedImageDealWithArr:self.photoAlbumImageDataSources].count == 0) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请上传图片！"];
        return;
    }
    
    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    parmas[@"id"] = self.dataModel.ID;
    parmas[@"note1"] = self.textView.text;
    NSArray *imageArr = [self selectedImageDealWithArr:self.photoAlbumImageDataSources];
    parmas[@"number"] = @(imageArr.count);
    for(int i = 0 ; i < imageArr.count ; i++){
        SelectPhotoStatusModel *model = imageArr[i];
        NSString *key = [NSString stringWithFormat:@"pic%d",i+1];
        NSData *data = [UIImage imageWithImage:model.imageData limitCompactionImageLength:200];
    
            //使用0或以下来控制线结束后的最大线长度。默认情况下没有插入任何行的结尾
        NSString *valueStr = [data base64EncodedStringWithOptions:0];
        parmas[key] = valueStr;
    
    }
    
    
    kWeakSelf(weakSelf);

    [self.util postDataWithPath:@"/api/survey/survey_feedback/" parameters:parmas result:^(id obj, int status, NSString *msg) {
        if (status == 1) {

            [MBProgressHUD dismissHUDForView:weakSelf.view];
            weakSelf.dataModel.is_feedback = YES;
            [weakSelf.navigationController popViewControllerAnimated:YES];

        }else{

            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
        }
    }];
    
    
}

@end
