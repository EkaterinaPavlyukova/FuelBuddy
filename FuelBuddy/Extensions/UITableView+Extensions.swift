import Foundation
import UIKit

extension UITableView {
	
	func dequeueReusableCell<T>(forIndexPath indexPath: IndexPath) -> T where T: UITableViewCell, T:ReusableView {
		guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
				fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
		}
		return cell
	}
	
	func register<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
		let nib = UINib(nibName: T.nibName, bundle: nil)
		register(nib, forCellReuseIdentifier: T.reuseIdentifier)
	}

}
