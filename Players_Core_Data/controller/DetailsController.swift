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
 
       
    
    
    

    
  



    func getImage(imageName: String) -> UIImage{
        //get image from documents
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imagePath = documentsPath.appendingPathComponent(imageName)
        //make the image
        let image = UIImage(contentsOfFile: imagePath)
        return image!
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }


}

