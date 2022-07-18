//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Mustafa on 17.07.2022.
//

import UIKit
import ImageSlideshow
class SnapVC: UIViewController {

    @IBOutlet var timeLabel: UILabel!
    var selectedSnap: Snap?
    var inputArray = [KingfisherSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let snap = selectedSnap {
            
            timeLabel.text = "Time left: \(snap.timeDifference)"
            
            for imageUrl in snap.imageUrlArray {
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
            imageSlideShow.backgroundColor = .white
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = .lightGray
            pageIndicator.pageIndicatorTintColor = .black
            imageSlideShow.pageIndicator = pageIndicator
            
            imageSlideShow.contentScaleMode = .scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLabel)
        }
    }
}
