//
//  ViewController.swift
//  M17_Concurrency
//
//
//

import UIKit
import SnapKit
class ViewController: UIViewController {
//MARK: -Properties
    let service = Service()
    var images = [UIImage] ()
//MARK: -Views
    private lazy var stackView : UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 16
        return stack
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 220, y: 220, width: 300, height: 300))
        return view
    }()
//MARK: -Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
        setupViews()
        setupConstraints()
    }
//MARK: -Private methods
    private func setupViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    private func setupConstraints() {
        stackView.snp.makeConstraints{maker in
            maker.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            maker.bottom.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        activityIndicator.snp.makeConstraints{maker in
            maker.centerX.equalTo(stackView)
            maker.centerY.equalTo(stackView)
        }
        
    }
    private func onLoad() {
        let dispatchGroup = DispatchGroup()
        for _ in 0...4 {
            dispatchGroup.enter()
            service.getImageURL { urlString, error in
                guard
                    let urlString = urlString
                else {
                    return
                }
                guard let image = self.service.loadImage(urlString: urlString) else {return}
                self.images.append(image)
                dispatchGroup.leave()
        }
        }
        dispatchGroup.notify(queue: .main){ [weak self] in
            guard let self = self else {
                return
            }
            self.activityIndicator.stopAnimating()
            self.stackView.removeArrangedSubview(self.activityIndicator)
            for i in 0...4 {
                self.addImage(image: self.images[i])
            }
        }
    }
   private func addImage(image : UIImage) {
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        self.stackView.addArrangedSubview(view)
        }
    }

