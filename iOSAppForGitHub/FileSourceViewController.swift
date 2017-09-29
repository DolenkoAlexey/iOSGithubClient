//
//  FileSourceViewController.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 29/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FileSourceViewController: UIViewController {
    @IBOutlet weak var sourceTextView: UITextView!
    
    var viewModel: FileSourceViewModelType!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getContent().drive(onNext: {[weak self] file in
            let str = file.content.replacingOccurrences(of: "\n", with: "")
            if let contentData = Data(base64Encoded: str),
                let decodedContent = String(data: contentData, encoding: .utf8) {
                
                self?.sourceTextView.text = decodedContent
            }
        }).addDisposableTo(disposeBag)
    }

}
