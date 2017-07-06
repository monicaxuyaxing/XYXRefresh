//
//  XYXRefreshControl.swift
//  SinaWebo
//
//  Created by 亚杏 on 2017/5/27.
//  Copyright © 2017年 oms. All rights reserved.
//

import UIKit


///刷新状态切换的临界点
private let XYXRefreshOffset: CGFloat = 126



/// 刷新状态
///
/// - Normal: 普通
/// - Pulling: 超过临界点，如放手，开始刷新
/// - WillRefresh: 超过临界点，已经放手
enum XYXRefreshState {
    case Normal
    case Pulling
    case WillRefresh
}


//刷新控件 - 负责刷新相关的’逻辑处理’
class XYXRefreshControl: UIControl {

    // MARK: -属性
    // 刷新控件的父视图，下拉刷新控件应适用于 UITableView / UICollectionView
    private weak var scrollView: UIScrollView?
    private lazy var refreshView: XYXRefreshView = XYXRefreshView.refreshView()



//MARK:构造函数
    init() {
        super.init(frame: CGRect())
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //希望用户也可以用xib开发
        super.init(coder: aDecoder)
        setupUI()
    }


    private func setupUI() {
        backgroundColor = UIColor.white

        //设置超出边界不显示
//        clipsToBounds = true
        addSubview(refreshView)

        //自动布局 - 设置xib控件的自动布局，需要指定宽高约束，改成默认的xib的指定的宽高
        refreshView.translatesAutoresizingMaskIntoConstraints = false

        addConstraints([NSLayoutConstraint(item: refreshView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)])
        addConstraints([NSLayoutConstraint(item: refreshView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)])
        addConstraints([NSLayoutConstraint(item: refreshView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.width)])
        addConstraints([NSLayoutConstraint(item: refreshView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.height)])

    }


    /// newSuperView: addSubview方法会自动调用
    /// - 当添加到父视图时，newSuperView是父视图
    /// - 当父视图被移除时，为nil
    override func willMove(toSuperview newSuperview: UIView?) {
        print(newSuperview ?? "")

        //记录父视图,判断父视图类型
        guard let sv = newSuperview as? UIScrollView else {
            return
        }

        scrollView = sv

        //kvo 监听父视图的contentOffset
        //在程序中，通常只监听某一个对象的某几个属性，如果属性太多，方法很乱
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }


    //所有KVO方法会统一调用此方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        //contentOffset 的y值跟contentInset的top有关
//        print(scrollView?.contentOffset ?? "")
        guard let sv = scrollView else {
            return
        }

        //初始高度
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        if height < 0 {
            return
        }
        //根据高度设置刷新控件 frame
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)

        //----传递高度给MTRefreshView
        if refreshView.refreshState != .WillRefresh {
            refreshView.parentViewHeight = height
        }


        //判断临界点
        if sv.isDragging {
            if height > XYXRefreshOffset && (refreshView.refreshState == .Normal) {
                //放手刷新 
                refreshView.refreshState = .Pulling

            }else if height <= XYXRefreshOffset && (refreshView.refreshState == .Pulling){
                //再使劲
                refreshView.refreshState = .Normal

            }

        }else{
            //放手
            if refreshView.refreshState == .Pulling {
                print("准备开始刷新")
                beginRefreshing()
                //发送刷新数据事件
                sendActions(for: .valueChanged)


            }
        }

    }

    //本视图从父视图上移除
    //所有的下拉刷新 框架都是监听父视图的contentOffset
    //所有的框架的 KVO 监听实现思路都是这个
    override func removeFromSuperview() {
        //superView还存在
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
        //superView不存在

    }


    func beginRefreshing() {
        print("开始刷新")
        guard let sv = scrollView else {
            return
        }

        //判断是否正在刷新 ，如正在刷新，直接返回
        if refreshView.refreshState == .WillRefresh{
            return
        }

        //设置刷新视图状态
        refreshView.refreshState = .WillRefresh

        //调整表格间距
        var inset = sv.contentInset
        inset.top += XYXRefreshOffset
        sv.contentInset = inset

        //设置刷新 视图的父视图高度
        refreshView.parentViewHeight = XYXRefreshOffset
    }

    func endRefreshing() {
        print("结束刷新")
        guard let sv = scrollView else {
            return
        }
        //判断是否正在刷新
        if refreshView.refreshState != .WillRefresh {
            return
        }

        // 恢复刷新视图状态
        refreshView.refreshState = .Normal

        // 恢复表格视图的 contentInset
        var inset = sv.contentInset
        inset.top -= XYXRefreshOffset
        sv.contentInset = inset


    }


}

