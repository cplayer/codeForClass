//
//  ViewController.swift
//  tableDemoApp
//
//  Created by JTDX on 2018/3/20.
//  Copyright © 2018年 JTDX. All rights reserved.
//

import UIKit

class diyCell : UITableViewCell {
    var firstLabel : UILabel!;
    var secondLabel : UILabel!;
    var thirdLabel : UILabel!;
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        let firstRect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40);
        firstLabel = UILabel(frame: firstRect);
        firstLabel.font = UIFont.boldSystemFont(ofSize: 20);
        firstLabel.numberOfLines = 1;
        firstLabel.textAlignment = .right;
        self.addSubview(firstLabel);
        
        let secondRect = CGRect(x: 10, y: 30, width: self.frame.size.width, height: 60);
        secondLabel = UILabel(frame: secondRect);
        secondLabel.font = UIFont.boldSystemFont(ofSize: 15);
        secondLabel.numberOfLines = 1;
        secondLabel.textAlignment = .left;
        self.addSubview(secondLabel);
        
        let thirdRect = CGRect(x: 0, y: 95, width: self.frame.size.width, height: 30);
        thirdLabel = UILabel(frame: thirdRect);
        thirdLabel.font = UIFont.boldSystemFont(ofSize: 13);
        thirdLabel.numberOfLines = 1;
        thirdLabel.textAlignment = .right;
        self.addSubview(thirdLabel);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myTable : UITableView!;
    
    var dataArray : Array<Dictionary<String, String>> = [
        ["id" : "value1-1", "title" : "value1-2", "author" : "value1-3"],
        ["id" : "value2-1", "title" : "value2-2", "author" : "value2-3"],
        ["id" : "value3-1", "title" : "value3-2", "author" : "value3-3"],
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let rect = CGRect(x: 0, y: 80, width: self.view.frame.size.width, height: self.view.frame.size.height - 80);
        myTable = UITableView(frame: rect);
        myTable.dataSource = self;
        myTable.delegate = self;
        self.view.addSubview(myTable);
        getData();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = diyCell(style: .default, reuseIdentifier: "Cell");
        let dict : Dictionary<String, String> = dataArray[indexPath.row];
        cell.firstLabel.text = dict["id"];
        cell.secondLabel.text = dict["title"];
        cell.thirdLabel.text = dict["author"];
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getData () {
        let url = URL(string: "http://localhost:8080/getInfos");
        var request = URLRequest(url: url!);
        request.httpMethod = "GET";
        let session = URLSession.shared;
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if (error != nil) {
                print(error?.localizedDescription as Any);
            }
            else
            {
                let dict = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! Array<Dictionary<String, Any>>;
                if (dict != nil)
                {
                    for each in dict! {
                        print(each);
                        for value in each.values {
                            print(value as! Int);
                        }
                    }
//                    self.dataArray = dict as! Array<Dictionary<String, String>>;
//                    DispatchQueue.main.async {
//                        self.myTable.reloadData();
//                    }
                }
//                if let dict = try? JSONSerialization.jsonObject(with: str!, options: .allowFragments) {
//                    self.dataArray = dict as! Array<Dictionary<String, String>>;
//                    DispatchQueue.main.async {
//                        self.myTable.reloadData();
//                    }
//                }
                
            }
        });
        dataTask.resume();
    }
    
}

