//
//  ViewController.m
//  PhotoGesture
//
//  Created by LH on 16/6/21.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "QTRejectViewCell.h"
#import "TZImagePickerController.h"
#import "HXTagsView.h"
#import "XWDragCellCollectionView.h"

#define PADDING 10
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//十六进制颜色
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// View 坐标(x,y)和宽高(width,height)
#define X(v)               (v).frame.origin.x
#define Y(v)               (v).frame.origin.y
#define WIDTH(v)           (v).frame.size.width
#define HEIGHT(v)          (v).frame.size.height

#define MinX(v)            CGRectGetMinX((v).frame) // 获得控件屏幕的x坐标
#define MinY(v)            CGRectGetMinY((v).frame) // 获得控件屏幕的Y坐标

#define MidX(v)            CGRectGetMidX((v).frame) //横坐标加上到控件中点坐标
#define MidY(v)            CGRectGetMidY((v).frame) //纵坐标加上到控件中点坐标

#define MaxX(v)            CGRectGetMaxX((v).frame) //横坐标加上控件的宽度
#define MaxY(v)            CGRectGetMaxY((v).frame) //纵坐标加上控件的高度

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XWDragCellCollectionViewDataSource, XWDragCellCollectionViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>{
    XWDragCellCollectionView *_collectionView;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf2f4f4);
    
    self.phonelist = [[NSMutableArray alloc]init];
    
    self.svMain = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-0)];
    self.svMain.backgroundColor = [UIColor clearColor];
    self.svMain.showsVerticalScrollIndicator = NO;
    self.svMain.showsHorizontalScrollIndicator = NO;
    self.svMain.delegate = self;
    [self .view addSubview:self.svMain];
    
    self.viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 50)];
    self.viewBg.backgroundColor = [UIColor whiteColor];
    [self.svMain addSubview:self.viewBg];
    
    self.tfView = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 30)];
    self.tfView.font = [UIFont systemFontOfSize:15];
    self.tfView.placeholder = @"请输入相册名称";
    self.tfView.textColor = [UIColor blackColor];
    self.tfView.returnKeyType = UIReturnKeySend;
    self.tfView.delegate = self;
    [self.viewBg addSubview:self.tfView];
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT(self.viewBg)-1, kScreenWidth, 1)];
    viewLine.backgroundColor = UIColorFromRGB(0xe6e6e6);
    [self.viewBg addSubview:viewLine];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[XWDragCellCollectionView alloc]initWithFrame:CGRectMake(0, MaxY(self.viewBg), WIDTH(self.view),(kScreenWidth-40)/3+20) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[QTRejectViewCell class] forCellWithReuseIdentifier:@"rejectViewMeCell"];
    [self.svMain addSubview:_collectionView];
    
    self.viewlin = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT(_collectionView)-1, kScreenWidth, 1)];
    self.viewlin.backgroundColor = UIColorFromRGB(0xe6e6e6);
    [_collectionView addSubview:self.viewlin];
    
    //添加照片按钮
    self.btnAddPhone = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnAddPhone.frame = CGRectMake(10, 10, (kScreenWidth-40)/3, (kScreenWidth-40)/3);
    [self.btnAddPhone setBackgroundImage:[UIImage imageNamed:@"icon_find_phone_tianjia2"] forState:UIControlStateNormal];
    [self.btnAddPhone addTarget:self action:@selector(BtnAddPhoneClick) forControlEvents:UIControlEventTouchUpInside];
    [_collectionView addSubview:self.btnAddPhone];
    
    //标签
    
    self.tagviewBg = [[UIView alloc]init];
    self.tagviewBg.backgroundColor = [UIColor whiteColor];
    [self.svMain addSubview:self.tagviewBg];
    
    UILabel *labTagName = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, kScreenWidth-20, 21)];
    labTagName.text = @"选择分享对象";
    labTagName.font = [UIFont systemFontOfSize:15];
    [self.tagviewBg addSubview:labTagName];
    
    NSArray *tagAry = @[@"+魔兽世界",@"梦幻西游",@"qq飞车",@"传奇",@"逆战",@"炉石传说"];
    HXTagsView *tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(0, MaxY(labTagName)+10, kScreenWidth, 0)];
    tagsView.tag = 1000;
    tagsView.type = 0;
    [tagsView setTagAry:tagAry delegate:self];
    [self.tagviewBg addSubview:tagsView];
    
  
    self.btndel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btndel.frame = CGRectMake(0, MaxY(tagsView)+50, kScreenWidth, 44);
    [self.btndel setTitle:@"删除画板" forState:UIControlStateNormal];
    [self.btndel setTitleColor:UIColorFromRGB(0x05d2a2) forState:UIControlStateNormal];
    self.btndel.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.tagviewBg addSubview:self.btndel];
    [self.btndel addTarget:self action:@selector(DelClick) forControlEvents:UIControlEventTouchUpInside];
    self.tagviewBg.frame = CGRectMake(0,MaxY(_collectionView)+10, kScreenWidth, MaxY(self.btndel));
    
    UIView *viewline = [[UIView alloc]initWithFrame:CGRectMake(0, Y(self.btndel)-1, kScreenWidth, 1)];
    viewline.backgroundColor = UIColorFromRGB(0xe6e6e6);
    [self.tagviewBg addSubview:viewline];
    
    //滚动视图
    self.svMain.contentSize = CGSizeMake(kScreenWidth,MaxY(self.tagviewBg));
    
}

