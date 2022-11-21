//
//  NotesViewController.swift
//  giseleznevPW4
//
//  Created by Григорий Селезнев on 11/21/22.
//

import UIKit

final class NotesViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var dataSource = [ShortNote]()
    private var isEdit: Bool?
    
    //MARK: - overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
    }
    
    // Saving 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        var strings: [String] = []
        for str in dataSource {
            strings.append(str.text)
        }
        UserDefaults.standard.set(strings, forKey: "Notes")
    }
    
    
    //MARK: - Setups
    private func setupView() {
        // Trying to get saved data in UsersDefaults for dataSource (Notes)
        let strings = UserDefaults.standard.object(forKey: "Notes") as? [String] ?? []
        for str in strings {
            dataSource.append(ShortNote(text: str))
        }
        isEdit = false
        setupTableView()
        setupNavBar()
    }
    
    private func setupTableView() {
        tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.reuseIdentifier)
        tableView.register(AddNoteCell.self, forCellReuseIdentifier: AddNoteCell.reuseIdentifier)
        tableView.register(EditNoteCell.self, forCellReuseIdentifier: EditNoteCell.reuseIdentifier)
        
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .onDrag
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.pin(to: self.view, [.left, .top, .right, .bottom])
    }
    
    private func setupNavBar() {
        self.title = "Notes"
        
        let closeButton = UIButton(type: .close)
        closeButton.addTarget(self, action: #selector(dismiss(animated:completion:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    
    //MARK: - delete note
    private func handleDelete(indexPath: IndexPath) {
        dataSource.remove(at: indexPath.row)
        var strings: [String] = []
        for str in dataSource {
            strings.append(str.text)
        }
        UserDefaults.standard.set(strings, forKey: "Notes")
        tableView.reloadData()
    }
    
    private func handleEdit(indexPath: IndexPath) {
        isEdit = true
        tableView.reloadData()
        if let editableCell = tableView.cellForRow(at: indexPath) as? NoteCell,
           let editCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditNoteCell
        {
            editCell.configure(note: ShortNote(text: editableCell.getNote() ?? ""))
            editCell.setIndexPath(index: indexPath)
        }
    }
}

//MARK: - Draw tableView
extension NotesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // First section resposible for textView and button (for adding new Notes)
        // Second section resposible for showing all notes
        switch indexPath.section {
        case 0:
            if !(isEdit ?? false) {
                if let addNewCell = tableView.dequeueReusableCell(withIdentifier: AddNoteCell.reuseIdentifier, for: indexPath) as? AddNoteCell {
                    addNewCell.delegate = self
                    return addNewCell
                }
            } else {
                if let editNoteCell = tableView.dequeueReusableCell(withIdentifier: EditNoteCell.reuseIdentifier, for: indexPath) as? EditNoteCell {
                    editNoteCell.delegate = self
                    return editNoteCell
                }
            }
            
        default:
            let note = dataSource[indexPath.row]
            if let noteCell = tableView.dequeueReusableCell(withIdentifier: NoteCell.reuseIdentifier, for: indexPath) as? NoteCell {
                noteCell.configure(note)
                return noteCell
            }
        }
        return UITableViewCell()
    }
    
    // When pressing the cell will print index of cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}


extension NotesViewController: UITableViewDelegate {
    //MARK: - Add Context menu for swipe cell
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
    indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: .none
        ) { [weak self] (action, view, completion) in
            self?.handleDelete(indexPath: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(
            systemName: "trash.fill",
            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
        )?.withTintColor(.white)
        deleteAction.backgroundColor = .red
        let editAction = UIContextualAction(
            style: .normal,
            title: "Edit") { [weak self] (action, view, completion) in
                self?.handleEdit(indexPath: indexPath)
                completion(true)
            }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

//MARK: - Add note
extension NotesViewController: AddNoteDelegate {
    func newNoteAdded(note: ShortNote) {
        self.dataSource.insert(note, at: 0)
        var strings: [String] = []
        for str in dataSource {
            strings.append(str.text)
        }
        UserDefaults.standard.set(strings, forKey: "Notes")
        tableView.reloadData()
    }
}

//MARK: - Edit note
extension NotesViewController: EditNoteDelegate {
    func editNote(note: ShortNote, indexPath: IndexPath) {
        print("editting")
        isEdit = false
        dataSource[indexPath.row] = note
        var strings: [String] = []
        for str in dataSource {
            strings.append(str.text)
        }
        UserDefaults.standard.set(strings, forKey: "Notes")
        tableView.reloadData()
    }
    
    func cancelEditing() {
        isEdit = false
        tableView.reloadData()
    }
}
