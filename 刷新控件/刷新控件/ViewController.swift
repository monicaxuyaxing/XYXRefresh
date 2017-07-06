//
//  ViewController.swift
//  刷新控件
//
//  Created by 亚杏 on 2017/5/27.
//  Copyright © 2017年 oms. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var refreshControl: XYXRefreshControl = XYXRefreshControl()

    @IBOutlet weak var tableView: UITableView!


    /**
     系统刷新控件的问题
     1. 如果用户不放手，下拉到一定程度会自动进入刷新状态，浪费流量
     2. 如果程序主动调用beginRefreshing, 不显示菊花,XCODE8 之后出现
     
     自定义刷新控件，最重要是要解决的，用户放手再刷新
     **/
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置 contentInset
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)

        //添加刷新控件
        tableView.addSubview(refreshControl)

        //监听方法
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)

        //主动调用刷新控件
        loadData()


    }

    func loadData() {

        //开始刷新
        print("开始刷新")
        refreshControl.beginRefreshing()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            print("结束刷新")
            self.refreshControl.endRefreshing()
        }

    }


}

