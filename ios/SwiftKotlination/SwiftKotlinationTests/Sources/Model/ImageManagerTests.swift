import XCTest
@testable import SwiftKotlination

final class ImageManagerTest: XCTestCase {

    var sut: ImageManager!

    func testImageManagerFetchesImageSuccessfully() throws {
        let data = try require(File("27arizpolitics7-thumbLarge", .jpg).data)
        let expectedImage = try require(UIImage(data: data))
        let networkManager = NetworkManagerMock(result: .success(data))
        sut = ImageManager(networkManager: networkManager)
        sut
            .image(with: "url") { result in
                switch result {
                case .success(let image):
                    XCTAssertEqual(image.pngData(), expectedImage.pngData())

                case .failure(let error):
                    XCTFail("Fetch Image should succeed, found error \(error)")
                }
        }
    }

    func testImageManagerFetchesImageUnsuccessfully() {
        let networkManager = NetworkManagerMock(result: .failure(NetworkError.invalidResponse))
        sut = ImageManager(networkManager: networkManager)
        sut
            .image(with: "url") { result in
                switch result {
                case .success(let image):
                    XCTFail("Fetch Image should fail, found image \(image)")

                case .failure(let error):
                    XCTAssertEqual(error as? NetworkError, .invalidResponse)
                }
        }
    }

    func testImageManagerFetchesInvalidImageUnsuccessfully() {
        let data = Data()
        let networkManager = NetworkManagerMock(result: .success(data))
        sut = ImageManager(networkManager: networkManager)
        sut
            .image(with: "url") { result in
                switch result {
                case .success(let image):
                    XCTFail("Fetch Image should fail, found image \(image)")

                case .failure(let error):
                    XCTAssertEqual(error as? NetworkError, .invalidData)
                }
        }
    }

    func testImageManagerFetchesImageOnceSuccessfullyAndOnceUnsuccessfully() throws {
        let data = try require(File("27arizpolitics7-thumbLarge", .jpg).data)
        let expectedImage = try require(UIImage(data: data))
        let networkManager = NetworkManagerMock(result: .success(data))
        sut = ImageManager(networkManager: networkManager)

        var times = 0

        sut
            .image(with: "url") { result in
                switch result {
                case .success(let image):
                    XCTAssertEqual(image.pngData(), expectedImage.pngData())

                case .failure(let error):
                    XCTAssertEqual(error as? NetworkError, .invalidRequest)
                }
                times += 1
        }

        networkManager.result = .failure(NetworkError.invalidRequest)

        sut
            .image(with: "url") { result in
                switch result {
                case .success(let image):
                    XCTFail("Fetch Image should fail, found image \(image)")

                case .failure(let error):
                    XCTAssertEqual(error as? NetworkError, .invalidRequest)
                }
                times += 1
        }

        XCTAssertEqual(times, 3)
    }
}
