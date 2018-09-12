//
//  FilterListViewController.swift
//  SampleCamera
//
//  Created by Takashi Sawada on 2018/01/31.
//  Copyright © 2018年 Takashi Sawada. All rights reserved.
//

import UIKit
protocol FilterListViewControllerDelegate: class {
    func FilterListViewController(_ controller:FilterListViewController, didSelectFilter filter:String, index:Int)
}
class FilterListViewController: UITableViewController {
    weak var delegate : FilterListViewControllerDelegate? = nil
    
    var selectedIndex : Int = 0
    
    let filterList:[String] = ["",
                               "CIPhotoEffectChrome",
                               "CIPhotoEffectFade",
                               "CIPhotoEffectInstant",
                               "CIPhotoEffectMono",
                               "CIPhotoEffectNoir",
                               "CIPhotoEffectProcess",
                               "CIPhotoEffectTonal",
                               "CIPhotoEffectTransfer",
                               "CISepiaTone",
                               "CIVignette",]

    var BuildInfilterList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BuildInfilterList = CIFilter.filterNames(inCategory: kCICategoryBuiltIn)
        print(BuildInfilterList)
        
//        CIFilter.filterNames(inCategory: kCICategoryBuiltIn)
//            .forEach{ filterName in
//                guard let filter = CIFilter(name: filterName) else{
//                    return
//                }
//                let inputs: [String] = filter.inputKeys.map{ inputKey in
//                    let information = filter.parameterInformation(forInputKey: inputKey)
//                    let type = (information[kCIAttributeClass].map { "\($0)" } ?? "")
//                    let defaultValue = information[kCIAttributeDefault]
//                    if let value = defaultValue as? NSNumber {
//                        return "\(inputKey): \(type) = \(value)"
//                    } else if let value = defaultValue as? NSString {
//                        return "\(inputKey): \(type) = \"\(value)\""
//                    } else {
//                        return "\(inputKey): \(type)"
//                    }
//                }
//                let filterDisplayName = filter.displayName ?? filterName
//                printer.print("")
//                if let url = filter.referenceDocumentationUrl {
//                    // I don't know why, but SeeAlso does not work on my Xcode.
//                    // printer.print("/// \(filterDisplayName)")
//                    // printer.print("/// - SeeAlso: [Reference/\(filterDisplayName)](\(url))")
//                    printer.print("/// [\(filterDisplayName)](\(url))")
//                } else {
//                    printer.print("/// \(filterDisplayName)")
//                }
//                
//        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return BuildInfilterList.count
        
//        return filterList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var filtername = BuildInfilterList[indexPath.row]
        
        if filtername.isEmpty {
            filtername = "No Effect"
        }

        // Configure the cell...
        cell.textLabel?.text = filtername
        
        cell.accessoryType = UITableViewCellAccessoryType.none
        
        if indexPath.row == selectedIndex {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let myDelegate = delegate {
            myDelegate.FilterListViewController(self, didSelectFilter: self.BuildInfilterList[indexPath.row], index: indexPath.row)
        }
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
