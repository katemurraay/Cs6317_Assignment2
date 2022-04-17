//
//  Player+CoreDataClass.swift
//  Players_Core_Data
//
//  Created by Kate Murray on 31/03/2022.
//
//

import Foundation
import CoreData
import UIKit

class FavouriteTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    //core data object and functions
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    var pEntity : NSEntityDescription! = nil
    var fManagedObject : Favourite!
   
    
    func makeRequest(userId: String){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favourite")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "userId == %@" ,userId)
    

        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
               fManagedObject = (results.first as! Favourite)
                print("found Fav")
            }}
            catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.makeRequest(userId: "user_2")
            self.tableView.reloadData()
        }
    }
    
    func removeAllData(){
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "Favourite")

        
        let deleteRequest = NSBatchDeleteRequest(
            fetchRequest: fetchRequest
        )

     
        deleteRequest.resultType = .resultTypeObjectIDs

        // Get a reference to a managed object context
        

        // Perform the batch delete
        let batchDelete = try! context.execute(deleteRequest)
            as? NSBatchDeleteResult
        

        guard let deleteResult = batchDelete?.result
            as? [NSManagedObjectID]
            else { return }

        let deletedObjects: [AnyHashable: Any] = [
            NSDeletedObjectsKey: deleteResult
        ]

        // Merge the delete changes into the managed
        // object context
        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: deletedObjects,
            into: [context]
        )
    }
    


    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if fManagedObject != nil {
            let players = fManagedObject.player?.allObjects
            return players!.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavouriteCell

        // Configure the cell...
       
        if fManagedObject != nil {
            let players = fManagedObject.player?.allObjects
                if players != nil {
                    
                    let player = players![indexPath.row] as! Player
                    //fill the cell with data
                    cell.positionLabel.text = player.position
                    cell.nameLabel.text = player.name
                   
                    let view = cell.imageBackground
                    view?.backgroundColor = .white
                    cell.playerImage.contentMode = UIView.ContentMode.scaleAspectFill
                    cell.playerImage.frame.size.width = 150
                    cell.playerImage.frame.size.height = 150
                    let img  = UIImage(named: player.image!)
                    if img != nil {
                        cell.playerImage.image = img
                    } else{
                        
                        cell.playerImage.image = getImage(imageName: player.image!)
                    }
                    cell.playerImage.layer.cornerRadius = 75
                    cell.playerImage.clipsToBounds = true
                    cell.playerImage.layer.borderWidth = 3
                    cell.playerImage.layer.borderColor = UIColor.orange.cgColor
                    view?.addSubview(cell.playerImage)
                    cell.imageBackground = view
                    
                }
            
           
        }
        
        return cell
    }
    
    func getImage(imageName: String) -> UIImage{
        //get image from documents
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imagePath = documentsPath.appendingPathComponent(imageName)
        //make the image
        let image = UIImage(contentsOfFile: imagePath)
        return image!
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the managedObject from indexPath
            let players = fManagedObject.player?.allObjects
            let player = players![indexPath.row] as! Player
            fManagedObject.removeFromPlayer(player)
            do{ try context.save()
            }catch{
                print("context cannot save")
            }
            
            makeRequest(userId: "user_2")
            tableView.reloadData()
        }
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue"{
            //get the new viewcontroller using sege.destination
            let indexPath = tableView.indexPath(for: sender as! FavouriteCell)
            let players = fManagedObject.player?.allObjects
                if players != nil {
                    let destination = segue.destination as! PlayerTabController
                    let player = players![indexPath!.row] as! Player
                    destination.p = player
            
          
          
        }
    }
    }
    

}

