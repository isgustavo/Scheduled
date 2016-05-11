//
//   AirlineTableViewController.swift
//   Traveling
//
//   Created by Gustavo F Oliveira on 4/16/16.
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

import UIKit

class AirlineTableViewController: UITableViewController {

    var delegate: AirlineDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let background = UIImage(named: "Blue-Sky")
        //let imageView = UIImageView(image: background)
        //imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        //let blurEffect = UIBlurEffect(style: .Light)
        //let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        //blurredEffectView.frame = view.bounds
        //imageView.addSubview(blurredEffectView)
        
        //self.tableView.backgroundView = imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        // This changes the header background
        view.tintColor = UIColor(red: CGFloat(64.0/255), green: CGFloat(64.0/255), blue: CGFloat(85.0/255), alpha: CGFloat(0.0))


    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let rowSelected: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        delegate.selectedAirline(rowSelected.textLabel!.text!)
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}
