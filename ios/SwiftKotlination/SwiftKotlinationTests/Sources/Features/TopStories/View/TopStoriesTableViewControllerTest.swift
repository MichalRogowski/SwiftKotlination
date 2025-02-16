import XCTest
@testable import SwiftKotlination

final class TopStoriesTableViewControllerTest: XCTestCase {

    var sut: TopStoriesTableViewController!

    func testTopStoriesTableViewControllerFetchesTopStoriesSuccessfully() {
        let story = Story(section: "section", subsection: "subsection", title: "title", abstract: "abstract", byline: "byline", url: "url", multimedia: [])
        let factory = TopStoriesFactoryMock(
            topStoriesManager: TopStoriesManagerMock(result: .success([story]))
        )

        sut = factory.makeTopStoriesTableViewController()
        sut.viewDidLoad()

        sut.viewWillAppear(false)

        XCTAssertFalse(sut.tableView.visibleCells.isEmpty)

        factory.topStoriesManager.result = .success([])
        sut.refreshControl?.sendActions(for: .valueChanged)

        XCTAssertTrue(sut.tableView.visibleCells.isEmpty)
    }

    func testTopStoriesTableViewControllerFetchesTopStoriesUnsuccessfully() {
        let story = Story(section: "section", subsection: "subsection", title: "title", abstract: "abstract", byline: "byline", url: "url", multimedia: [])
        let factory = TopStoriesFactoryMock(
            topStoriesManager: TopStoriesManagerMock(result: .success([story]))
        )

        sut = factory.makeTopStoriesTableViewController()
        sut.viewDidLoad()

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = sut

        sut.viewWillAppear(false)

        XCTAssertFalse(sut.tableView.visibleCells.isEmpty)

        factory.topStoriesManager.result = .failure(NetworkError.invalidResponse)
        sut.refreshControl?.sendActions(for: .valueChanged)

        XCTAssertFalse(sut.tableView.visibleCells.isEmpty)
        XCTAssertTrue(sut.presentedViewController is UIAlertController)
    }

    func testTopStoriesTableViewControllerFetchesTopStoryImageSuccessfully() throws {
        let data = try require(File("28DC-nafta-thumbLarge", .jpg).data)
        let expectedImage = try require(UIImage(data: data))
        let story = Story(section: "section", subsection: "subsection", title: "title", abstract: "abstract", byline: "byline", url: "url", multimedia: [Multimedia(url: "url", format: .small)])
        let factory = TopStoriesFactoryMock(
            topStoriesManager: TopStoriesManagerMock(result: .success([story])),
            imageManager: ImageManagerMock(result: .success(expectedImage))
        )

        sut = factory.makeTopStoriesTableViewController()
        sut.viewDidLoad()

        sut.viewWillAppear(false)

        XCTAssertFalse(sut.disposeBag.disposables.isEmpty)
        XCTAssertFalse(sut.tableView.visibleCells.isEmpty)

        let cell = try require(sut.tableView.visibleCells.first as? TopStoriesTableViewCell)
        let image = try require(cell.multimediaImageView.image)
        XCTAssertEqual(expectedImage.pngData(), image.pngData())
        XCTAssertFalse(cell.multimediaImageView.isHidden)

        sut.viewWillDisappear(false)

        XCTAssertTrue(sut.disposeBag.disposables.isEmpty)
    }

    func testTopStoriesTableViewControllerFetchesTopStoryImageUnsuccessfully() throws {
        let story = Story(section: "section", subsection: "subsection", title: "title", abstract: "abstract", byline: "byline", url: "url", multimedia: [Multimedia(url: "url", format: .small)])
        let factory = TopStoriesFactoryMock(
            topStoriesManager: TopStoriesManagerMock(result: .success([story]))
        )

        sut = factory.makeTopStoriesTableViewController()
        sut.viewDidLoad()

        sut.viewWillAppear(false)

        XCTAssertFalse(sut.tableView.visibleCells.isEmpty)

        let cell = try require(sut.tableView.visibleCells.first as? TopStoriesTableViewCell)
        XCTAssertTrue(cell.multimediaImageView.isHidden)
    }

    func testTopStoriesTableViewControllerOpensStorySuccessfully() {
        let story = Story(section: "section", subsection: "subsection", title: "title", abstract: "abstract", byline: "byline", url: "url", multimedia: [])
        let factory = TopStoriesFactoryMock(
            topStoriesManager: TopStoriesManagerMock(result: .success([story]))
        )

        sut = factory.makeTopStoriesTableViewController()
        sut.viewDidLoad()

        sut.viewWillAppear(false)

        let coordinator = CoordinatorMock()
        sut.coordinator = coordinator
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(item: 0, section: 0))
        XCTAssertTrue(coordinator.isStoryOpened)
    }
}
