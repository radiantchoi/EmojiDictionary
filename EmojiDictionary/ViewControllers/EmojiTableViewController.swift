//
//  EmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Gordon Choi on 2021/05/04.
//

import UIKit

class EmojiTableViewController: UITableViewController {
    
    var emojis = [Emoji]()

}

extension EmojiTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let savedEmojis = Emoji.loadFromFile() {
            emojis = savedEmojis
        } else {
            emojis = Emoji.loadSampleEmojis()
            print("Error!")
        }
        
 
        tableView.cellLayoutMarginsFollowReadableWidth = true // 패드 같은 큰 뷰에서 합리적인 간격 유지
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension EmojiTableViewController {
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // 따로 섹션이 없으므로 1을 출력. 물론 함수 내용을 아예 비워줘도 된다.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return emojis.count // 첫 번째 섹션에 표시할 데이터의 갯수
        } else {
            return 0 // 섹션이 하나뿐이므로
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell // as!는 force downcast
        
        let emoji = emojis[indexPath.row] // section변수는 생략. 섹션이 어차피 한개니까
        
        cell.update(with: emoji)
        cell.showsReorderControl = true // 각 줄이 움직일 수 있게끔
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete // .none은 아무것도 표시하지 않는 것, .delete는 빨간 삭제 아이콘, .insert는 파란 추가 아이콘을 생성한다.
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            emojis.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedEmoji = emojis.remove(at: fromIndexPath.row) // 위치 변경한 이모지를 row 목록에서 지우고
        emojis.insert(movedEmoji, at: to.row) // 새로 목록에 넣은 다음
        tableView.reloadData() // 데이터 새로고침
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditEmoji" {
            let indexPath = tableView.indexPathForSelectedRow!
            let emoji = emojis[indexPath.row]
            let navController = segue.destination as! UINavigationController
            let addEditEmojiTableViewController = navController.topViewController as! AddEditEmojiTableViewController
            
            addEditEmojiTableViewController.emoji = emoji
        }
    }
    
}

extension EmojiTableViewController {
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) { // 좌상단 edit 버튼을 만들었고, 그걸 누를 때의 액션
        let tableViewEditingMode = tableView.isEditing // 에딧 모드로 들어가자는 것
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue) {
        
        guard segue.identifier == "saveUnwind", let sourceViewController = segue.source as? AddEditEmojiTableViewController,
              let emoji = sourceViewController.emoji else { return }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            emojis[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            let newIndexPath = IndexPath(row: emojis.count, section: 0)
            emojis.append(emoji)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        Emoji.saveToFile(emojis: emojis)
    }
}
