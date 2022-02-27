//
//  TitleViewController.swift
//  2.13
//
//  Created by Алексей Трофимов on 03.01.2022.
//

import UIKit
import CoreData

class TitleViewController: UITableViewController {
    
    let cellID = "cell"
    var tasks = StorageManager.shared.fetchData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func setupNavigationBar(){
        title = "List"
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarApperance = UINavigationBarAppearance()
        navBarApperance.configureWithOpaqueBackground()
        navBarApperance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarApperance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarApperance.backgroundColor = UIColor.darkGray
        navigationController?.navigationBar.standardAppearance = navBarApperance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApperance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add
                                                            , target: self
                                                            , action: #selector(addTask))
        
        navigationController?.navigationBar.tintColor = .white
    }
    @objc func addTask(){
      showAlert()
    }
    
    func showAlert(task: Task? = nil, completion: (() -> Void)? = nil) {
        var title = "New Task"
        if task != nil { title = "Update Task"}
        let alert = AlertController(title: title, message: "What do you want to do?", preferredStyle: .alert)
        alert.action(task: task) { newValue in
            if let task = task, let completion = completion {
                StorageManager.shared.edit(task, newName: newValue)
                completion()
            } else {
                StorageManager.shared.save(newValue) { task in
                    self.tasks.append(task)
                    self.tableView.insertRows(
                        at: [IndexPath(row: self.tasks.count - 1, section: 0)],
                        with: .automatic)
                }
            }
        }
        present(alert, animated: true)
    }
    
}
extension TitleViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        showAlert(task: task){
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.delete(task)
        }
    }
    
}

