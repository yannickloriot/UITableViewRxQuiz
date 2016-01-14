//
//  ViewController.swift
//  UITableViewRxQuiz
//
//  Created by Yannick LORIOT on 14/01/16.
//  Copyright © 2016 Yannick LORIOT. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController, UITableViewDelegate {
  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var nextQuestionButton: UIBarButtonItem!
  @IBOutlet weak var choiceTableView: UITableView!
  @IBOutlet weak var validButton: UIButton!

  let questions = Data.dummyQuestions

  let currentQuestionIndex                      = Variable(0)
  let currentQuestion: Variable<QuestionModel?> = Variable(nil)
  let selectedItems: Variable<[ChoiceModel]>    = Variable([])

  // A dispose bag to be sure that all element added to the bag is deallocated properly.
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupCurrentQuestionIndexObserver()
    setupCurrentQuestionObserver()
    setupNextQuestionButtonObserver()
    setupChoiceTableViewObserver()
    setupValidButtonObserver()

    // Sets self as tableview delegate

    choiceTableView
      .rx_setDelegate(self)
      .addDisposableTo(disposeBag)
  }

  // MARK: - Private Methods

  private func setupCurrentQuestionIndexObserver() {
    currentQuestionIndex
      .asObservable()
      .map({ index in
        return index % self.questions.count
      })
      .subscribeNext { index -> Void in
        self.currentQuestion.value = self.questions[index]
      }
      .addDisposableTo(disposeBag)
  }

  private func setupCurrentQuestionObserver() {
    currentQuestion
      .asObservable()
      .subscribeNext { question in
        self.navigationBar.topItem?.title = question?.title
      }
      .addDisposableTo(disposeBag)
  }

  private func setupNextQuestionButtonObserver() {
    nextQuestionButton
      .rx_tap
      .subscribeNext {
        self.currentQuestionIndex.value += 1
      }
      .addDisposableTo(disposeBag)
  }

  private func setupChoiceTableViewObserver() {
    currentQuestion
      .asObservable()
      .filter({ $0 != nil })
      .map({ $0!.choices })
      .bindTo(choiceTableView.rx_itemsWithCellIdentifier("ChoiceCell", cellType: UITableViewCell.self)) { (row, element, cell) in
        cell.textLabel?.text = element.title
      }
      .addDisposableTo(disposeBag)

    choiceTableView
      .rx_modelSelected(ChoiceModel)
      .subscribeNext { value in
        self.selectedItems.value.append(value)
      }
      .addDisposableTo(disposeBag)

    choiceTableView
      .rx_modelDeselected(ChoiceModel)
      .subscribeNext { value in
        self.selectedItems.value = self.selectedItems.value.filter { $0 != value }
      }
      .addDisposableTo(disposeBag)
  }

  private func setupValidButtonObserver() {
    selectedItems
      .asObservable()
      .map { $0.count > 0 }
      .bindTo(validButton.rx_enabled)
      .addDisposableTo(disposeBag)
  }

  // MARK: - UITableView Delegate Methods

  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.selectionStyle  = .None

    cell.backgroundColor = .clearColor()
  }

  func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    return .None
  }
}

