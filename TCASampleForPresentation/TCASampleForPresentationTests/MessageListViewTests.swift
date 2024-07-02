import XCTest
import ComposableArchitecture

@testable import TCASampleForPresentation

// MARK: TCA を用いた場合のテスト
final class TCAMessageListViewTests: XCTestCase {
    @MainActor
    func testFetchMessagesResponse_エラーが返されるとisShowingAlertがtrueになること() async {
        // 1. テスト対象 (TestStore) の生成
        let store = TestStore(initialState: MessageList.State()) { MessageList() }

        // 2. Action（fetchMessagesResponse でエラーが返されたイベント）を send してアサーション
        await store.send(.fetchMessagesResponse(.failure(MessageError.fetchError))) {
            $0.isShowingAlert = true // アサーションしたい内容
        }
    }
}

// MARK: 純粋な SwiftUI を用いた場合のテスト
final class MessageListViewTests: XCTestCase {
    // 1. 常にエラーを返すモックを作成しておく
    private class MockMessageAPIClientWithError: MessageProvider {
        func fetchMessages() async throws -> [String] {
            throw MessageError.fetchError 
        }
    }

    @MainActor
    func testFetchMessagesResponse_エラーが返されるとisShowingAlertがtrueになること() async {
        // 2. テスト対象の生成
        let messageListView = MessageListView(
            messageProvider: MockMessageAPIClientWithError() // 常にエラーを返すモックを DI
        )

        Task {
            // 3. ボタンがタップされたときに実行されるメソッドを呼ぶ
            await messageListView.onTapUpdateButtonTapped()

            // 4. isShowingAlert が true となることをアサーション
            XCTAssertTrue(messageListView.isShowingAlert)
        }
    }
}


