//
//  ChoiceCell.swift
//  UITableViewRxQuiz
//
//  Created by Yannick LORIOT on 14/01/16.
//  Copyright © 2016 Yannick LORIOT. All rights reserved.
//

import UIKit

final class ChoiceCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var checkboxImageView: UIImageView!
  @IBOutlet weak var checkmarkImageView: UIImageView!

  private let redColor   = UIColor(red: 231 / 255, green: 76 / 255, blue: 60 / 255, alpha: 1)
  private let greenColor = UIColor(red: 46 / 255, green: 204 / 255, blue: 113 / 255, alpha: 1)

  var choiceModel: ChoiceModel? {
    didSet {
      layoutCell()
    }
  }

  override var selected: Bool {
    didSet {
      checkmarkImageView.hidden = !selected

      layoutCell()
    }
  }

  var displayAnswers: Bool = false {
    didSet {
      layoutCell()
    }
  }

  // MARK: - Layout Cell

  private func layoutCell() {
    titleLabel.text = choiceModel?.title

    if let choice = choiceModel where displayAnswers {
      checkboxImageView.tintColor  = selected ? choice.valid ? greenColor : redColor : choice.valid ? greenColor : .blackColor()
      checkmarkImageView.tintColor = selected ? choice.valid ? greenColor : redColor : .blackColor()
    }
    else {
      checkboxImageView.tintColor  = .blackColor()
      checkmarkImageView.tintColor = .blackColor()
    }
  }
}
