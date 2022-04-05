//
//  PlayerCollectionViewCell.swift
//  ManUnitedApp
//
//  Created by Kate Murray on 15/03/2022.
//

import UIKit
import CoreData
class AddPlayerViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPickerView {
            return country_list.count
        } else{
            return positions.count
        }
    }
    
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
         
       }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == countryPickerView {
            return country_list[row]
        } else{
            return positions[row]
        }
       }
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var dobDatePicker: UIDatePicker!
    
    @IBOutlet weak var numberTextField: UITextField!
    
    @IBOutlet weak var uploadImageView: UIImageView!
    
    @IBOutlet weak var positionPickerView: UIPickerView!
    
    @IBOutlet weak var countryPickerView: UIPickerView!
    
    
    //core data objects and functions
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var pEntity : NSEntityDescription! = nil
    var pManagedObject : Player!
    
    func addPlayer(){
        //create a new managed object
        pEntity = NSEntityDescription.entity(forEntityName: "Player", in: context)
        pManagedObject = Player(entity: pEntity, insertInto:context)
        
        //fill pManaged object with data from fields
        pManagedObject.name = nameTextField.text
        pManagedObject.id =  numberTextField.text
        
        let image = uploadImageView.image
        if (image != nil) {
            let name = nameTextField.text
            let fullNameArr = name!.components(separatedBy: " ")
            var imageName = fullNameArr[0]
            imageName = imageName.lowercased() + ".png"
            pManagedObject.image = imageName
            putImage(imageName: imageName)
        }
        let now = Date()
        let birthday: Date = dobDatePicker.date
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        let strAge = String(age)
        pManagedObject.age = strAge
        
        let dateFormatter = DateFormatter()

         dateFormatter.dateFormat = "dd/MM/yyyy"
        let dob = dateFormatter.string(from: dobDatePicker.date)
        
        pManagedObject.dob = dob
        let position = positions[positionPickerView.selectedRow(inComponent: 0)]
        pManagedObject.position = position
        let country = country_list[countryPickerView.selectedRow(inComponent: 0)]
        
        pManagedObject.country = country
        pManagedObject.appearances = "0"
        pManagedObject.totalGoals = "0"
        pManagedObject.team = "Manchester United"
        pManagedObject.url = "https://www.manutd.com/en/players-and-staff/First-Team"
        let date = NSDate()
        let dateJoined = dateFormatter.string(from: date as Date)
        pManagedObject.joinedDate = dateJoined
        
        //context saves
        do{ try context.save()
        }catch{
            print("context cannot save")
        }
    }
    
    
    
    
    //image functions:
    func getImage(imageName: String){
        //get image from documents
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imagePath = documentsPath.appendingPathComponent(imageName)
        //make the image
        let image = UIImage(contentsOfFile: imagePath)
        uploadImageView.image = image
    }
    
    func putImage(imageName: String){
        //get image from documents
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imagePath = documentsPath.appendingPathComponent(imageName)
        //get image from imageView
        let image = uploadImageView.image
        let data = image?.pngData()
        //save data with file manager
        let manager = FileManager.default
        manager.createFile(atPath: imagePath, contents: data, attributes: nil)
    }
    
    //Image Picker Controller
    let pickerController  = UIImagePickerController()
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        uploadImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func AddImage(_ sender: Any) {
        //setup Picker Controller
        pickerController.delegate = self
        pickerController.sourceType = .savedPhotosAlbum
        pickerController.allowsEditing = false
    
        //start/ present picker
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func SavePlayer(_ sender: Any) {
        if (numberTextField.text != "" && nameTextField.text != ""){
        
            addPlayer()
            navigationController?.popViewController(animated: true)
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.positionPickerView.delegate = self
        self.positionPickerView.dataSource = self
        self.countryPickerView.delegate = self
        self.countryPickerView.dataSource = self
        
    }
    
    
    
    
    
    var positions = ["Goalkeeper", "Midfielder", "Forward", "Defender"]
    
    //https://css-tricks.com/snippets/javascript/array-of-country-names/
    var country_list = ["Afghanistan","Albania","Algeria","Andorra","Angola","Anguilla","Antigua &amp; Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnia &amp; Herzegovina","Botswana","Brazil","British Virgin Islands","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Cape Verde","Cayman Islands","Chad","Chile","China","Colombia","Congo","Cook Islands","Costa Rica","Cote D Ivoire","Croatia","Cruise Ship","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Estonia","Ethiopia","Falkland Islands","Faroe Islands","Fiji","Finland","France","French Polynesia","French West Indies","Gabon","Gambia","Georgia","Germany","Ghana","Gibraltar","Greece","Greenland","Grenada","Guam","Guatemala","Guernsey","Guinea","Guinea Bissau","Guyana","Haiti","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Isle of Man","Israel","Italy","Jamaica","Japan","Jersey","Jordan","Kazakhstan","Kenya","Kuwait","Kyrgyz Republic","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macau","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Mauritania","Mauritius","Mexico","Moldova","Monaco","Mongolia","Montenegro","Montserrat","Morocco","Mozambique","Namibia","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","Norway","Oman","Pakistan","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Puerto Rico","Qatar","Reunion","Romania","Russia","Rwanda","Saint Pierre &amp; Miquelon","Samoa","San Marino","Satellite","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","South Africa","South Korea","Spain","Sri Lanka","St Kitts &amp; Nevis","St Lucia","St Vincent","St. Lucia","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Timor L'Este","Togo","Tonga","Trinidad &amp; Tobago","Tunisia","Turkey","Turkmenistan","Turks &amp; Caicos","Uganda","Ukraine","United Arab Emirates","United Kingdom","Uruguay","Uzbekistan","Venezuela","Vietnam","Virgin Islands (US)","Yemen","Zambia","Zimbabwe"]
}
