import XCTest
import ComposableArchitecture

@testable import TCASampleForPresentation

final class TCAMessageListViewTests: XCTestCase {
    @MainActor
    func testFetchMessagesResponse_エラーが返されるとisShowingAlertがtrueになること() async {
        let store = TestStore(initialState: MessageList.State()) { MessageList() }
        await store.send(.fetchMessagesResponse(.failure(MessageError.fetchError))) {
            $0.isShowingAlert = true
        }
    }
}

// TODO: 純粋な SwiftUI のテストを書く（常にエラーを返す Mock を作成して DI）
final class MessageListViewTests: XCTestCase {
    @MainActor
    func testFetchMessagesResponse_エラーが返されるとisShowingAlertがtrueになること() async {
        let store = TestStore(initialState: MessageList.State()) { MessageList() }
        await store.send(.fetchMessagesResponse(.failure(MessageError.fetchError))) {
            $0.isShowingAlert = true
        }
    }
}
