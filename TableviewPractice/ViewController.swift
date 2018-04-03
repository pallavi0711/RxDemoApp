
import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addDetailsBarButton: UIBarButtonItem!
    
   var details:Variable<[Detail]> = Variable([])
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        details.asObservable().bind(to: tableView.rx.items(cellIdentifier:"tablecell"))
        {
            tableView,Detail,cell in
            if let cellToUse = cell as? TableViewCell
            {
                cellToUse.captionLabel.text = Detail.caption
                cellToUse.DescriptionLabel.text = Detail.description
            }
            }.disposed(by: disposeBag)
        
        self.buttonAddDetails()
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




