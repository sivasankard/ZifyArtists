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
    var artistSearchResult : NSMutableArray? = NSMutableArray()
    var artistLoadArray : NSMutableArray? = NSMutableArray()
    var searchController: UISearchController!
    var shouldShowSearchResults = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureSearchController()
        getArtistListFromServiceManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        fmTableView.tableHeaderView = searchController.searchBar
    }
    
    func getArtistListFromServiceManager() {
        
        ServiceManager.sharedInstance.getResponseForURLWithParameters(url: Service_urls.artistUrl, userInfo: nil, type: "GET") { (data, response, error) in
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDict:NSDictionary? = jsonObject as? NSDictionary
                if (responseDict != nil) {
                    let resultDict : NSDictionary? = responseDict?["results"] as? NSDictionary
                    let artistBean = ArtistBean()

                    artistBean.getArtistsList(response: resultDict!, artistsArray: self.artistListArray!)
                    self.artistLoadArray = NSMutableArray(array: self.artistListArray!)
                    self.fmTableView.reloadData()
                }
            }
            else{
                print("Get Leave list failed : \(String(describing: error?.localizedDescription))")
            }

        }
        
    }
    
    func filterContentForSearchText(searchText: String, scope: Int) {
        
    }

}

//MARK:- Tableview Extentios
//MARK:- TableView DataSource
extension ZifyHomeViewController : UITableViewDataSource {
    
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (self.artistLoadArray?.count)!
    }
    
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let _:UITableViewCell?
    
    let cell : HomeFMCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.homeViewCellId, for: indexPath) as! HomeFMCell
    
    let artisBean : ArtistBean = self.artistLoadArray![indexPath.row] as! ArtistBean
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

//MARK:- TableView Delegate
extension ZifyHomeViewController : UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ZifyHomeViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        // Filter the data array and get only those countries that match the search text.
        let arr = artistListArray?.filter{
            let bean = $0 as! ArtistBean
            return (bean.name?.lowercased().contains(searchString.lowercased()))!
            }
        if shouldShowSearchResults == true {
            artistLoadArray = NSMutableArray(array: arr!)
        }
        // Reload the tableview.
        fmTableView.reloadData()
    }
}

extension ZifyHomeViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        fmTableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        self.artistLoadArray = NSMutableArray(array: self.artistListArray!)
        fmTableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            fmTableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }

}
