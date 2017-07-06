//
//  XYXRefreshView.swift
//  刷新控件
//
//  Created by 亚杏 on 2017/5/27.
//  Copyright © 2017年 oms. All rights reserved.
//

import UIKit

//刷新视图 - 负责刷新相关的UI显示和动画
class XYXRefreshView: UIView {

    //父视图高度, 作为中间传值对象存在
    var parentViewHeight: CGFloat = 0


    //刷新状态
    /*
     ios系统中 UIView 封装的旋转动画
     - 默认是顺时针旋转
     - 就近原则
     - 要想实现同方向旋转，需要调整一个非常小的数字
     - 如果想实现360 旋转，需要核心动画 CABaseAnimation
     */
    var refreshState: XYXRefreshState = .Normal {

        didSet {
            switch refreshState {
            case .Normal:
                //恢复状态
                tipIcon?.isHidden = false
                indicator?.stopAnimating()

                tipLabel?.text = "继续使劲拉"
                UIView.animate(withDuration: 0.25, animations: { 
                    self.tipIcon?.transform = CGAffineTransform.identity
                })


            case .Pulling:
                tipLabel?.text = "放手就刷新"
                UIView.animate(withDuration: 0.25, animations: { 
                     self.tipIcon?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi - 0.001))
                })

            case .WillRefresh:
                tipLabel?.text = "正在刷新中..."
                //隐藏提示图标，显示菊花
                tipIcon?.isHidden = true
                indicator?.startAnimating()

            }
        }


    }


    //提示图标
    @IBOutlet weak var tipIcon: UIImageView?
    //提示标签
    @IBOutlet weak var tipLabel: UILabel?
    //指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView?

    class func refreshView() -> XYXRefreshView {
        let nib = UINib(nibName: "XYXMTRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! XYXRefreshView
    }
}
