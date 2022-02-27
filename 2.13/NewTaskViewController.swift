//
//  NewTaskViewController.swift
//  2.13
//
//  Created by Алексей Трофимов on 05.01.2022.
//

import UIKit
import CoreData

class NewTaskViewController: UIViewController {
    
    let viewContext = (UIApplication.shared.delegate as! StorageManager).persistentContainer.viewContext
    
    lazy var newTaskTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "New Task"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.blue
        button.setTitle("Save Task", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.red
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
    }
    func setupSubviews(){
        view.addSubview(newTaskTextField)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
        setupConstraints()
    }
    func setupConstraints(){
        newTaskTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newTaskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            newTaskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            newTaskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: newTaskTextField.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    @objc func save(){
        
        guard let entityDiscription = NSEntityDescription.entity(forEntityName: "Task", in: viewContext) else { return }
        guard let task = NSManagedObject(entity: entityDiscription, insertInto: viewContext) as? Task else { return }
        task.name = newTaskTextField.text
        do {
            try viewContext.save()
        } catch let error {
                print(error.localizedDescription)
            }
        dismiss(animated: true)
    }
    @objc func cancel(){
        dismiss(animated: true)
    }
}
