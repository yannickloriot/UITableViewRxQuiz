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
  @IBOutlet weak var submitButton: UIButton!

  let currentQuestionIndex                        = Variable(0)
  let currentQuestion: Variable<QuestionModel?>   = Variable(nil)
  let selectedIndexPaths: Variable<[NSIndexPath]> = Variable([])
  let displayAnswers: Variable<Bool>              = Variable(false)

  // A dispose bag to be sure that all element added to the bag is deallocated properly.
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Sets self as tableview delegate
    choiceTableView
      .rx_setDelegate(self)
      .addDisposableTo(disposeBag)

    // Setup the observers
    setupCurrentQuestionIndexObserver()
    setupCurrentQuestionObserver()
    setupNextQuestionButtonObserver()
    setupChoiceTableViewObserver()
    setupSubmitButtonObserver()
    setupDisplayAnswersObserver()
  }

  // MARK: - Private Methods

  private func setupCurrentQuestionIndexObserver() {
    currentQuestionIndex
      .asObservable()
      .map { $0 % Quiz.questions.count }
      .subscribeNext { index -> Void in
        self.currentQuestion.value = Quiz.questions[index]
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

    currentQuestion
      .asObservable()
      .filter { $0 != nil }
      .map { $0!.choices }
      .bindTo(choiceTableView.rx_itemsWithCellIdentifier("ChoiceCell", cellType: ChoiceCell.self)) { (row, element, cell) in
        cell.choiceModel = element
      }
      .addDisposableTo(disposeBag)
  }

  private func setupNextQuestionButtonObserver() {
    nextQuestionButton
      .rx_tap
      .subscribeNext {
        self.displayAnswers.value       = false
        self.currentQuestionIndex.value += 1
      }
      .addDisposableTo(disposeBag)
  }

  private func setupChoiceTableViewObserver() {
    choiceTableView
      .rx_itemSelected
      .subscribeNext { indexPath in
        self.selectedIndexPaths.value.append(indexPath)
        self.choiceTableView.cellForRowAtIndexPath(indexPath)?.selected = true
      }
      .addDisposableTo(disposeBag)

    choiceTableView
      .rx_itemDeselected
      .subscribeNext { indexPath in
        self.selectedIndexPaths.value = self.selectedIndexPaths.value.filter { $0 != indexPath }
        self.choiceTableView.cellForRowAtIndexPath(indexPath)?.selected = false
      }
      .addDisposableTo(disposeBag)
  }

  private func setupSubmitButtonObserver() {
    Observable
      .combineLatest(selectedIndexPaths.asObservable(), displayAnswers.asObservable()) { (s, d) in
        return s.count > 0 && !d
      }
      .bindTo(submitButton.rx_enabled)
      .addDisposableTo(disposeBag)

    submitButton
      .rx_tap
      .subscribeNext {
        self.displayAnswers.value = true
      }
      .addDisposableTo(disposeBag)
  }

  private func setupDisplayAnswersObserver() {
    displayAnswers
      .asObservable()
      .subscribeNext { displayAnswers in
        for cell in self.choiceTableView.visibleCells as! [ChoiceCell] {
          cell.displayAnswers = displayAnswers
        }
      }
      .addDisposableTo(disposeBag)
  }

  // MARK: - UITableView Delegate Methods

  func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    return displayAnswers.value ? nil : indexPath
  }

  func tableView(tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    return displayAnswers.value ? nil : indexPath
  }

  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.selectionStyle = .None
  }

  func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    return .None
  }
}

