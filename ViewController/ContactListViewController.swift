//
//  ViewController.swift
//  Tableviewdemo
//
//

import UIKit
import CoreData

class ContactListViewController: UITableViewController {
    
    let cellId = "cellId"
    var contacts = [Contact]()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var manageObjectContext: NSManagedObjectContext?
    override func viewDidLoad() {
        super.viewDidLoad()
        manageObjectContext = appDelegate?.persistentContainer.viewContext
//        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
        loadContactItem()
    }
    func loadContactItem(){
        let contactRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "fullname", ascending: true)
        contactRequest.sortDescriptors = [sortDescriptor]
        do {
        contacts = try manageObjectContext?.fetch(contactRequest) ?? []
        } catch {
            print ("Failed to load contacts, error",error)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addContact" {
            guard let navigationController  = segue.destination as? UINavigationController,
                  let controller = navigationController.topViewController as? ContactDetailViewController
                    else {return}
            controller.delegate = self
            controller.moc = manageObjectContext
        } else if segue.identifier == "viewContact" {
            guard let navigationController  = segue.destination as? UINavigationController,
                  let controller = navigationController.topViewController as? ContactDetailViewController
                    else {return}
            controller.delegate = self
            controller.moc = manageObjectContext
            if let indexPath = tableView.indexPath(for: sender as! ContactCell){
                controller.itemToEdit = contacts[indexPath.row]
            }
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        cell.contactItem = contacts[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteContact = contacts[indexPath.row]
            manageObjectContext?.delete(deleteContact)
            contacts.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            appDelegate?.saveContext()
        }
    }

}
extension ContactListViewController: ContactDetailViewControllerDelegate {
    func didAddContactItem(item: Contact, from viewController: UIViewController) {
        contacts.append(item)
        appDelegate?.saveContext()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    func didEditContactItem(item: Contact, from viewController: UIViewController) {
        if let index = contacts.index(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? ContactCell {
                cell.contactItem = item
                appDelegate?.saveContext()
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
