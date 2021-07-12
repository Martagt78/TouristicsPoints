//
//  Details+CoreDataProperties.swift
//  TouristicPoints
//
//  Created by Marta García on 12/7/21.
//

import CoreData
import Foundation

extension Details {
    @NSManaged var idDetails: String
    @NSManaged var titleDetails: String
    @NSManaged var geocoordinatesDetails: String
    @NSManaged var address: String
    @NSManaged var descriptionplace: String
    @NSManaged var email: String
    @NSManaged var phone: String
    @NSManaged var transport: String


    
    static func createWith(id: String, title: String, geocoordinates: String, address: String, description: String, email: String, phone: String, transport: String, using viewContext: NSManagedObjectContext) {
        let detail = Details(context: viewContext)
        detail.idDetails = id
        detail.titleDetails = title
        detail.geocoordinatesDetails = geocoordinates
        detail.address = address
        detail.descriptionplace = description
        detail.email = email
        detail.phone = phone
        detail.transport = transport
        
        do {
            try viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    
    //Recupera todos los datos que tenemos guardados
    @nonobjc public class func basicDetailFetchRequest() -> NSFetchRequest<Details> {
        return NSFetchRequest<Details>(entityName: "Details")
    }
    
}
