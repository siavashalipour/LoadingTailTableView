//
//  ViewController.swift
//  LoadingTailTableView
//
//  Created by Siavash on 1/9/17.
//  Copyright © 2017 Siavash. All rights reserved.
//

import UIKit
import SnapKit


class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var ds: [String] = ["1","2","3","4","5","6","7","8","9","10","1","2","3","4","5","6","7","8","9","10"]
    fileprivate lazy var footer: LoadingTailCell = {
        let v = LoadingTailCell()
        return v
    }()
    fileprivate var footerHeight: CGFloat = 45
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func addItemToEnd() {
        for i in ds.count...(ds.count+10) {
            ds.append("\(i+1)")
        }
    }
    @objc
    fileprivate func stopAnimating() {
        footer.stopLoading()
        //add the data
        addItemToEnd()
        tableView.reloadData()
    }
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DefaultCell
        if let aCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell") as? DefaultCell {
            cell = aCell
        } else {
            cell = DefaultCell()
        }
        cell.config(with: ds[indexPath.row])
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ds.count
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height {
            print("Scrolled to bottom")
            footerHeight = 45
            footer.startLoading()
            self.perform(#selector(self.stopAnimating), with: nil, afterDelay: 0.5)
            return
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footer
    }
}

class DefaultCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func config(with title: String) {
            self.title.text = title
    }
}

class LoadingTailCell: UIView {
    
    fileprivate var loader: UIActivityIndicatorView = {
       let a = UIActivityIndicatorView()
        a.hidesWhenStopped = true
        a.color = UIColor.gray
        return a
    }()
    fileprivate var loadingLabel: UILabel = {
        let l = UILabel()
        l.text = "Loading..."
        l.textColor = .black
        l.isHidden = true
        return l
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    func config() {
        addSubview(loader)
        loader.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-50)
        }
        addSubview(loadingLabel)
        loadingLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        backgroundColor = .clear
    }
    func startLoading() {
        loadingLabel.isHidden = false
        loader.startAnimating()
    }
    func stopLoading() {
        loadingLabel.isHidden = true
        loader.stopAnimating()
    }
}
