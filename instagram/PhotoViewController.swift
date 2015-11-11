//
//  PhotoViewController.swift
//  instagram
//
//  Created by Dave Vo on 11/11/15.
//  Copyright © 2015 DaveVo. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let urlString = "https://api.instagram.com/v1/media/popular?client_id=4daf1b01806241bc964dec8525dd0bea"
    var photos = [NSDictionary]()
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //tableView.rowHeight = 250
        title = "Instagram"
        refreshControl.addTarget(self, action: Selector("loadImage"), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        loadImage()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return photos.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor.whiteColor() //UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        
        // Use the section number to get the right URL
        let photo = photos[section]
        let profileImageURLString = photo.valueForKeyPath("user.profile_picture") as? String
        let profileImageURL = NSURL(string: profileImageURLString!)
        
        profileView.setImageWithURL(profileImageURL!)
        
        let userLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 320, height: 30))
        userLabel.text = photo.valueForKeyPath("user.full_name") as? String
        
        
        headerView.addSubview(profileView)
        headerView.addSubview(userLabel)
        
        // Add a UILabel for the username here
        
        return headerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // <#code#>
        //var cell: UITableViewCell!
        let cell = tableView.dequeueReusableCellWithIdentifier("photoCell") as! PhotoCell
        let photo = photos[indexPath.section]
        let photoUrlString = photo.valueForKeyPath("images.low_resolution.url") as! String
        //print(photoUrl)
        let photoUrl = NSURL(string: photoUrlString)
        
        cell.photoImageView.setImageWithURL(photoUrl!)
        
        
        return cell
    }
    
    func loadImage(){
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: urlString)!
        
        let task = session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            guard error == nil else  {
                print("error loading from URL", error!)
                return
            }
            
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            self.photos = json["data"] as! [NSDictionary]
            //print("photos", self.photos)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            })
        }
        
        task.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailImageSegue" {
            let detailVC: DetailsViewController = segue.destinationViewController as! DetailsViewController
            let data = sender as! String
            detailVC.photoURL = data
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let photo = photos[indexPath.section]
        let photoURL = photo.valueForKeyPath("images.standard_resolution.url") as! String
        performSegueWithIdentifier("detailImageSegue", sender: photoURL)
    }
    
}

