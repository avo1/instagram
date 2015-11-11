//
//  DetailsViewController.swift
//  instagram
//
//  Created by Dave Vo on 11/11/15.
//  Copyright © 2015 DaveVo. All rights reserved.
//

import UIKit
import AFNetworking

class DetailsViewController: UIViewController {
    
    var photoURL: String!
    
    
    @IBOutlet weak var imageDetailsView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: photoURL)
        imageDetailsView.setImageWithURL(url!)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
