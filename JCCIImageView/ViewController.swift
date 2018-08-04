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
    private var ciImageView:JCCIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.ciImageView = JCCIImageView(frame: CGRect.init(x: 50, y: 50, width: 300, height: 300))
        self.ciImageView.renderer = JCCIImageViewSuggestedRenderer()
        self.view.addSubview(self.ciImageView)
        
        self.updateImageView()
    }
    
    private func updateImageView(){
        self.ciImageView.image = CIImage(color: CIColor(red: CGFloat(self.R/255.0), green: CGFloat(self.G/255.0), blue: CGFloat(self.B/255.0), alpha: 1)).cropped(to: CGRect(x: 0, y: 0, width: 300, height: 300))
    }
    
    @IBAction func rChange(_ sender: Any) {
        self.R = self.rSlider.value
        self.updateImageView()
    }
    @IBAction func gChange(_ sender: Any) {
        self.G = self.gSlider.value
        self.updateImageView()
    }
    @IBAction func bChange(_ sender: Any) {
        self.B = self.bSlider.value
        self.updateImageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

