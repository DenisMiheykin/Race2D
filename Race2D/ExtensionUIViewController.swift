import UIKit

extension UIViewController {
    
    func showAlertWithText(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Username"
        }
        
        let action        = UIAlertAction(title: "OK",      style: .default, handler: nil)
        let cancelAction  = UIAlertAction(title: "Cancel",  style: .cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showAlert(title: String, message: String, preferredStyle: UIAlertController.Style = .alert, actionTitle: String = "OK", style: UIAlertAction.Style = .default, handler: @escaping ((UIAlertAction) -> Void)) {
        
        showAlert(title: title, message: message, preferredStyle: preferredStyle, actions: [(actionTitle, style, handler)])
        
    }
    
    func showAlert(title: String, message: String, preferredStyle: UIAlertController.Style = .alert, actions: [(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void))]) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for element in actions {
            alert.addAction(UIAlertAction(title: element.title, style: element.style, handler: element.handler))
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
}
