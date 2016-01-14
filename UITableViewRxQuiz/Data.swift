//
//  Data.swift
//  UITableViewRxQuiz
//
//  Created by Yannick LORIOT on 14/01/16.
//  Copyright © 2016 Yannick LORIOT. All rights reserved.
//

import Foundation

final class Data {
  static var dummyQuestions: [QuestionModel] = {
    // Question 1
    let c1 = ChoiceModel(title: "A powerful library", valid: true)
    let c2 = ChoiceModel(title: "A brush", valid: false)
    let c3 = ChoiceModel(title: "A swift implementation of ReativeX", valid: true)
    let c4 = ChoiceModel(title: "The Observer pattern on steroids", valid: true)
    let q1 = QuestionModel(title: "What is RxSwift?", choices: [c1, c2, c3, c4])

    // Question 2
    let c5 = ChoiceModel(title: "Asynchronous events", valid: true)
    let c6 = ChoiceModel(title: "Email validation", valid: true)
    let c7 = ChoiceModel(title: "Networking", valid: true)
    let c8 = ChoiceModel(title: "Interactive UI", valid: true)
    let c9 = ChoiceModel(title: "And many more...", valid: true)
    let q2 = QuestionModel(title: "In which cases RxSwift is useful?", choices: [c5, c6, c7, c8, c9])

    return [q1, q2]
  }()
}