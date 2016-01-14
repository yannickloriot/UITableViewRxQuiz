//
//  ChoiceModel.swift
//  UITableViewRxQuiz
//
//  Created by Yannick LORIOT on 14/01/16.
//  Copyright © 2016 Yannick LORIOT. All rights reserved.
//

import Foundation

struct ChoiceModel: Equatable {
  let title: String
  let valid: Bool
}

func ==(lhs: ChoiceModel, rhs: ChoiceModel) -> Bool {
  return lhs.title == rhs.title && lhs.valid == rhs.valid
}