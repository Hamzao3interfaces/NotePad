//
//  AddEditNoteViewController.swift
//  NotePad
//
//  Created by Hamza Sikandar on 09/09/2025.
//

import UIKit
protocol DataPass {
    func didSaveNote(_ note: Note, noteToEdit: Note?, at index: Int?)
}
class AddEditNoteViewController: UIViewController {
    
    var onSave: ((Note, Bool, Int?) -> Void)?

    var noteToEdit: Note?
    var noteIndex: Int?
    
    var delegte: DataPass!
    
    init(note: Note? = nil) {
        self.noteToEdit = note
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let titleField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter title"
        tf.borderStyle = .roundedRect
        return tf
    }()
    private let contentField: UITextView = {
        let tv = UITextView()
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 8
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    private let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save", for: .normal)
        btn.backgroundColor = .black
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(titleField)
        view.addSubview(contentField)
        view.addSubview(saveButton)
        titleField.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 40)
        contentField.frame = CGRect(x: 20, y: 150, width: view.frame.width - 40, height: 200)
        saveButton.frame = CGRect(x: 20, y: 370, width: view.frame.width - 40, height: 50)
        
        saveButton.addTarget(self, action: #selector(saveNote), for: .touchUpInside)
        populateData()
    }
    @objc private func saveNote() {
        guard
            let title = titleField.text, !title.isEmpty,
            let content = contentField.text, !content.isEmpty
        else {
            let alert = UIAlertController(title: "Missing Info", message: "Please fill in all fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        let note = Note(title: title, content: content, date: Date(), isFavorite: noteToEdit?.isFavorite ?? false)
        delegte?.didSaveNote(note, noteToEdit: noteToEdit, at: noteIndex)
        navigationController?.popViewController(animated: true)
    }
    
    private func populateData() {
        titleField.text = noteToEdit?.title
        contentField.text = noteToEdit?.content
    }
}
