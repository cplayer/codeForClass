//
//  ViewController.swift
//  cameraDemo
//
//  Created by JTDX on 2018/4/10.
//  Copyright © 2018年 JTDX. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takePhoto(_ sender: UIButton) {
        showMenu();
    }
    
    func showMenu () {
        let alertController = UIAlertController(title: "拍照测试", message: "是否要进行拍照？", preferredStyle: .actionSheet);
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: nil);
        let imageBtn = UIAlertAction(title: "从相册选择", style: .default, handler: {
            (action: UIAlertAction) in
            if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                let imagePicker = UIImagePickerController();
                imagePicker.delegate = self;
                imagePicker.allowsEditing = true;
                imagePicker.sourceType = .photoLibrary;
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil);
                    // self.present(imagePicker, animated: true, completion: nil);
                }
            }
        });
        let photoBtn = UIAlertAction(title: "拍照", style: .destructive, handler: {
            (action: UIAlertAction) in
            if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                let imagePicker = UIImagePickerController();
                imagePicker.sourceType = .camera;
                imagePicker.delegate = self;
                imagePicker.allowsEditing = true;
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil);
                    // self.present(imagePicker, animated: true, completion: nil);
                }
            }
        });
        alertController.addAction(cancelBtn);
        alertController.addAction(imageBtn);
        alertController.addAction(photoBtn);
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil);
        // self.present(alertController, animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickImage = info[UIImagePickerControllerEditedImage] as! UIImage;
        imageView.image = pickImage;
        picker.dismiss(animated: true, completion: nil);
    }
    
}

