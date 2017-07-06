//
//  XYXMTRefreshView.swift
//  刷新控件
//
//  Created by 亚杏 on 2017/5/31.
//  Copyright © 2017年 oms. All rights reserved.
//

import UIKit

class XYXMTRefreshView: XYXRefreshView {

    @IBOutlet weak var buildingIconView: UIImageView!
    @IBOutlet weak var kangarooView: UIImageView!
    @IBOutlet weak var earthIconView: UIImageView!

   override var parentViewHeight: CGFloat{
        didSet{
            print("父视图高度\(parentViewHeight)")
            if parentViewHeight < 36 {
                return
            }
            //36-126
            //0.2-1
            var scale: CGFloat
            if parentViewHeight > 126 {
                scale = 1
            }else{
                scale = 1 - ((126-parentViewHeight) / (126-36) )
            }

            kangarooView.transform = CGAffineTransform(scaleX: scale , y: scale)

        }
    }


    override func awakeFromNib() {
        //1.房子
        let image1 = #imageLiteral(resourceName: "icon_building_loading_1")
        let image2 = #imageLiteral(resourceName: "icon_building_loading_2")

        buildingIconView.image = UIImage.animatedImage(with: [image1,image2], duration: 0.5)

        //2.地球
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = -2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 3
        anim.isRemovedOnCompletion = false
        earthIconView.layer.add(anim, forKey: nil)

        //3.袋鼠
        //设置袋鼠动画
        let kimage1 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_1")
        let kimage2 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_2")

        kangarooView.image = UIImage.animatedImage(with: [kimage1,kimage2], duration: 0.5)

        //设置锚点,让袋鼠下移
        kangarooView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        //设置frame、center
        let x = self.bounds.width * 0.5
        let y = self.bounds.height - 36
        kangarooView.center = CGPoint(x:x , y: y)
        //缩小
        kangarooView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)


    }
}
