//
//  FoaasOperationsTableViewController.swift
//  BiteYourThumb
//
//  Created by Tong Lin on 11/26/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import UIKit

class FoaasOperationsTableViewController: UITableViewController {
    @IBOutlet weak var doneBarButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Operations"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoaasDataManager.shared.operations?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OperationCellIdentifier", for: indexPath)
        
        if let operation = FoaasDataManager.shared.operations?[indexPath.row]{
            cell.textLabel?.text = operation.name
        }

        return cell
    }
    
    @IBAction func doneDidTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailOperationIdentifier"{
            if let destination = segue.destination as? FoaasPreviewViewController{
                if let cell = sender as? UITableViewCell{
                    destination.operation = FoaasDataManager.shared.operations?[(tableView.indexPath(for: cell)?.row)!]
                }
            }
        }
        
    }

}
