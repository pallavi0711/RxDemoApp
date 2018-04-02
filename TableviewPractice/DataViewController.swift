//
//  DataViewController.swift
//  TableviewPractice
//
//  Created by administrator on 29/03/18.
//  Copyright © 2018 administrator. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate let minimalLength = 4
fileprivate let minimalDescrLength = 1

var isValidString = false
let disposeBag = DisposeBag()



class DataViewController: UIViewController {

    @IBOutlet weak var enableLabel: UILabel!
    // var delegate :DetailDelegate? = nil
    
    @IBOutlet weak var save_button: UIButton!
    
    let data = PublishSubject<Detail>()
    
    @IBOutlet weak var captionLabel: UILabel!
    

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var captionData: UITextField!
    
    @IBOutlet weak var DescriptionData: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captionValid = captionData.rx.text.orEmpty
            .map { _ in self.validateCaption(caption: self.captionData.text!) }
            .share(replay: 1)
        
        let descriptionValid = DescriptionData.rx.text.orEmpty
            .map { $0.count >= minimalDescrLength }
            .share(replay: 1)
        
        
        captionValid
            .bind(to: captionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        descriptionValid
            .bind(to: descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
    
        let everythingValid: Observable<Bool>
           = Observable.combineLatest(captionValid, descriptionValid) { $0 && $1 }

        everythingValid.subscribe(onNext: {  [unowned self] valid in
            self.enableLabel.text = valid ? "Enable" : "Not enable"
        }).disposed(by: disposeBag)
        
        everythingValid.bind(to: save_button.rx.isEnabled).disposed(by: disposeBag)
        
    }

    
    @IBAction func save(_ sender: Any) {
        
        self.data.onNext(Detail(caption: captionData.text!, description: DescriptionData.text!))
        
    }
    
    func validateCaption(caption:String)->Bool{
        let charset = CharacterSet(charactersIn: "1234567890+-*=(),.:!_@#")
        
        if let _ = caption.rangeOfCharacter(from: charset, options: .caseInsensitive) {
            
            if caption.count <= 1 {
                print("Executed.............")
                captionLabel.text = "Invalid Character"
                isValidString = false
                return false
            }
                
            else {
                if isValidString == false{
                    captionLabel.text = "Invalid Character"
                    return false
                }
                else {
                    print("Returning true.........")
                    return true }
            }
            
        }
        else {
            
            if caption.count <= 1 {
                isValidString = true
            }
            return true
        }
    }
}


