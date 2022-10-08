//
//  TelegramSender.swift
//  MorningBot
//
//  Created by Ezequiel Becerra on 05/10/2022.
//

import Foundation
import TelegramBotSDK

class TelegramSender: Sender {
    private let chatId: TelegramBotSDK.ChatId
    let bot: TelegramBot

    init(token: String, chatId: TelegramBotSDK.ChatId) {
        self.chatId = chatId
        self.bot = TelegramBot(token: token)
    }

    func send(message: String, notify: Bool) {
        bot.sendMessageSync(
            chatId: chatId,
            text: message,
            parseMode: .markdown,
            disableWebPagePreview: true,
            disableNotification: !notify
        )
    }
}
