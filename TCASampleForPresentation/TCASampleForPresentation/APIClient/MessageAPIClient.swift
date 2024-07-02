import Foundation

class MessageAPIClient {
    private var messages = [String]()
    /// singleton pattern object
    static let shared = MessageAPIClient()
    private init() {}
}

extension MessageAPIClient: MessageProvider {
    func fetchMessages() async throws -> [String] {
        let randomIndex = Int.random(in: 0..<Self.messageList.count)
        let newMessage = Self.messageList[randomIndex]
        self.messages.append(newMessage)
        sleep(1)
        return self.messages
    }
}

extension MessageAPIClient {
    private static let messageList: [String] = [
        "おはよう！",
        "この間の試合、どうだった？",
        "今から研究室行く！",
        "こんにちは！",
        "宿題終わった？",
        "もうすぐ会えるね。",
        "お疲れ様です。",
        "元気ですか？",
        "映画見たよ！",
        "カフェ行こう。",
        "楽しかった！",
        "お昼ご飯食べた？",
        "明日の予定は？",
        "最近どう？",
        "新しい本読んだ。",
        "すごいね！",
        "またね。",
        "ありがとう。",
        "さようなら。",
        "了解です。",
        "頑張って！",
        "楽しみだね。",
        "遅れてごめん。",
        "会議は何時？",
        "気をつけて！",
        "すみません。",
        "天気いいね。",
        "手伝ってくれる？",
        "どこ行くの？",
        "素敵な一日を！"
    ]
}

enum MessageError: Error {
    case fetchError
}
