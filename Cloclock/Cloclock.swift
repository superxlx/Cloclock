import Foundation
import CoreData

class Cloclock: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var label: String
    @NSManaged var music: String
    @NSManaged var on: AnyObject
    @NSManaged var repeat: AnyObject

}
