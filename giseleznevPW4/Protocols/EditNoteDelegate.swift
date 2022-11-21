//
//  EditNoteDelegate.swift
//  giseleznevPW4
//
//  Created by Григорий Селезнев on 11/21/22.
//

import UIKit

protocol EditNoteDelegate {
    func editNote(note: ShortNote, indexPath: IndexPath)
    
    func cancelEditing()
}
