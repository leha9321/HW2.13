//
//  StorageManger.swift
//  2.13
//
//  Created by Алексей Трофимов on 10.01.2022.
//

import CoreData
class StorageManager{
    
    static let shared = StorageManager()
    
    var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "__13")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init(){}
    
    func fetchData() -> [Task]{
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            return try viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
            return []
        }
    }
    
    func save(_ taskName: String, completion: (Task)-> Void){
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: persistentContainer.viewContext) else {return}
        
        let task = NSManagedObject(entity: entity, insertInto: viewContext) as! Task
        task.name = taskName
        completion(task)
        saveContext()
    }
    
    func edit(_ task: Task, newName: String) {
        task.name = newName
        saveContext()
    }
    
    func delete(_ task: Task){
        viewContext.delete(task)
        saveContext()
    }
    
    func saveContext () {
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
