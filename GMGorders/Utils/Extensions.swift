//
//  Extensions.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/1/23.
//

import UIKit


extension String{
    
    func readLocalFile() -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: self,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
}


extension Data{
    
     func jsonParser<T: Decodable>(type: T.Type) -> T?{
         let decoder = JSONDecoder()
         do {
             let model = try decoder.decode(T.self, from: self)
             return model
         } catch {
             print(String(describing: error))
         }
        return nil
    }
}

protocol NibRepresentable {
    static var nib: UINib { get }
    static var identifier: String { get }
}

extension UIView: NibRepresentable {
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    class var identifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    func dequeueCell<T: UITableViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(
            withIdentifier: type.identifier,
            for: indexPath) as! T
    }

    func registerCell<T: UITableViewCell>(_ type: T.Type) {
        self.register(type.nib, forCellReuseIdentifier: type.identifier)
    }

}


extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}


class SafeAreaHelper {
    static func insets() -> UIEdgeInsets {
        var insets: UIEdgeInsets = .zero
        
        let window = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow }
        
        if  window != nil {
            insets = window!.safeAreaInsets
        }
        return insets
    }
}




extension UIView {

  @IBInspectable var cornerRadius: CGFloat {

   get{
        return layer.cornerRadius
    }
    set {
        layer.cornerRadius = newValue
        layer.masksToBounds = newValue > 0
    }
  }

  @IBInspectable var borderWidth: CGFloat {
    get {
        return layer.borderWidth
    }
    set {
        layer.borderWidth = newValue
    }
  }

  @IBInspectable var borderColor: UIColor? {
    get {
        return UIColor(cgColor: layer.borderColor!)
    }
    set {
        layer.borderColor = newValue?.cgColor
    }
  }
}


protocol NameDescribable {
    var typeName: String { get }
    static var typeName: String { get }
}

extension NameDescribable {
    var typeName: String {
        return String(describing: type(of: self))
    }

    static var typeName: String {
        return String(describing: self)
    }
}
extension NSObject: NameDescribable {}
