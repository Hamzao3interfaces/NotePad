//
//  ViewController.swift
//  NotePad
//
//  Created by Hamza Sikandar on 08/09/2025.
//

import UIKit

class NoteViewController: UIViewController, DataPass {
    func didSaveNote(_ note: Note, noteToEdit: Note?, at index: Int?) {
        if let indx = index {
            viewModel.update(note: note, at: indx)
        }else{
            viewModel.add(note: note)
        }
    }
    private let filterSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["All", "Favorites"])
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.reuseIdentifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    private let viewModel = NoteViewModel()
    
    private func formatDate(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df.string(from: date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,target: self,action: #selector(addNote))
        navigationItem.titleView = filterSegment
        filterSegment.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        setupTableView()
        bindViewModel()
    }
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onNotesChanged = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    @objc private func addNote() {
        let vc = AddEditNoteViewController()
        vc.delegte = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func filterChanged() {
        viewModel.showFavoritesOnly = filterSegment.selectedSegmentIndex == 1
    }
}

extension NoteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredNotes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier,for:indexPath) as! NoteTableViewCell
        let note = viewModel.filteredNotes[indexPath.row]
        let dateString = formatDate(note.date)
        cell.configure(note: note, formattedDate: dateString)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let actualIndex = viewModel.getActualIndex(filteredIndex: indexPath.row) else { return }
        let note = viewModel.filteredNotes[indexPath.row]
        let vc = AddEditNoteViewController(note: note)
        vc.noteToEdit = note
        vc.noteIndex = actualIndex
        vc.delegte = self
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView,trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        guard let index = viewModel.getActualIndex(filteredIndex: indexPath.row)
        
        else{
            return nil
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _,_,done in
            if self.viewModel.showFavoritesOnly {
                self.viewModel.unfavourite(at: index)
            }
            else{
                self.viewModel.delete(at: index)
            }
            done(true)
        }
        
        if viewModel.showFavoritesOnly {
            return UISwipeActionsConfiguration(actions: [delete])
        }
        
        let fav = UIContextualAction(style: .normal, title: "Fav") { _,_,done in
            self.viewModel.toggleFavorite(at: index)
            done(true)
        }
        fav.backgroundColor = .systemYellow
        
        return UISwipeActionsConfiguration(actions: [delete, fav])
    }

}
