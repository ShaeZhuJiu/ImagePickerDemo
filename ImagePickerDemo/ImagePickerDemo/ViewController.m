//
//  ViewController.m
//  ImagePickerDemo
//
//  Created by 谢鑫 on 2020/2/27.
//  Copyright © 2020 Shae. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation ViewController
UIImagePickerController *picker;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%d",testprefix);
    picker=[[UIImagePickerController alloc]init];
    picker.delegate=self;
}
- (IBAction)takePhoto:(UIButton *)sender {
    //如果拍摄的摄像头可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //将sourceType设置为UIImagePickerControllerSourceTypeCamera代表拍照或拍视频
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        //设置拍照照片
        picker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
        //设置使用手机的前置摄像头
        //picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
        //设置拍摄的照片允许编辑
        picker.allowsEditing=YES;
    }else{
        NSLog(@"无法打开摄像头");
    }
    //显示picker视图控制器
    [self presentViewController:picker animated:YES completion:nil];
    
}
- (IBAction)takeVideo:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 将sourceType设为UIImagePickerControllerSourceTypeCamera代表拍照或拍视频
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        //将mediaTypes设置为所有支持的多媒体类型
        picker.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        //设置拍摄视频
        picker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;
        //设置拍摄高质量的视频
        picker.videoQuality=UIImagePickerControllerQualityTypeHigh;
    }else{
        NSLog(@"无法打开摄像头");
    }
    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)loadPhoto:(UIButton *)sender {
    //设置选择加载相册的图片或视频
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;//y图片视频
    //picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;//仅图片
    picker.allowsEditing=YES;
    [self presentViewController:picker animated:YES completion:nil];
}
//当得到照片或者视频j后，调用该委托方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    NSLog(@"成功：%@",info);
    //获取用户拍摄的是照片还是视频
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断获取类型：图片，并且是刚拍摄的图片
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]&&picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        UIImage *theImage=nil;
        //判断，图片是否允许篡改
        if ([picker allowsEditing]) {
            //获取用户编辑之后的图像
            theImage=[info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            //获取原始的照片
            theImage=[info objectForKey:UIImagePickerControllerOriginalImage];
        }
        //保存图片到相册中
        UIImageWriteToSavedPhotosAlbum(theImage, self, nil, nil);
    }else if ([mediaType isEqualToString:(NSString*)kUTTypeMovie]){
        //获取视频文件的url
        NSURL *mediaURL=[info objectForKey:UIImagePickerControllerMediaURL];
        //将视频保存到媒体库
        UISaveVideoAtPathToSavedPhotosAlbum(mediaURL.path,self,@selector(video:didFinishSavingWithError:contextInfo:),nil);
        NSLog(@"mediaURL.path:%@",mediaURL.path);
    }else if ([mediaType isEqualToString:(NSString*)kUTTypeImage]&&picker.sourceType==UIImagePickerControllerSourceTypePhotoLibrary){
        //呈现选取的照片
        if ([picker allowsEditing]) {
            //获取用户编辑之后的图像
            self.loadImageView.image=[info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            //获取原始的照片
            self.loadImageView.image=[info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    //隐藏UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
}
// UISaveVideoAtPathToSavedPhotosAlbum 视频保存回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    
    NSLog(@"%@",videoPath);
    
    NSLog(@"%@",error);
    
}
//当用户取消时，调用该代理方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"用户取消的拍摄");
    //隐藏UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];

}
@end
