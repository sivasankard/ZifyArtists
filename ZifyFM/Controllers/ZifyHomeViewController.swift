//
//  ZifyHomeViewController.swift
//  ZifyFM
//
//  Created by Siva Sankar on 04/10/17.
//  Copyright © 2017 Siva Sankar. All rights reserved.
//

import UIKit

class ZifyHomeViewController: UIViewController {

    @IBOutlet weak var fmTableView: UITableView!
    var artistListArray : NSMutableArray? = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getArtistListFromServiceManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getArtistListFromServiceManager() {
        
        ServiceManager.sharedInstance.getResponseForURLWithParameters(url: Service_urls.artistUrl, userInfo: nil, type: "GET") { (data, response, error) in
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDict:NSDictionary? = jsonObject as? NSDictionary
                if (responseDict != nil) {
                    let resultDict : NSDictionary? = responseDict?["results"] as? NSDictionary
                    let artistBean = ArtistBean()

                    artistBean.getArtistsList(response: resultDict!, artistsArray: self.artistListArray!)
                    self.fmTableView.reloadData()
                }
            }
            else{
                print("Get Leave list failed : \(String(describing: error?.localizedDescription))")
            }

        }
        
    }

}

//MARK:- Tableview Extentios
extension ZifyHomeViewController : UITableViewDataSource {
    
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (self.artistListArray?.count)!
    }
    
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let _:UITableViewCell?
    
    let cell : HomeFMCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.homeViewCellId, for: indexPath) as! HomeFMCell
    
    let artisBean : ArtistBean = self.artistListArray![indexPath.row] as! ArtistBean
    cell.nameLbl.text = artisBean.name
    cell.descLbl.text = artisBean.listeners
    let imgUrl = artisBean.picturesArray[0] as! ImagesBean
    
    DispatchQueue.global().async {
        if let imgData = NSData(contentsOf: NSURL(string: imgUrl.imageUrl!)! as URL){
            let img = UIImage(data: imgData as Data)
            DispatchQueue.main.async {
                cell.fmImageView.image = img
            }
        }
    }
    return cell
    }
}

extension ZifyHomeViewController : UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
