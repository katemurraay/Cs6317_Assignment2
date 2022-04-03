//
//  DataParser.swift
//  PlayerApp
//
//  Created by Kate Murray on 15/02/2022.
//

//Parsing XML into Swift Object

import Foundation
import UIKit
import CoreData

class DataParser: XMLParser {
  
    var elementName: String = String()
    
    
   
    
    //Player Elements
    var name = String(); var id = String(); var team = String(); var image = String()
    var age = String(); var position = String(); var dob = String();
    var appearances = String(); var country = String(); var dateJoined = String(); var url = String(); var totalGoals = String();
    
    //Match Elements
    var date = String(); var tackles = String(); var duels = String();
    var duelsWon = String(); var redCard = String(); var yellowCard = String();
    var passes = String(); var noPasses = String(); var tacklesWon = String();
    var intercepts = String(); var interceptsWon = String(); var minutesPlayed = String()
    var p: Player = Player()
    
    var match = false
    override init (data: Data){
        super.init(data: data)
        self.delegate = self
       
    }
    
    func setPlayer(p: Player){
        self.p = p
    }
}


extension DataParser: XMLParserDelegate
{
   
 
    /* [1]
     Code below is based on: Web Article - "Parse XML iOS Tutorial", Arthur Knopper, 2019
     IOSCreator,
     https://www.ioscreator.com/tutorials/parse-xml-ios-tutorial
     */
   
    //Start Element
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            if elementName == "player" {
                match = false
                id = String()
                name = String()
                image = String()
                team = String()
                age = String()
                dob = String()
                position = String()
                appearances = String()
                country = String()
                dateJoined = String()
                url = String()
                totalGoals = String()
                
            } else if elementName == "match"{
                match = true
                name = String()
                id = String()
                date = String()
                tackles = String()
                duels = String()
                duelsWon = String()
                tacklesWon = String()
                passes = String()
                noPasses = String()
                redCard = String()
                yellowCard = String()
                intercepts = String()
                interceptsWon = String()
                minutesPlayed = String()
            }
        
        self.elementName = elementName
    }
    
    //End Element
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.persistentContainer.viewContext
        if elementName == "player" {
            

            let tmp = NSEntityDescription.insertNewObject(forEntityName: "Player", into: context) 
            tmp.setValue(id, forKey: "id")
            tmp.setValue(name, forKey: "name")
            tmp.setValue(age, forKey: "age")
            tmp.setValue(team, forKey: "team")
            tmp.setValue(image, forKey: "image")
            tmp.setValue(url, forKey: "url")
            tmp.setValue(country, forKey: "country")
            tmp.setValue(position, forKey: "position")
            tmp.setValue(dateJoined, forKey: "joinedDate")
            tmp.setValue(dob, forKey: "dob")
            tmp.setValue(totalGoals, forKey: "totalGoals")
            tmp.setValue(appearances, forKey: "appearances")
        } else if  elementName == "match"{
            let tmp = NSEntityDescription.insertNewObject(forEntityName: "Match", into: context)
            tmp.setValue(name, forKey: "name")
            tmp.setValue(date, forKey: "date")
            tmp.setValue(passes, forKey: "passes")
            tmp.setValue(noPasses, forKey: "noPasses")
            tmp.setValue(minutesPlayed, forKey: "minutesPlayed")
            tmp.setValue(redCard, forKey: "redCards")
            tmp.setValue(yellowCard, forKey: "yellowCards")
            tmp.setValue(duels, forKey: "duels")
            tmp.setValue(duelsWon, forKey: "duelsWon")
            tmp.setValue(tackles, forKey: "tackles")
            tmp.setValue(tacklesWon, forKey: "tacklesWon")
            tmp.setValue(id, forKey: "playerId")
            
        }
        do {try context.save()}
        catch  {print("Error")}
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if(!data.isEmpty) {
            if(match){
                switch(self.elementName){
                    case ("playerId"): id += data
                    case ("name"): name += data
                    case ("date"): date += data
                    case ( "passes"): passes += data
                    case ("nopasses"): noPasses += data
                    case ("tackles"): tackles += data
                    case ("tacklesWon"): tacklesWon += data
                    case ("duels"): duels += data
                    case("duelsWon"): duelsWon += data
                    case("interceptions"): intercepts += data
                    case("interceptionsWon"): interceptsWon += data
                    case("minutesPlayed"): minutesPlayed += data
                    case("redCard"): redCard += data
                    case("yellowCard"): yellowCard += data
                    default:
                        print(data)
                }
            } else{
                switch(self.elementName){
                    case("name"): name += data
                    case ("id"): id += data
                    case ("team"): team += data
                    case ( "age"): age += data
                    case ("image"): image += data
                    case("position"): position += data
                    case ("appearances"): appearances += data
                    case ("dob"): dob += data
                    case("country"): country += data
                    case("url"): url += data
                    case("joinedDate"): dateJoined += data
                    case("totalGoals"): totalGoals += data
                    default:
                        print(data)
                }
                //[1] END
            
        }
    }
    }
    
}

