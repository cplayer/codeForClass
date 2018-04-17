//
//  ViewController.swift
//  zjApp
//
//  Created by JTDX on 2018/2/27.
//  Copyright © 2018年 JTDX. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var soundPlayer: AVAudioPlayer!
    var height: CGFloat!;
    var width: CGFloat!;
    
    override func viewDidLoad() {
        let fileurl = Bundle.main.url(forResource: "cctv新闻联播开播音乐", withExtension: "mp3")
        self.soundPlayer = try? AVAudioPlayer.init(contentsOf: fileurl!)
        soundPlayer.play()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // add button with code
        height = self.view.frame.size.height;
        width = self.view.frame.size.width;
        
        let backRect = CGRect(x: 0, y: 20, width: width, height: height - 20);
        let backImageView = UIImageView(frame: backRect);
        let backImage = UIImage(named: "3.jpeg");
        backImageView.image = backImage;
        self.view.addSubview(backImageView);
        
        let btnRect = CGRect(x: width/2 - 20, y: height/2 - 30, width: 60, height: 30);
        let btn = UIButton(frame: btnRect);
//        btn.backgroundColor = UIColor.blue;
        btn.setTitle("gou", for: .normal);
        btn.setTitleColor(UIColor.red, for: .normal);
        btn.setImage(UIImage(named: "1.jpeg"), for: .normal);
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside);
        self.view.addSubview(btn);
        
        let btnCow = CGRect(x: width - 80, y:height - 40, width: 80, height: 40);
        let btn1 = UIButton(frame: btnCow);
        //        btn.backgroundColor = UIColor.blue;
        btn1.setTitle("mao", for: .normal);
        btn1.setTitleColor(UIColor.red, for: .normal);
        btn1.setImage(UIImage(named: "2.jpg"), for: .normal);
        btn1.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside);
        self.view.addSubview(btn1);
        
    }
    
    @objc func onClick(_ sender: UIButton)
    {
        let title = sender.currentTitle;
        var path : String?;
        switch title!
        {
        case "gou":
            path = Bundle.main.path(forResource: "\(title!).mp3", ofType: nil);
        case "mao":
            path = Bundle.main.path(forResource: "\(title!).wav", ofType: nil);
        default:
            break;
        }
        let url = URL(fileURLWithPath: path!);
        soundPlayer = try? AVAudioPlayer(contentsOf: url);
        soundPlayer.play();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var randomNumber: Int = 0
    var picArray : Array<UIImage> = [
        UIImage(named: "1.jpeg")!,
        UIImage(named: "2.jpg")!,
        UIImage(named: "3.jpeg")!
    ]
    var picPigArray : Array<UIImage> = [
        UIImage(named: "4.jpeg")!,
        UIImage(named: "5.jpg")!,
        UIImage(named: "6.jpeg")!
    ]
    
    @IBOutlet weak var imageShow: UIImageView!
    
    @IBAction func randomClickedDog(_ sender: UIButton) {
        var num = 0;
        num = (Int)(arc4random_uniform(3));
        imageShow.image = picArray[num];
        print(NSHomeDirectory());
    }
    
    @IBAction func randomClickedPig(_ sender: UIButton) {
        var num = 0;
        num = (Int)(arc4random_uniform(3));
        imageShow.image = picPigArray[num];
        print(NSHomeDirectory());
    }
    
    
    
}

