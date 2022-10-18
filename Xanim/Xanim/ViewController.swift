//
//  ViewController.swift
//  Xanim
//
//  Created by Samantha Eufrásio Rocha on 11/10/22.
//

import UIKit

class ViewController: UIViewController {
    private var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Loading Fact..."
        label.sizeToFit()
        return label
    }()
    private lazy var refreshButton: UIButton = {
        let button = UIButton(frame: .zero)
        let image = UIImage(systemName: "arrow.clockwise")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(loadData), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private var dataTask: URLSessionDataTask?
    private var fact: Fact? {
        didSet {
            guard let fact = fact else { return }
            label.text = "\(fact.source)"
            label.sizeToFit()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(label)
        view.addSubview(refreshButton)
        setConstrains()
        loadData()
    }
    private func setConstrains() {
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        refreshButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        refreshButton.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
    }
    @objc private func loadData() {
        guard let url = URL(string: "https://cat-fact.herokuapp.com/facts/random") else {
            return
        }
        dataTask?.cancel()
        dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            if let decodeData = try? JSONDecoder().decode(Fact.self, from: data) {
                DispatchQueue.main.async {
                    self.fact = decodeData
                }
            }
        }
        dataTask?.resume()
    }
}

struct Fact: Decodable {
    let text: String
    let updatedAt: String
    let deleted: Bool
    let source: String
    let sentCoun: Int
}
