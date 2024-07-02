import XCTest
import ComposableArchitecture

@testable import TCASampleForPresentation

final class TCAMessageViewTests: XCTestCase {
    func testFetchMessagesResponse_エラーが返されるとisShowingAlertがtrueになること() async {
        let store = TestStore(initialState: MessageList.State()) { MessageList() }
        await store.send(.fetchMessagesResponse(.failure(MessageError.fetchError))) {
            $0.isShowingAlert = true
        }
    }
}

final class MessageViewTests: XCTestCase {
    func testFetchMessagesResponse_エラーが返されるとisShowingAlertがtrueになること() async {
        let store = TestStore(initialState: MessageList.State()) { MessageList() }
        await store.send(.fetchMessagesResponse(.failure(MessageError.fetchError))) {
            $0.isShowingAlert = true
        }
    }
}
