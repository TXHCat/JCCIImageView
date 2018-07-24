//
//  ViewController.swift
//  JCCIImageView
//
//  Created by Jake on 2018/7/24.
//  Copyright © 2018 Jake. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let ciiimageView = JCCIImageView(frame: CGRect.init(x: 50, y: 50, width: 300, height: 300))
        ciiimageView.renderer = JCCIImageViewSuggestedRenderer()
        self.view.addSubview(ciiimageView)
        ciiimageView.image = CIImage(color: CIColor.black).cropped(to: CGRect(x: 0, y: 0, width: 300, height: 300))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

