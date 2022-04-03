//
//  PlayerTabController.swift
//  ManUnitedApp
//
//  Created by Kate Murray on 07/03/2022.
//

import UIKit
import CoreData

class PlayerTabController: UITabBarController {
    
    var p: Player!
    var favourite: Favourite!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
