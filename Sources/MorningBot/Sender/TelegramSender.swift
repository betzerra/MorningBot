//
//  TelegramSender.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 05/10/2022.
//

import Foundation
import TelegramBotSDK

class TelegramSender: Sender {
    private let chatId: Int64
    let bot: TelegramBot

    init(token: String, chatId: Int64) {
        self.chatId = chatId
        self.bot = TelegramBot(token: token)
    }

    func send(message: String) {
        bot.sendMessageSync(
            chatId: .chat(chatId),
            text: message,
            parseMode: .markdown,
            disableWebPagePreview: true
        )
    }
}
