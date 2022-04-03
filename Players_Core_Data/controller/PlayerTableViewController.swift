//
//  PlayerTableViewController.swift
//  Players_Core_Data
//
//  Created by Kate Murray on 31/03/2022.
//

import UIKit
import CoreData

class PlayerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    //core data object and functions
    var fetchObjects =  NSArray()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var positions: [String] = ["Defender", "Midfielder", "Forward", "Goalkeeper"]
    var pEntity : NSEntityDescription! = nil
    var pManagedObject : Player!
    var frc : NSFetchedResultsController <NSFetchRequestResult>! = nil
    
    func makeRequest()->NSFetchRequest<NSFetchRequestResult>{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        let sorter = NSSortDescriptor(key: "position", ascending: true)
        request.sortDescriptors = [sorter]
        return request
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
     
        
        
    }
    
    func downloadMatch() {
        DispatchQueue.global(qos: .background).async {
            if(self.makeMatchRequest()){
                print("match populated")
            } else{
                self.fetchMatches()
                         
            }
        }
    }
    
    
    func fetchMatches(){
        if let path = Bundle.main.path(forResource: "matches", ofType: "xml") {
            let xmlData = try! NSData(contentsOfFile: path) as Data
            let parser = DataParser (data: xmlData)
           
            
            if parser.parse(){
                //make frc and set it up with the table
                print("match data Collected")
            }
           
            
        }
    }
    
    func makeMatchRequest()-> Bool{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Match")
        fetchRequest.fetchLimit =  1
    

        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                print("found Match")
                return true
            }}
            catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        return false
    }
    
    func makeQueryRequest(query: String)->NSFetchRequest<NSFetchRequestResult>{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        let sorter = NSSortDescriptor(key: "id", ascending: true)
        request.predicate = NSPredicate(format: "%K == %@ OR %K == %@", argumentArray:["name", query, "position", query])
        request.sortDescriptors = [sorter]
        return request
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
   
        fetchPlayerData()
        searchBar.delegate = self
        downloadMatch()
    }

    func fetchPlayerData(query: String = ""){
        if query == "" {
            frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            
        } else {
            frc = NSFetchedResultsController(fetchRequest: makeQueryRequest(query: query), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }
        
        frc.delegate = self
        
        //fetch
        do{
            try frc.performFetch()
            if frc.sections![0].numberOfObjects == 0{
                loadData()
            }
        }
        catch{
            print("frc cannot fetch")
        }
        
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    func removeAllData(){
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "Player")

        
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
    func loadData(){
        
        if let path = Bundle.main.path(forResource: "players", ofType: "xml") {
            let xmlData = try! NSData(contentsOfFile: path) as Data
            let parser = DataParser (data: xmlData)
            
            if parser.parse(){
                //make frc and set it up with the table
                fetchPlayerData()
            }
           
            
        }
    }

    
    
   
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return frc.sections![section].numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerCell

        // Configure the cell...
       
        pManagedObject = frc.object(at: indexPath) as? Player
        //fill the cell with data
        cell.positionLabel.text = pManagedObject.position
        cell.nameLabel.text = pManagedObject.name
        let img = UIImage(named: pManagedObject.image!)
        if(img != nil ){
            cell.playerImage.image = img
        } else {
            cell.playerImage.image = getImage(imageName: pManagedObject.image!)
        }
        cell.numberLabel.text = pManagedObject.id
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func getImage(imageName: String) -> UIImage{
        //get image from documents
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imagePath = documentsPath.appendingPathComponent(imageName)
        //make the image
        let image = UIImage(contentsOfFile: imagePath)
        return image!
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the managedObject from indexPath
            pManagedObject = frc.object(at: indexPath) as? Player
            context.delete(pManagedObject)
            
            //reload data
            tableView.reloadData()
            do { try context.save()}
                catch {print("Cannot delete")}
            
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
            
            let destination = segue.destination as! PlayerTabController
            let indexPath = tableView.indexPath(for: sender as! PlayerCell)
            pManagedObject = frc.object(at: indexPath!) as? Player
          
            destination.p = pManagedObject
        }
    }
    

}

extension PlayerTableViewController: UISearchBarDelegate{

    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search")
        searchBar.resignFirstResponder()
        let query  = searchBar.text! as String
        if query != "" {
            fetchPlayerData(query: query)
            tableView.reloadData()
        
        } else {
            fetchPlayerData()
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchPlayerData()
        tableView.reloadData()
    }
    

    
    }

