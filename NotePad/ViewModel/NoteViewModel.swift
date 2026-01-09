//
//  ViewModel.swift
//  NotePad
//
//  Created by Hamza Sikandar on 08/09/2025.
//

class NoteViewModel {
    
    private(set) var notes: [Note] = [] {
        didSet {
            onNotesChanged?()
        }
    }
    
    var showFavoritesOnly = false {
        didSet {
            onNotesChanged?()
        }
    }
    var onNotesChanged: (() -> Void)?
    
    var filteredNotes: [Note] {
        showFavoritesOnly ? notes.filter { $0.isFavorite } : notes
    }
    
    func add(note: Note) {
        notes.append(note)
    }
    
    func delete(at index: Int) {
        notes.remove(at: index)
    }
    
    func toggleFavorite(at index: Int) {
        notes[index].isFavorite.toggle()
    }
    
    func getActualIndex(filteredIndex: Int) -> Int? {
        let filtered = filteredNotes[filteredIndex]
        return notes.firstIndex(where: { $0.title == filtered.title && $0.date == filtered.date })
        
    }
    
    func update(note: Note, at index: Int) {
        notes[index] = note
    }
    func unfavourite(at index: Int) {
        notes[index].isFavorite = false
    }
    
}
