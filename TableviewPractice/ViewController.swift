//
//  ViewController.swift
//  TableviewPractice
//
//  Created by administrator on 29/03/18.
//  Copyright © 2018 administrator. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var addDetailsBarButton: UIBarButtonItem!
    
   var details:Variable<[Detail]> = Variable([])

   // var details = [Detail]()
//    var details = [
//    Detail(caption:"efgdff",description:"rugfgfjgfjvgfx g"),
//    Detail(caption:"efgdfffuyggjfdfbg",description:"vcvhrugfgfjgfjvgfx g"),
//    Detail(caption:"klnbefgdff",description:"qewrqerwuygrdfudbfjhfygurfgyuygyurfuyrfyguretuyreyuyutuyrtyureuytruyetuyretuyuyuyqrwrugfgfjgfjvgfx g"),
//    ]
//
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.rowHeight = 100
        tableview.estimatedRowHeight = UITableViewAutomaticDimension
        
        
      // let objArray:Observable<[Detail]> = Observable.just(details)
        
        details.asObservable().bind(to: tableview.rx.items(cellIdentifier:"tablecell"))
        {
            tableview,Detail,cell in
            if let cellToUse = cell as? TableViewCell
            {
                cellToUse.captionLabel.text = Detail.caption
                cellToUse.DescriptionLabel.text = Detail.description
            }
            }.disposed(by: disposeBag)
        
        self.buttonAddDetails()
        
    // Do any additional setup after loading the view, typically from a nib.
    }
  
    func buttonAddDetails()
    {
        self.addDetailsBarButton.rx.tap.throttle(0.5,latest: false,scheduler: MainScheduler.instance).subscribe{ [weak self] _ in
            
            guard let strongSelf = self else {return}
            
            guard let dataVC = strongSelf.storyboard?.instantiateViewController(withIdentifier: "detailVC") as? DataViewController else
            {
                fatalError("DataviewController Not found")
            }
                dataVC.data.subscribe(onNext: {[weak self] data in
                self?.details.value.append(data)
                    dataVC.dismiss(animated: true, completion: nil)
                }).disposed(by: (self?.disposeBag)!)
            
                strongSelf.present(dataVC, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
    }

    
}




