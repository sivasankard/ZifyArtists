//
//  ZifyDetailViewController.swift
//  ZifyFM
//
//  Created by Siva Sankar on 04/10/17.
//  Copyright © 2017 Siva Sankar. All rights reserved.
//

import UIKit
import WebKit

class ZifyDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var webBgView: UIView!
    var webView: WKWebView!
    let artistBean = ArtistDetailBean()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        
        getArtistDetailListFromServiceManager()
        
//        let myBlog = "https://iosdevcenters.blogspot.com/"
//        let url = NSURL(string: myBlog)
//        let request = URLRequest(url: url! as URL)
        
        // init and load request in webview.
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: webBgView.frame.size.height))
//        webView.navigationDelegate = self
//        webView.load(request)
        self.webBgView.addSubview(webView)
        self.webBgView.sendSubview(toBack: webView)
    }

    func updateDetails() {
        
        nameLbl.text = artistBean.name
        let url = NSURL(string: artistBean.desUrl!)
        let request = URLRequest(url: url! as URL)
        webView.load(request)

        DispatchQueue.global().async {
            if let imgData = NSData(contentsOf: NSURL(string: self.artistBean.imageUrl!)! as URL){
                let img = UIImage(data: imgData as Data)
                DispatchQueue.main.async {
                    self.imageView.image = img
                }
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getArtistDetailListFromServiceManager() {
        
        ServiceManager.sharedInstance.getResponseForURLWithParameters(url: Service_urls.artistDetailList, userInfo: nil, type: "GET") { (data, response, error) in
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDict:NSDictionary? = jsonObject as? NSDictionary
                if (responseDict != nil) {
                    let resultDict : NSDictionary? = responseDict?["artist"] as? NSDictionary
                    let bean = ArtistDetailBean()
                    bean.getArtistDetailList(response: resultDict!, artistBean: self.artistBean)
                    self.updateDetails()
                }
            }
            else{
                print("Get Leave list failed : \(String(describing: error?.localizedDescription))")
            }
            
        }
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