#pragma mark HXTagsViewDelegate

/**
 *  tagsView代理方法
 *
 *  @param tagsView tagsView
 *  @param sender   tag:sender.titleLabel.text index:sender.tag
 */
- (void)tagsViewButtonAction:(HXTagsView *)tagsView button:(UIButton *)sender {
    NSLog(@"tag:%@ index:%ld",sender.titleLabel.text,(long)sender.tag);
    if(sender.tag>0){
        [sender setBackgroundImage:[self imageWithColor:UIColorFromRGB(0x05d2a2) size:CGSizeMake(1.0, 1.0)] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sender.layer.borderColor = [[UIColor clearColor] CGColor];
    }else if (sender.tag<0){
        [sender setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateNormal];
        [sender setTitleColor:UIColorFromRGB(0x7f7f7f) forState:UIControlStateNormal];
        sender.layer.borderColor = [UIColorFromRGB(0x7f7f7f) CGColor];
    }
    sender.tag = -sender.tag;
    
}
//颜色生成图片方法
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,
                                   
                                   color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
#pragma mark - UICollectionViewDataSource

- (NSArray *)dataSourceArrayOfCollectionView:(XWDragCellCollectionView *)collectionView{
    return self.phonelist;
}

- (void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView newDataArrayAfterMove:(NSMutableArray *)newDataArray{
    [self.phonelist removeAllObjects];
    [self.phonelist addObjectsFromArray:newDataArray];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.phonelist.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QTRejectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rejectViewMeCell" forIndexPath:indexPath];
    cell.imageView.image = [self.phonelist objectAtIndex:indexPath.row];
    cell.delBtn.tag = 100+indexPath.row;
    [cell.delBtn addTarget:self action:@selector(BtnDelPhone:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-40)/3, (kScreenWidth-40)/3);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(PADDING, PADDING, PADDING, PADDING);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
//删除照片的事件
- (void)BtnDelPhone:(UIButton *)sender{
    [self.phonelist removeObjectAtIndex:sender.tag-100];
    [self resetLayout];
}
//添加图片事件
- (void)BtnAddPhoneClick{
    [self showSheetView];
}
//删除照片
- (void)DelClick{
    [self.phonelist removeAllObjects];
    [self resetLayout];
}
-(void)resetLayout{
    int columnCount = ceilf((_phonelist.count + 1) * 1.0 / 3);
    float height = columnCount * ((kScreenWidth-40)/3 +10)+10;
    if (height < (kScreenWidth-40)/3+20) {
        height = (kScreenWidth-40)/3+20;
    }
    CGRect rect = _collectionView.frame;
    rect.size.height = height;
    _collectionView.frame = rect;
    [_collectionView reloadData];
    
    self.btnAddPhone.frame = CGRectMake(10+(10+(kScreenWidth-40)/3)*(self.phonelist.count%3), HEIGHT(_collectionView)-(kScreenWidth-40)/3-10,(kScreenWidth-40)/3,(kScreenWidth-40)/3);
    self.viewlin.frame = CGRectMake(0, HEIGHT(_collectionView)-1, kScreenWidth, 1);
    self.tagviewBg.frame = CGRectMake(0,MaxY(_collectionView)+10, kScreenWidth, MaxY(self.btndel));
    self.svMain.contentSize = CGSizeMake(kScreenWidth,MaxY(self.tagviewBg));
}

-(void)showSheetView{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *setAlert = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self callCameraOrPhotoWithType:UIImagePickerControllerSourceTypeCamera];
    
                    }];
        UIAlertAction *PhoneAlert = [UIAlertAction actionWithTitle:@"从手机选择" style:
            UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:20 delegate:nil];
                // 你可以通过block或者代理，来得到用户选择的照片.
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
                    [self.phonelist addObjectsFromArray:photos];
                    [self resetLayout];
                }];
                // 在这里设置imagePickerVc的外观
                imagePickerVc.navigationBar.barTintColor = [UIColor blackColor];
                imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
                // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
                // 设置是否可以选择视频/原图
                // imagePickerVc.allowPickingVideo = NO;
                // imagePickerVc.allowPickingOriginalPhoto = NO;
                imagePickerVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:imagePickerVc animated:YES completion:nil];
        
                    }];
        UIAlertAction *hidAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
                    }];
                    [alert addAction:setAlert];
                    [alert addAction:PhoneAlert];
                    [alert addAction:hidAlert];
    
                    [self presentViewController:alert animated:YES completion:^{
    
                    }];

}


-(void)callCameraOrPhotoWithType:(UIImagePickerControllerSourceType)sourceType{
    BOOL isCamera = YES;
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {//判断是否有相机
        isCamera = [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
    }
    if (isCamera) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;//为NO，则不会出现系统的编辑界面
        imagePicker.sourceType = sourceType;
        [self presentViewController:imagePicker animated:YES completion:^(){
            if ([[[UIDevice currentDevice] systemVersion]floatValue]>=7.0) {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            }
        }];
    } else {

    }
}
#pragma UIImagePickerControllerDelegate
//相册或则相机选择上传的实现
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)aImage editingInfo:(NSDictionary *)editingInfo{
    
    NSArray *photos = [[NSArray alloc]initWithObjects:aImage, nil];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        // [self uploadPhotos:photos];
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tfView resignFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([@"\n" isEqualToString:string] == YES){
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
