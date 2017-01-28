//
//  UIKitExtensions.swift
//  ReactiveTwitterSearch
//
//  Created by Colin Eberhardt on 10/05/2015.
//  Copyright (c) 2015 Colin Eberhardt. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

struct AssociationKey {
    static var hidden: UInt8 = 1
    static var alpha: UInt8 = 2
    static var text: UInt8 = 3
    static var enabled: UInt8 = 4
    static var secureTextEntry: UInt8 = 5
    static var textTextView: UInt8 = 6
}

// lazily creates a gettable associated property via the given factory
func lazyAssociatedProperty<T: AnyObject>(host: AnyObject, key: UnsafeRawPointer, factory: ()->T) -> T {
    return objc_getAssociatedObject(host, key) as? T ?? {
        let associatedProperty = factory()
        objc_setAssociatedObject(host, key, associatedProperty, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        return associatedProperty
        }()
}

func lazyMutableProperty<T>(host: AnyObject, key: UnsafeRawPointer, setter: @escaping (T) -> (), getter: @escaping () -> T) -> MutableProperty<T> {
    return lazyAssociatedProperty(host: host, key: key) {
        let property = MutableProperty<T>(getter())
        property.producer
            .startWithValues{
                newValue in
                setter(newValue)
        }
        
        return property
    }
}

extension UIView {
    public var rac_alpha: MutableProperty<CGFloat> {
        return lazyMutableProperty(host: self, key: &AssociationKey.alpha, setter: { self.alpha = $0 }, getter: { self.alpha  })
    }
    
    public var rac_hidden: MutableProperty<Bool> {
        return lazyMutableProperty(host: self, key: &AssociationKey.hidden, setter: { self.isHidden = $0 }, getter: { self.isHidden  })
    }
}

extension UIButton {
    public var rac_enabled: MutableProperty<Bool> {
        return lazyMutableProperty(host: self, key: &AssociationKey.enabled, setter: { self.isEnabled = $0 }, getter: { self.isEnabled  })
    }
}

extension UILabel {
    public var rac_text: MutableProperty<String> {
        return lazyMutableProperty(host: self, key: &AssociationKey.text, setter: { self.text = $0 }, getter: { self.text ?? "" })
    }
}

extension UITextField {
    public var rac_text: MutableProperty<String> {
        return lazyAssociatedProperty(host: self, key: &AssociationKey.text) {
            
            self.addTarget(self, action: #selector(self.changed), for: UIControlEvents.editingChanged)
            
            let property = MutableProperty<String>(self.text ?? "")
            property.producer
                .startWithValues {
                    newValue in
                    self.text = newValue
            }
            return property
        }
    }
    
    func changed() {
        rac_text.value = self.text ?? ""
    }
    
    public var rac_secureTextEntry: MutableProperty<Bool> {
        return lazyMutableProperty(host: self, key: &AssociationKey.secureTextEntry, setter: { self.isSecureTextEntry = $0 }, getter: { self.isSecureTextEntry  })
    }
}

extension UITextView {
    public var rac_text: MutableProperty<String> {
        return lazyMutableProperty(host: self, key: &AssociationKey.textTextView, setter: { self.text = $0 }, getter: { self.text ?? "" })
    }
}

