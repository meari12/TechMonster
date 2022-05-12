//
//  BattleViewController.swift
//  TechMonster
//
//  Created by Meri Sato on 2022/05/12.
//

import UIKit

class BattleViewController: UIViewController {
    
    //敵を自動的に攻撃する
    var enemyAttackTimer: Timer!
    
    var enemy: Enemy!
    
    var player: Player! //LobbyViewControllerから渡される
    
    @IBOutlet var attackButton: UIButton!
    
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var playerImageView: UIImageView!
    
    @IBOutlet var enemyHPBar: UIProgressView!
    @IBOutlet var playerHPBar: UIProgressView!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var playerNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //標準だとProgressBarが細いので拡大
        enemyHPBar.transform = CGAffineTransform(scaleX: 1.0, y: 4.0)
        playerHPBar.transform = CGAffineTransform(scaleX: 1.0, y: 4.0)
        
        //プレイヤーのデータをセット
        playerNameLabel.text = player.name
        playerImageView.image = player.image
        playerHPBar.progress = player.currentHP / player.maxHP
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startBattle()
    }
    
    func startBattle(){
        TechDraUtil.playBGM(fileName: "Dance_With_Powder")
        
        enemy = Enemy()
        
        //敵のデータをセット
        enemyNameLabel.text = enemy.name
        enemyImageView.image = enemy.image
        enemyHPBar.progress = enemy.currentHP / enemy.maxHP
        
        //攻撃ボタンを表示
        attackButton.isHidden = false
        
        //敵の自動攻撃
        enemyAttackTimer = Timer.scheduledTimer(timeInterval: enemy.attackInterval, target: self, selector: #selector(enemyAttack), userInfo: nil, repeats: true)
    }
    
    //攻撃ボタンを押すと、攻撃処理を行う
    @IBAction func playerAttack(){
        TechDraUtil.animateDamage(enemyImageView)
        TechDraUtil.playSE(fileName: "SE_attack")
        
        //HPの更新
        enemy.currentHP = enemy.currentHP - player.attackPower
        enemyHPBar.setProgress(enemy.currentHP / enemy.maxHP, animated: true)
        
        //敵の敗北
        if enemy.currentHP < 0 {
            TechDraUtil.animateVanish(enemyImageView)
            finishBattle(isPlayerWin: true)
        }
    }
    
    //バトルが終わった時の処理
    func finishBattle(isPlayerWin: Bool) {
        TechDraUtil.stopBGM()
        
        //攻撃ボタンを隠す
        attackButton.isHidden = true
        
        //敵の自動攻撃を止める
        enemyAttackTimer.invalidate()
        
        //アラートを表示
        let finishedMessage : String
        if isPlayerWin{
            TechDraUtil.playSE(fileName: "SE_fanfare")
            finishedMessage = "プレイヤーの勝利！！"
        } else {
            TechDraUtil.playSE(fileName: "SE_gameover")
            finishedMessage = "プレイヤーの敗北..."
        }
        let alert = UIAlertController(title: "バトル終了！", message: finishedMessage, preferredStyle: .alert)
        //OKを押すと、モーダルを消してLobbyViewControllerに戻る
        let action = UIAlertAction(title: "OK", style: .default, handler: {action in self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
}
    
    //敵を自動で攻撃するようにする　playerAttack()と逆の操作を行うenemyAttack()を作成
    @objc func enemyAttack(){
        TechDraUtil.animateDamage(playerImageView)
        TechDraUtil.playBGM(fileName: "SE_attack")
        
        //HPの更新
        player.currentHP = player.currentHP - player.attackPower
        playerHPBar.setProgress(player.currentHP / player.maxHP, animated: true)
        
        //プレイヤーの敗北
        if player.currentHP < 0 {
            TechDraUtil.animateVanish(playerImageView)
            finishBattle(isPlayerWin: false)
        }
    }

        // Do any additional setup after loading the view.


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
