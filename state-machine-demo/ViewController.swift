//
//  ViewController.swift
//  state-machine-demo
//
//  Created by Piotr Żużel on 11/09/2018.
//  Copyright © 2018 Piotr Żużel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    let viewModel = ViewModel() // disregard lack of dependency injection in this demo
    
    
    @IBOutlet weak var succeedingButton: UIButton!
    @IBOutlet weak var succeedingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var failingButton: UIButton!
    @IBOutlet weak var failingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    // MARK: Bindings
    private func bindViewModel() {
        failingButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                self.viewModel.triggerFailingAction() // you can also use observers if you want
            })
            .disposed(by: disposeBag)
        
        // you can bind incidators straight from action...
        viewModel.failingAction
            .map{ $0.isIdle }
            .bind(to: failingIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.failingAction
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] state in
                if case .failure(let error) = state {
                    self.displayAlert(for: error)
                }
            })
            .disposed(by: disposeBag)
        
        succeedingButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                self.viewModel.triggerSucceedingAction() // you can also use observers if you want
            })
            .disposed(by: disposeBag)
        
        // ... or you can handle them manually in subscription block
        viewModel.succeedingAction
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] state in
                switch state {
                case .idle:
                    self.succeedingIndicator.isHidden = true
                case .processing:
                    self.succeedingIndicator.isHidden = false
                case .success:
                    print("Success!")
                case .failure(let error):
                    self.displayAlert(for: error)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func displayAlert(for error: Error) {
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
