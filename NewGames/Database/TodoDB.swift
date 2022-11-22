//
//  TodoDB.swift
//  NewGames
//
//  Created by Şükrü Özkoca on 17.11.2022.
//

protocol TodoDB {
    func add(usingTodoItem todoItem: TodoItem) -> Bool
    func update(usingTodoItem todoItem: TodoItem) -> Void
    func delete(usingMail mail: String) -> Void
    
}
