//
//  ProductTableViewCell.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 11.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

typealias ProductStateChanged = (_ isSelected: Bool, _ selectedCount: Int) -> ()

class ProductTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var productIdentifierLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var inStorageDateLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var countGetTextField: UITextField!
    @IBOutlet weak var productImage: UIImageView!
    
    var productModel: ProductModel!
    
    var stateChangedBlock: ProductStateChanged?
    
//    var storage = FIRStorage.storage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let keyboardDoneButtonView = UIToolbar.init()
        keyboardDoneButtonView.sizeToFit()
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                              target: self,
                                              action: #selector(self.finishEditing))
        
        keyboardDoneButtonView.items = [doneButton]
        countGetTextField.inputAccessoryView = keyboardDoneButtonView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillByModel(_ model: ProductModel) {
        productModel = model
        productIdentifierLabel.text = model.identifier
        productNameLabel.text = model.name
        inStorageDateLabel.text = String(model.inStorage)
        countGetTextField.delegate = self
        
//        self.storage.referenceForURL(chatMessage.message).dataWithMaxSize(25 * 1024 * 1024, completion: { (data, error) -> Void in
//            let image = UIImage(data: data!)
//            chatMessage.image = image!
//            self.messages.append(chatMessage)
//            self.tableView.reloadData()
//            self.scrollToBottom()
//        })
    }

//    MARK: - UITextFieldDelegate

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        finishEditing()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        finishEditing()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        var txtAfterUpdate = textField.text! as NSString
        txtAfterUpdate = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
        let stringValue = String(txtAfterUpdate)
        return (Int(stringValue) != nil) || stringValue.characters.count == 0 ? true : false
    }
    
//    MARK: - Events
    
    func finishEditing() {
        if let stateChangedBlock = stateChangedBlock {
            stateChangedBlock(checkBoxButton.isSelected, Int(countGetTextField.text ?? "0") ?? 0)
        }
        countGetTextField.resignFirstResponder()
    }
    
    func setSelectedCell(_ selected: Bool) -> () {
        checkBoxButton.isSelected = selected
        if let stateChangedBlock = stateChangedBlock {
            stateChangedBlock(selected, Int(countGetTextField.text ?? "0") ?? 0)
        }
    }
    
//    MARK: - Actions
    
    @IBAction func checkBoxButtonAction(_ sender: UIButton) {
        setSelectedCell(!sender.isSelected)
        print("checkBoxButtonAction")
    }
    
    @IBAction func imagePresentButtonAction(_ sender: UIButton) {
        print("imagePresentButtonAction")
    }
    
}
