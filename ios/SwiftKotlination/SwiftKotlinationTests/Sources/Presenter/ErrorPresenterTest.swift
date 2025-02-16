import XCTest
@testable import SwiftKotlination

final class ErrorPresenterTest: XCTestCase {

    var sut: ErrorPresenter!

    func testErrorPresenterPresentsAlertControllerSuccessfully() throws {
        let error: NetworkError = .invalidData
        sut = ErrorPresenter(error: error)

        let viewController = UIViewController()

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = viewController

        viewController.viewDidLoad()

        sut.present(in: viewController, animated: false)

        let alertController = try require(viewController.presentedViewController as? UIAlertController)
        XCTAssertEqual(alertController.title, "Error")
        XCTAssertEqual(alertController.message, error.description)
        XCTAssertEqual(alertController.actions.count, 1)
        XCTAssertEqual(alertController.actions.first?.title, "Ok")
        XCTAssertEqual(alertController.actions.first?.style, .default)
    }
}
