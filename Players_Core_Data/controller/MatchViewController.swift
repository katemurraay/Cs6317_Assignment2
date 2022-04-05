//
//  NavigationController.swift
//  Players_Core_Data
//
//  Created by Kate Murray on 31/03/2022.
//

import UIKit
import CoreData
class MatchViewController: UIViewController{
    var p :Player!
    var mManagedObject: Match!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    var pEntity : NSEntityDescription! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = tabBarController as! PlayerTabController
        p = tabBar.p
        makeRequest(playerId: p.id!)
        if mManagedObject != nil {
            //date formatting
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "dd/MM/yyyy"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"

            let date: Date? = dateFormatterGet.date(from: mManagedObject.date!)
            
            
            let strDate: String? = dateFormatter.string(from: date!)
            var totalPasses = Int(mManagedObject.passes!)! as Int
            totalPasses  += Int(mManagedObject.noPasses!)!
            
            let strTotalPasses = String(totalPasses)
            //string formatting
            let passes = formatStrings(f: mManagedObject.passes!, f2: strTotalPasses)
            let tackles = formatStrings(f: mManagedObject.tacklesWon!, f2: mManagedObject.tackles!)
            let duels = formatStrings(f: mManagedObject.duelsWon!, f2: mManagedObject.duels!)
            nameLabel.text = mManagedObject.name
            passesLabel.text = passes
            duelsLabel.text = duels
            tacklesLabel.text = tackles
            dateLabel.text = strDate
            minutesLabel.text = mManagedObject.minutesPlayed
            redcardLabel.text = mManagedObject.redCards
            yellowcardLabel.text = mManagedObject.yellowCards
            
        } else{
            nameLabel.text = "NO MATCH DATA FOUND"
        }

    }
    func formatStrings(f: String, f2: String)-> String{
        return String("\(f) / \(f2)")
    }
    func makeRequest(playerId: String){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Match")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "playerId == %@", playerId)
    

        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
               mManagedObject = (results.first as! Match)
                print("found Fav")
            }}
            catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
    }
    @IBOutlet weak var redcardLabel: UILabel!
  
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var duelsLabel: UILabel!
    @IBOutlet weak var tacklesLabel: UILabel!
    @IBOutlet weak var passesLabel: UILabel!
    /*
     @IBOutlet weak var yellowcardLabel: UILabel!
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var yellowcardLabel: UILabel!
}
