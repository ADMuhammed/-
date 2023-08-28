//
//  Extensions.swift
//  TaskList
//
//  Created by Muhammed on 17.06.2023.
//

import Foundation

extension Date {
    func formattedDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
 //данный код добавляет метод formattedDateString() к типу Date, который позволяет легко получить отформатированное представление даты в коротком формате даты и времени
//extension Date: Это расширение (extension) для типа Date, которое добавляет новый метод formattedDateString().
//func formattedDateString() -> String: Это метод расширения, который возвращает строку с отформатированным представлением даты.
