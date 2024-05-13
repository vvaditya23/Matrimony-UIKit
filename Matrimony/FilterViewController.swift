//
//  FilterViewController.swift
//  Matrimony
//
//  Created by Aditya Vyavahare on 13/05/24.
//

import UIKit

class FilterViewController: UIViewController {
    
    let navbar = UINavigationBar()
    let navItem = UINavigationItem()
    let applyFilterButton = UIButton()
    let ageGroupLabel = UILabel()
    let ageNumberLabel = UILabel()
    let ageNumberLabelUnderline = UILabel()
    let agePicker = UIPickerView()
    let genderTextLabel = UILabel()
    let genderLabelButton = UIButton(primaryAction: nil)
    let genderLabelUnderline = UILabel()
    
    let ageGroupsArray: [String] = ["Select age group", "18-25", "26-35", "36-45", "46-55", "56 and above"]
    let genderArray: [String] = ["Any", "Male", "Female"]
    
    //an action closure that defines the action of each UIMenuElement
    let actionClosure = { (action: UIAction) in
         print(action.title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHeaderFooter()
        setupAgefilter()
        setupGenderFilter()
    }
}

//setup UI elements
extension FilterViewController {
    private func setupHeaderFooter() {
        navItem.title = "Let's find the one for you..."
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeButtonTapped))
        navItem.rightBarButtonItem?.tintColor = .black
        navbar.items = [navItem]
        applyFilterButton.setTitle("Apply filter", for: .normal)
        applyFilterButton.backgroundColor = .magenta
        applyFilterButton.layer.cornerRadius = 10
        applyFilterButton.addTarget(self, action: #selector(applyFilterButtonTapped), for: .touchUpInside)
        view.addSubview(navbar)
        view.addSubview(applyFilterButton)
        navbar.translatesAutoresizingMaskIntoConstraints = false
        applyFilterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            applyFilterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            applyFilterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            applyFilterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupAgefilter() {
        agePicker.delegate = self
        agePicker.dataSource = self
        
        ageGroupLabel.text = "Age Group"
        ageNumberLabel.isUserInteractionEnabled = true
        let ageTapGesture = UITapGestureRecognizer(target: self, action: #selector(ageNumberLabeltapped))
        ageNumberLabel.addGestureRecognizer(ageTapGesture)
        ageNumberLabel.text = "Select age group"
        ageNumberLabelUnderline.backgroundColor = .gray
        view.addSubview(ageGroupLabel)
        view.addSubview(ageNumberLabel)
        view.addSubview(ageNumberLabelUnderline)
        
        ageGroupLabel.translatesAutoresizingMaskIntoConstraints = false
        ageNumberLabel.translatesAutoresizingMaskIntoConstraints  = false
        ageNumberLabelUnderline.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ageGroupLabel.topAnchor.constraint(equalTo: navbar.bottomAnchor, constant: 15),
            ageGroupLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            ageNumberLabel.leadingAnchor.constraint(equalTo: ageGroupLabel.leadingAnchor),
            ageNumberLabel.topAnchor.constraint(equalTo: ageGroupLabel.bottomAnchor, constant: 5),
            ageNumberLabelUnderline.leadingAnchor.constraint(equalTo: ageGroupLabel.leadingAnchor),
            ageNumberLabelUnderline.topAnchor.constraint(equalTo: ageNumberLabel.bottomAnchor, constant: 5),
            ageNumberLabelUnderline.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            ageNumberLabelUnderline.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupGenderFilter() {
        genderTextLabel.text = "Select gender"
        genderLabelUnderline.backgroundColor = .gray
        genderLabelButton.tintColor = .black
        view.addSubview(genderTextLabel)
        view.addSubview(genderLabelButton)
        view.addSubview(genderLabelUnderline)
        genderTextLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabelButton.translatesAutoresizingMaskIntoConstraints = false
        genderLabelUnderline.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genderTextLabel.leadingAnchor.constraint(equalTo: ageGroupLabel.leadingAnchor),
            genderTextLabel.topAnchor.constraint(equalTo: ageNumberLabelUnderline.bottomAnchor, constant: 10),
            genderLabelButton.leadingAnchor.constraint(equalTo: ageGroupLabel.leadingAnchor),
            genderLabelButton.topAnchor.constraint(equalTo: genderTextLabel.bottomAnchor, constant: 5),
            genderLabelUnderline.topAnchor.constraint(equalTo: genderLabelButton.bottomAnchor, constant: 3),
            genderLabelUnderline.leadingAnchor.constraint(equalTo: genderLabelButton.leadingAnchor),
            genderLabelUnderline.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            genderLabelUnderline.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        var menuChildren: [UIMenuElement] = []
        for gender in genderArray {
            menuChildren.append(UIAction(title: gender, handler: actionClosure))
        }
        genderLabelButton.menu = UIMenu(options: .displayInline, children: menuChildren)
        genderLabelButton.showsMenuAsPrimaryAction = true
        genderLabelButton.changesSelectionAsPrimaryAction = true
    }
}

extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageGroupsArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ageGroupsArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedAgeGroup = ageGroupsArray[row]
        ageNumberLabel.text = selectedAgeGroup
    }
}

//button actions
extension FilterViewController {
    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func applyFilterButtonTapped() {
        var genderSelection = ""
        if genderLabelButton.titleLabel?.text == "Male" {
            genderSelection = "male"
        } else if genderLabelButton.titleLabel?.text == "Female" {
            genderSelection = "female"
        }
        let myNotification = Notification.Name("GenderRefresh")
        NotificationCenter.default.post(name: myNotification, object: nil, userInfo: ["gender": genderSelection])
        self.dismiss(animated: true)
    }
    
    @objc func ageNumberLabeltapped() {
        let textField = UITextField()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickerDoneButtonTapped))
        toolbar.setItems([doneButton], animated: true)
        textField.inputView = agePicker
        textField.inputAccessoryView = toolbar
        view.addSubview(textField)
        textField.becomeFirstResponder()
    }
    @objc func pickerDoneButtonTapped() {
        view.endEditing(true)
    }
}
