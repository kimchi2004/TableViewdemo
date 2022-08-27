//
//  AddContactViewController.swift
//  Tableviewdemo
//
//

import Foundation
import UIKit
import  CoreData

protocol ContactDetailViewControllerDelegate: AnyObject {
    func  didAddContactItem(item: Contact, from viewController : UIViewController)
    func didEditContactItem(item: Contact, from viewController: UIViewController)
}

class ContactDetailViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var phonenumber: UITextField!
    @IBOutlet weak var address: UITextField!
    
    let imagePicker = UIImagePickerController()
    weak var delegate: ContactDetailViewControllerDelegate?
    var itemToEdit: Contact?
    var moc: NSManagedObjectContext?
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let name = fullname.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let phone = phonenumber.text?.trimmingCharacters(in: .whitespacesAndNewlines),
        !name.isEmpty, !phone.isEmpty
        else {
            showError(message: "Please input name and phone number")
            return }
        guard let profileimage = avatar.image else { return }
        let theAddress = address.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let moc = self.moc else { return}
        if let itemToEdit = self.itemToEdit {
            itemToEdit.avatar = profileimage.jpegData(compressionQuality: 0.7)
            itemToEdit.fullname = name
            itemToEdit.phoneNumber = phone
            itemToEdit.address = theAddress
            delegate?.didEditContactItem(item: itemToEdit, from: self)
        }
        else{
        let contact = Contact(context: moc)
        
        contact.avatar = profileimage.jpegData(compressionQuality: 0.7)
        contact.fullname = name
        contact.phoneNumber = phone
        contact.address = theAddress
//        let contact = ContactItem(profileImage: profileimage, phoneNumber: phone, fullName: name, address: theAddress)
        delegate?.didAddContactItem(item: contact, from: self)
    }
        
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupavt()
        imagePicker.delegate = self
        if let item = itemToEdit {
            if let progileImageData = item.avatar{
                avatar.image = UIImage(data: progileImageData)
            }
            fullname.text = item.fullname
            phonenumber.text = item.phoneNumber
            address.text = item.address
        }
    }
    func  setupavt() {
        avatar.layer.borderWidth =  1
        avatar.layer.borderColor =  UIColor.darkGray.cgColor
        avatar.layer.cornerRadius = avatar.frame.size.width / 2
        avatar.layer.masksToBounds = true
        avatar.isUserInteractionEnabled = true
        let tapGetsure = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        avatar.addGestureRecognizer(tapGetsure)
    }
    func showError(message: String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    @objc func addPhoto() {
        let actionSheet = UIAlertController(title: "Select an option", message: "", preferredStyle: .actionSheet)
        let fromCamera = UIAlertAction(title: "Take photo", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {//kiểm tra camera có available hay không
            self.imagePicker.sourceType = .camera
            self.imagePicker.cameraCaptureMode = .photo
            self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker, animated: true, completion: nil)}
            else{
                self.showError(message: "Camera is not supported by this device")
            }
        }
        let fromLibrary = UIAlertAction(title: "Chooose from library", style: .default) { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(fromCamera)
        actionSheet.addAction(fromLibrary)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
}

extension ContactDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        avatar.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
}
