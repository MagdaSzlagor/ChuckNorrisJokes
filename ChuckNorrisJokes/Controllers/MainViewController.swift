//
//  ViewController.swift
//  ChuckNorris
//
//  Created by Magdalena Szlagor on 04/05/2018.
//  Copyright © 2018 Magdalena Szlagor. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var topOffset: NSLayoutConstraint!
    @IBOutlet weak var popupView: UIView!
    
    let apiEndpoint = "https://api.icndb.com/jokes/random/10?escape=javascript"
    
    var dataSource: [JokeModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Be the next Chuck Norris"
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputUserData()
    }
    
    private func setupUI() {
        goButton.layer.masksToBounds = true
        goButton.layer.cornerRadius = 25.0
        
        popupView.layer.masksToBounds = true
        popupView.layer.cornerRadius = 10.0
        popupView.layer.borderColor = UIColor.cnj_darkBrownColor.cgColor
        popupView.layer.borderWidth = 1.0
        popupView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    }
    
    @IBAction func refresh() {
        guard var firstName = firstNameTextfield.text, firstName.isEmpty == false, var lastName = lastNameTextfield.text, lastName.isEmpty == false else {
            return
        }
        
        // trim trailling spaces
        firstName = firstName.trailingTrim(.whitespaces)
        lastName = lastName.trailingTrim(.whitespaces)
        
        var urlString = apiEndpoint + "&firstName=" + firstName + "&lastName=" + lastName
        // just in case we have some spaces in names
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: urlString)
        WebService().load(resource: WebService.parseResponse(withURL: url!)) { [unowned self] result in
            switch result {
            case .success(let jokes):
                self.dataSource = jokes
                
            case .failure(let fail):
                self.dataSource = []
                print(fail)
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func getJokesPressed() {
        guard let firstName = firstNameTextfield.text, firstName.isEmpty == false, let lastName = lastNameTextfield.text, lastName.isEmpty == false else {
            return
        }
        
        dataSource = []
        tableView.reloadData()
        tableView.isHidden = false
       
        view.endEditing(true)
        
        topOffset.constant = -popupView.frame.size.height
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
        refresh()
    }
    
    @IBAction func inputUserData() {
        guard topOffset.constant < 0  else {
            return
        }
        tableView.isHidden = true
        
        firstNameTextfield.text = nil
        lastNameTextfield.text = nil
        
        topOffset.constant = 170.0
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JokeCell") as! JokeCell
        cell.joke = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

class JokeCell: UITableViewCell {
    @IBOutlet weak var jokeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var joke: JokeModel! {
        didSet {
            jokeLabel.text = joke.jokeText
            setupLikeButton()
        }
    }
    
    @IBAction func likeJokePressed() {
        joke.likedByUser = !joke.likedByUser
        setupLikeButton()
    }
    
    override func awakeFromNib() {
        prepareCell()
    }
    
    override func prepareForReuse() {
        prepareCell()
        
        super.prepareForReuse()
    }
    
    private func setupLikeButton() {
        if joke.likedByUser == true {
            likeButton.tintColor = UIColor.cnj_redColor
        }
        else {
            likeButton.tintColor = UIColor.cnj_darkBrownColor.withAlphaComponent(0.3)
        }
    }
    
    private func prepareCell() {
        jokeLabel.text = nil
        likeButton.tintColor = UIColor.cnj_darkBrownColor.withAlphaComponent(0.3)
    }
}
