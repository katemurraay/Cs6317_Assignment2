//
//  ViewController.swift
//  Players_Core_Data
//
//  Created by Kate Murray on 31/03/2022.
//

import UIKit
import CoreData

class DetailsController: UIViewController {

    
    var p: Player!
    var imgCountry = String()
    
    @IBOutlet weak var totalGoalsLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
   
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var joinedInLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var appearancesLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var playerImage: UIImageView!
    var favourite: Favourite!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tabBar = tabBarController as! PlayerTabController
        p = tabBar.p
        
        if p != nil {
            
            numberLabel.text = p.id
            nameLabel.text = p.name
            positionLabel.text = p.position
            /* [1]
             Code below is based on: StackOverflow Answer to Question:"Date Format in Swift", Answered by: LorenzeOliveto,
             https://stackoverflow.com/a/43434964
             */
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd/MM/yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"

        let joinedDate: Date? = dateFormatterGet.date(from: p.joinedDate!)
            let dob: Date? = dateFormatterGet.date(from: p.dob!)
        
        let strJoinedDate: String? = dateFormatter.string(from: joinedDate!)
        let strDob: String? = dateFormatter.string(from: dob! )
            
        //[1] END
        joinedInLabel.text = strJoinedDate
        dobLabel.text = strDob
            appearancesLabel.text = p.appearances! as String
            ageLabel.text = p.age
           goalsLabel.text = p.totalGoals!
        
        if(p.country!.contains(" ")){
            let arrCountry = p.country!.components(separatedBy: " ")
            imgCountry = arrCountry[0].lowercased() + "_" + arrCountry[1].lowercased() + ".png"
        } else {
            imgCountry = p.country!.lowercased() + ".png"
        }
            let image = UIImage(named: p.image!)
            if image != nil {
                playerImage.image = image
            } else{
                playerImage.image = getImage(imageName: p.image!)
            }
        countryImage.image = UIImage(named: imgCountry)
        
        if p.position != "Goalkeeper"{
            totalGoalsLabel.text = "Total Goals"
        } else {
            totalGoalsLabel.text = "Clean Sheets"
        }
        
        }
        
        
        
    }
    @IBAction func addFav(_ sender: Any) {
        addToFavourite(pManagedObject: p)
        
        /* [1]
         Code bwlow is based on: Stackoverflow answer to Question: 'popping a view controller in different tab',
         Gurprett Singh, https://stackoverflow.com/a/56472973
         */
        guard let VCS = self.navigationController?.viewControllers else {return }
        for controller in VCS {
            if controller.isKind(of: UITabBarController.self) {
                let tabVC = controller as! UITabBarController
                tabVC.selectedIndex = 1
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        //[1] END
      
    }
    
    
    func addToFavourite(pManagedObject: Player){
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.persistentContainer.viewContext
        
        
        
        if checkFavouriteExists(userId: "user_2", context: context){
            let isPlayerPresent = (favourite.player?.contains(pManagedObject))!  
            if (isPlayerPresent){
                print("Already Favourited")
                
            } else{
                favourite.addToPlayer(pManagedObject)
                do {try context.save()}
                catch  {print("Error")}
                print("PlayerAdded")
            }
            
        } else{
            
            let fEntity = NSEntityDescription.entity(forEntityName: "Favourite", in: context)
            let newFavourite = Favourite(entity: fEntity!, insertInto:context)
            newFavourite.userId = "user_2"
            newFavourite.addToPlayer(pManagedObject)
            
            print("Added Favourite")
            do {try context.save()}
            catch  {print("Error")}
        }
        
    }

    
    func checkFavouriteExists(userId: String, context: NSManagedObjectContext)-> Bool{
        //https://stackoverflow.com/a/56000130
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
            fetchRequest.fetchLimit =  1
            fetchRequest.predicate = NSPredicate(format: "userId == %@" ,userId)
        

            do {
                if let results = try context.fetch(fetchRequest).first{
                    favourite  = (results as! Favourite)
                    return true
                   
                }
                return false
            
            }catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                return false
            }
        
    
}



    func getImage(imageName: String) -> UIImage{
        //get image from documents
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imagePath = documentsPath.appendingPathComponent(imageName)
        //make the image
        let image = UIImage(contentsOfFile: imagePath)
        return image!
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favouriteSegue"{
            let destination = segue.destination as! FavouriteTableViewController

        }
    }


}

