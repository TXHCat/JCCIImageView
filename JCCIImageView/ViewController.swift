//
//  ViewController.swift
//  JCCIImageView
//
//  Created by Jake on 2018/7/24.
//  Copyright © 2018 Jake. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var R:Float = 0
    private var G:Float = 0
    private var B:Float = 0
    
    @IBOutlet weak var rSlider: UISlider!
    @IBOutlet weak var gSlider: UISlider!
    @IBOutlet weak var bSlider: UISlider!
    private lazy var ciImageView:JCCIImageView = {
        let view = JCCIImageView(frame: CGRect(x: 50,
                                               y: 50,
                                               width: 300,
                                               height: 300))
        view.renderer = JCCIImageViewSuggestedRenderer()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(ciImageView)
        
        updateImageView()
    }
    
    private func updateImageView(){
        ciImageView.image = CIImage(color: CIColor(red: CGFloat(R / 255.0),
                                                   green: CGFloat(G / 255.0),
                                                   blue: CGFloat(B / 255.0),
                                                   alpha: 1)).cropped(to: CGRect(x: 0,
                                                                                 y: 0,
                                                                                 width: 300,
                                                                                 height: 300))
    }
    
    @IBAction func rChange(_ sender: Any) {
        R = rSlider.value
        updateImageView()
    }
    @IBAction func gChange(_ sender: Any) {
        G = gSlider.value
        updateImageView()
    }
    @IBAction func bChange(_ sender: Any) {
        B = bSlider.value
        updateImageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

