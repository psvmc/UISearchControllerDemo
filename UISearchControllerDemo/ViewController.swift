//
//  ViewController.swift
//  UISearchControllerDemo
//
//  Created by 张剑 on 16/4/15.
//  Copyright © 2016年 张剑. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    var searchController:UISearchController!;
    var airlines:[[String:String]] = [];
    var airlinesFilter:[[String:String]] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSBundle.mainBundle().pathForResource("airlineData", ofType: "json");
        let data = NSData(contentsOfFile: path!);
        
        do{
            let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [String:AnyObject];
            self.airlines = dict["airlines"] as! [[String:String]];
        }catch{
        
        }
        
        self.searchController = UISearchController(searchResultsController:nil);
        self.searchController.searchResultsUpdater = self;
        self.searchController.dimsBackgroundDuringPresentation = false;
        self.searchController.searchBar.sizeToFit();
        self.searchController.searchBar.backgroundColor = UIColor.grayColor();
        self.tableView.tableHeaderView = self.searchController.searchBar;
        self.tableView.dataSource = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func filterDataByKeyword(keyword:String){
        self.airlinesFilter.removeAll();
        for item in airlines{
            if(item["Name"]!.containsString(keyword)){
                self.airlinesFilter.append(item);
            }
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filterDataByKeyword(searchController.searchBar.text!);
        self.tableView.reloadData();
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(!self.searchController.active){
            return self.airlines.count;
        }else{
            return self.airlinesFilter.count;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "UITableViewCellStyle_Value1")
        if(!self.searchController.active){
            cell.textLabel?.text = self.airlines[indexPath.row]["Name"];
        }else{
            cell.textLabel?.text = self.airlinesFilter[indexPath.row]["Name"];
        }
        return cell;
    }
}

