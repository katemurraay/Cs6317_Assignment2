//
//  Player+CoreDataProperties.swift
//  Players_Core_Data
//
//  Created by Kate Murray on 31/03/2022.
//
//

import Foundation
import CoreData
import UIKit

class UpdateViewController: UIViewController, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return positions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return positions[row]
    }
    var name = String()
    var position = String()
    var totalGoals = String()
    var appearances = String()
    var dob = String()
    var pimage = String()
    var page = String()
    var imageChanged = false
    var positions = ["Goalkeeper", "Midfielder", "Forward", "Defender"]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var pEntity : NSEntityDescription! = nil
    var pManagedObject : Player!
    
    let pickerController  = UIImagePickerController()
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        playerImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func putImage(imageName: String){
        //get image from documents
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imagePath = documentsPath.appendingPathComponent(imageName)
        //get image from imageView
        let image = playerImage.image
        let data = image?.pngData()
        //save data with file manager
        let manager = FileManager.default
        manager.createFile(atPath: imagePath, contents: data, attributes: nil)
    }
    
    
    
    
    @IBAction func changeImage(_ sender: Any) {
        //setup Picker Controller
        pickerController.delegate = self
        pickerController.sourceType = .savedPhotosAlbum
        pickerController.allowsEditing = false
        imageChanged = true
        //start/ present picker
        present(pickerController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        positionPicker.delegate = self
        positionPicker.dataSource = self
        let index = positions.firstIndex(of: pManagedObject.position! )!
        positionPicker.selectRow( index, inComponent: 0, animated: false)
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dob = dateFormatter.date(from: pManagedObject.dob!)!
        dobPicker.setDate(dob, animated: false)
        
        nameTextField.text = pManagedObject.name
        let image = UIImage(named: pManagedObject.image!)
        if image != nil{
            playerImage.image = image
            
        }
        else {
            playerImage.image = getImage(imageName: pManagedObject.image!)
        }
        
        goalsTextField.text = pManagedObject.totalGoals
        appearancesTextField.text = pManagedObject.appearances
        
    }
    
    func getImage(imageName: String) -> UIImage{
        //get image from documents
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imagePath = documentsPath.appendingPathComponent(imageName)
        //make the image
        let image = UIImage(contentsOfFile: imagePath)
        return image!
    }
    
    
    
    @IBAction func updatePlayer(_ sender: Any) {
        name = nameTextField.text!
        appearances = appearancesTextField.text!
      
        position = positions[positionPicker.selectedRow(inComponent: 0)]
        
        
        let image = playerImage.image
        if (imageChanged && image != nil) {
            var imageName = pManagedObject.id!
            imageName = imageName + ".png"
            pimage = imageName
            putImage(imageName: imageName)
        } else{
            pimage = pManagedObject.image!
        }
        let now = Date()
        let birthday: Date = dobPicker.date
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        page = String(age)
        totalGoals = goalsTextField.text!
        let dateFormatter = DateFormatter()

         dateFormatter.dateFormat = "dd/MM/yyyy"
        dob = dateFormatter.string(from: dobPicker.date)
       
        savePlayer()
        
        /* [1]
         Code bwlow is based on: Stackoverflow answer to Question: 'popping a view controller in different tab',
         Gurprett Singh, https://stackoverflow.com/a/56472973
         */
        guard let VCS = self.navigationController?.viewControllers else {return }
        for controller in VCS {
            if controller.isKind(of: UITabBarController.self) {
                let tabVC = controller as! UITabBarController
                tabVC.selectedIndex = 0
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        //[1] END
            
        
    }
    @IBOutlet weak var appearancesTextField: UITextField!
    @IBOutlet weak var positionPicker: UIPickerView!
    @IBOutlet weak var dobPicker: UIDatePicker!
    @IBOutlet weak var goalsTextField: UITextField!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    /*
     Code below is based on StackOverflow Answer to Question: "How do you update a CoreData entry that has already been saved in Swift?",
     Devbot10,https://stackoverflow.com/a/48089530
    */
    func savePlayer(){
        //fill pManaged object with data from fields
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        fetchRequest.predicate = NSPredicate(format: "id = %@ ", pManagedObject.id!)
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(name, forKey: "name")
                results![0].setValue(pimage, forKey: "image")
                results![0].setValue(appearances, forKey: "appearances")
                results![0].setValue(position, forKey: "position")
                results![0].setValue(totalGoals, forKey: "totalGoals")
                results![0].setValue(dob, forKey: "dob")
                results![0].setValue(page, forKey: "age")
            }
        } catch{
            print("Fetch Failed: \(error)")
        }
       
       
        //context saves
        do{ try context.save()
        }catch{
            print("context cannot save")
        }
        
      
        
    }
    
    
   

}
