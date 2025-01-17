// hankyeol-dev. CommonUI

import UIKit

public protocol BaseCoordinatorVC: UIViewController {
   var coordinateHandler: ((CoordinateAction) -> Void)? { get set }
   associatedtype CoordinateAction
}
