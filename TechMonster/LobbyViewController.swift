//
//  LobbyViewController.swift
//  TechMonster
//
//  Created by Meri Sato on 2022/05/12.
//

import UIKit

class LobbyViewController: UIViewController {
    
    var maxStamina: Float = 100
    var stamina : Float = 100
    var player: Player = Player()
    var staminaTimer: Timer!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var staminaBar: UIProgressView!
    @IBOutlet var levelLabel: UILabel!
    
    @IBAction func startBattle() {
            //冒険を始めるときにスタミナを減らす
            //20より少なければアラートを出す
            if stamina >= 20 {
                stamina = stamina - 20
                staminaBar.progress = stamina / maxStamina
                performSegue(withIdentifier: "startBattle", sender: nil)
            } else {
                let alert = UIAlertController(title: "スタミナ不足", message: "スタミナが20以上必要です", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startBattle" {
            let battleVC = segue.destination as! BattleViewController
            player.currentHP = player.maxHP
            battleVC.player = player
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //標準だとスタミナバーが細いので縦に拡大
        staminaBar.transform = CGAffineTransform(scaleX: 1.0, y: 4.0)
        
        //プレイヤーのデータをセット
        nameLabel.text = player.name
        levelLabel.text = String(format: "Lv. %d", player.level)
        
        //スタミナを起動時に最大にする（保存できると良いね！）
        stamina = maxStamina
        staminaBar.progress = stamina / maxStamina
        staminaTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(cureStamina), userInfo: nil, repeats: true)
    }
    
    //BGMの再生
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TechDraUtil.playBGM(fileName: "lobby")
    }
    //BGMの停止
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        TechDraUtil.stopBGM()
    }
    
    //スタミナを回復させるメソッドcureStamina()を作成
    @objc func cureStamina(){
        if stamina < maxStamina {
            stamina = min(stamina + 1, maxStamina)
            staminaBar.progress = stamina / maxStamina
        }
    }
    
   

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

