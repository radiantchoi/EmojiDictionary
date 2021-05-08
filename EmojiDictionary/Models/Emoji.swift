//
//  Emoji.swift
//  EmojiDictionary
//
//  Created by Gordon Choi on 2021/05/04.
//

import Foundation

struct Emoji: Codable {
    
    var symbol: String
    var name: String
    var description: String
    var usage: String
    
    // static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! // 예제에 써 있던 코드
    // static let ArchiveURL = DocumentsDirectory.appendingPathComponent("emojis")
    
    /* func archiveURL() -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } // 참조 후 1차로 작성한 코드
        return documentsDirectory.appendingPathComponent("emojis")
    } */
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("emojis") // archiveURL을 함수로 지정하는 게 더 좋아 보이지만, 예제에서 상수로 지정했으니 오류 없을 것으로 판단
    
    init(symbol: String, name: String, description: String, usage: String) {
        self.symbol = symbol
        self.name = name
        self.description = description
        self.usage = usage
    }
    
}

extension Emoji {
    
    // 참고한 사이트 : https://stackoverflow.com/questions/53580240/ios-12-0-alternative-to-using-deprecated-archiverootobjecttofile/59748923#59748923
    
    static func saveToFile(emojis: [Emoji]) {
        // NSKeyedArchiver.archiveRootObject(emojis, toFile: Emoji.archiveURL.path) // ios 12 이후로 지원이 종료된 메서드
        let targetURL = archiveURL
        guard let dataToBeArchived = try? NSKeyedArchiver.archivedData(withRootObject: emojis, requiringSecureCoding: true) else { return }
        
        try? dataToBeArchived.write(to: targetURL)
        
    }
    
    static func loadFromFile() -> [Emoji]? {
        // return NSKeyedUnarchiver.unarchiveObject(withFile: Emoji.archiveURL.path) as? [Emoji] // ios 12 이후로 지원이 종료된 메서드
        let targetURL = archiveURL 
        guard let archivedData = try? Data(contentsOf: targetURL),
              let customObject = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedData)) as? [Emoji] else { return nil }
        
        return customObject
        
    }
    
    static func loadSampleEmojis() -> [Emoji] {
        [
        Emoji(symbol: "😀", name: "Grinning Face", description: "A typical smiley face.", usage: "happiness"),
        Emoji(symbol: "😕", name: "Confused Face", description: "A confused, puzzled face.", usage: "unsure what to think; displeasure"),
        Emoji(symbol: "😍", name: "Heart Eyes", description: "A smiley face with hearts for eyes.", usage: "love of something; attractive"),
        Emoji(symbol: "👮", name: "Police Officer", description: "A police officer wearing a blue cap with a gold badge.", usage: "person of authority"),
        Emoji(symbol: "🐢", name: "Turtle", description: "A cute turtle.", usage: "Something slow"),
        Emoji(symbol: "🐘", name: "Elephant", description: "A gray elephant.", usage: "good memory"),
        Emoji(symbol: "🍝", name: "Spaghetti", description: "A plate of spaghetti.", usage: "spaghetti"),
        Emoji(symbol: "🎲", name: "Die", description: "A single die.", usage: "taking a risk, chance; game"),
        Emoji(symbol: "⛺️", name: "Tent", description: "A small tent.", usage: "camping"),
        Emoji(symbol: "📚", name: "Stack of Books", description: "Three colored books stacked on each other.", usage: "homework, studying"),
        Emoji(symbol: "💔", name: "Broken Heart", description: "A red, broken heart.", usage: "extreme sadness"),
        Emoji(symbol: "💤", name: "Snore", description: "Three blue \'z\'s.", usage: "tired, sleepiness"),
        Emoji(symbol: "🏁", name: "Checkered Flag", description: "A black-and-white checkered flag.", usage: "completion")
        ]
    }
    
}
