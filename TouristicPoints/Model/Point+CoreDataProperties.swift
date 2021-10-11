//
//  Point+CoreDataProperties.swift
//  TouristicPoints
//
//  Created by Marta García on 12/7/21.
//

import CoreData

extension Point {
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var geocoordinates: String
    
    
    static func createWith(id: String, title: String, geocoordinates: String, using viewContext: NSManagedObjectContext) {
        let point = Point(context: viewContext)
        point.id = id
        point.title = title
        point.geocoordinates = geocoordinates
        
        do {
            try viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    
    //Recupera todos los datos que tenemos guardados
    @nonobjc public class func basicFetchRequest() -> NSFetchRequest<Point> {
        return NSFetchRequest<Point>(entityName: "Point")
    }
    
}
