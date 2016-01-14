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

class ViewController: UIViewController {
  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var nextQuestionButton: UIBarButtonItem!
  @IBOutlet weak var choiceTableView: UITableView!
  @IBOutlet weak var validButton: UIButton!

  let questions = Data.dummyQuestions

  let currentQuestionIndex                      = Variable(0)
  let currentQuestion: Variable<QuestionModel?> = Variable(nil)

  // A dispose bag to be sure that all element added to the bag is deallocated properly.
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupCurrentQuestionIndexObserver()
    setupCurrentQuestionObserver()
    setupNextQuestionButtonObserver()
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
}

