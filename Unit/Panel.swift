//
//  Panel.swift
//  DotSystem
//
//  Created by ccc on 2022/1/10.
//

import UIKit

class Panel {
    
    private let subviewTag = 1215
    
    private let weight = 8 // 每個點的大小
    
    private let width: Int // 寬多少點
    private let height: Int // 高多少點
    
    private var dotArray: [Dot]?
    
    private var couldTapPanel = false
    
    // 正在增加黑點進序列
    private var isAddingBlackPoint = false
    private var prepareAddingDotArray: [Dot] = []
    
    init(parentView: UIView) {
        
        // 計算版面大小
        let width = parentView.bounds.width
        let height = parentView.bounds.height
        
        let panelWidth = Int(floor(width / Double(self.weight)))
        let panelHeight = Int(floor(height / Double(self.weight)))
        
        self.width = panelWidth
        self.height = panelHeight
        
    }
    
    func isPanelInteractive() -> Bool {
        return self.couldTapPanel
    }
    
    func enablePanelInteractive() {
        self.couldTapPanel = true
    }
    
    func disablePanelInteractive() {
        self.couldTapPanel = false
    }
    
    func getDotArrayCount() -> Int {
        return self.dotArray?.count ?? 0
    }
    
    func getWidth() -> Int {
        return self.width
    }
    
    func getHeight() -> Int {
        return self.height
    }
    
    func pushDot2View(parentView: UIView, setShowRange: Bool = true) {
        
        guard let dotArray = self.dotArray else {
            return
        }

        // 是否顯示範圍
        let couldShowRange = UserDefaultUtils.getShowDotRange()
        
        for dot in dotArray {
            let subview = dot.createView(weight: self.weight)
            subview.tag = self.subviewTag
            parentView.addSubview(subview)
            
            if setShowRange && couldShowRange {
                let rangeView = dot.createRangeView(weight: self.weight)
                rangeView.tag = self.subviewTag
                parentView.addSubview(rangeView)
            }
        }
        
    }
    
    func removeDotFromView(parentView: UIView) {
        
        for subview in parentView.subviews {
            if subview.tag == self.subviewTag {
                subview.removeFromSuperview()
            }
        }
    }
    
    func createDot(count: Int, besideBlack: Bool = false, onlyBlack: Bool = false) {
        
        var dotArray: [Dot] = []
        for _ in 0..<count {
            let x = Int.random(in: 0..<self.width)
            let y = Int.random(in: 0..<self.height)
            
            if besideBlack {
                dotArray.append(Dot(x: x, y: y, color: CommonUtils.validColor[Int.random(in: 1..<CommonUtils.validColor.count)]))
            } else if onlyBlack {
                dotArray.append(Dot(x: x, y: y, color: CommonUtils.validColor[0]))
            }  else {
                dotArray.append(Dot(x: x, y: y, color: CommonUtils.validColor[Int.random(in: 0..<CommonUtils.validColor.count)]))
            }
        }
        self.dotArray = dotArray
    }
    
    func autoProduceDot(count: Int, besideBlack: Bool = false, onlyBlack: Bool = false) {
        
        var autoDotArray: [Dot] = []
        for _ in 0..<count {
            let x = Int.random(in: 0..<self.width)
            let y = Int.random(in: 0..<self.height)
            
            if besideBlack {
                autoDotArray.append(Dot(x: x, y: y, color: CommonUtils.validColor[Int.random(in: 1..<CommonUtils.validColor.count)]))
            } else if onlyBlack {
                autoDotArray.append(Dot(x: x, y: y, color: CommonUtils.validColor[0]))
            } else {
                autoDotArray.append(Dot(x: x, y: y, color: CommonUtils.validColor[Int.random(in: 0..<CommonUtils.validColor.count)]))
            }
        }
        self.prepareAddingDotArray.append(contentsOf: autoDotArray)
    }
    
    func tapPanel(width: Double, height: Double) {
        
        // 不可點擊或正在新增時, 返回
        if !self.couldTapPanel || self.isAddingBlackPoint {
            return
        }
        
        let x = Int(floor(width / Double(self.weight)))
        let y = Int(floor(height / Double(self.weight)))
        
        self.prepareAddingDotArray.append(Dot(x: x, y: y, color: CommonUtils.validColor[0]))
    }
    
    func mergeAddingDotArray() {
        
        self.isAddingBlackPoint = true
        
        // 當有原本陣列, 且待合併黑點有值
        if self.dotArray != nil && !self.prepareAddingDotArray.isEmpty {
            // 則合併進去然後清空待合併
            self.dotArray?.append(contentsOf: self.prepareAddingDotArray)
            self.prepareAddingDotArray = []
        }
        
        self.isAddingBlackPoint = false
    }
    
    func calcStatus() {
        
        // dot由大到小排序
        self.sortDotArray()
        
        // 依序判斷
        self.judgeDotStatus()
        
        // 剔除已經消失的
        self.removeDiedDot()
    }
    
    func calcConwaysStatus() {
        
        guard let dotArray = self.dotArray else {
            return
        }
        
        var beforeMap: Dictionary<Int, Dictionary<Int, Int>> = [:] // 紀錄該位置附近有多少點
        var aliveMap: Dictionary<Int, Dictionary<Int, Bool>> = [:] // 紀錄該位置是否為活著的點
        
        let aroundCoordinate = [(-1, -1), (0, -1), (1, -1), (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0)]
        
        // 將點點對地圖的影響全部投射到beforeMap上
        for dot in dotArray {
            let x = dot.x
            let y = dot.y
            
            // 紀錄該位置的點為活著
            if var xRow = aliveMap[x] {
                // 將xRow增加該紀錄後, 寫到aliveMap
                xRow[y] = true
                aliveMap[x] = xRow
            } else {
                // 該x都無紀錄, 則新增一層加子層
                aliveMap[x] = [y: true]
            }
            
            // 周圍8個格子受到的影響
            for (n1, n2) in aroundCoordinate {
                let newX = x + n1
                let newY = y + n2
                
                // 超出邊界不增加
                if newX < 0 || newX >= self.width {
                    continue
                }
                
                if newY < 0 || newY >= self.height {
                    continue
                }
                
                guard var xRow = beforeMap[newX] else {
                    // 連第一層都沒有, 則新增一層加子層, 初始1
                    beforeMap[newX] = [newY: 1]
                    continue
                }
                
                guard let xRowKid = xRow[newY] else {
                    // 子層沒有, 則加子層, 初始1
                    xRow[newY] = 1
                    beforeMap[newX] = xRow
                    continue
                }
                
                // 有子層, +1上去
                xRow[newY] = xRowKid + 1
                beforeMap[newX] = xRow
            }
        }
        
        // 轉換map成為新的dotArray
        var afterDotArray: [Dot] = []
        for (xKey, xRow) in beforeMap {
            for (yKey, yRow) in xRow {
                var haveLife = false
                
                // 判斷該點原先生存狀態
                let beforeAlive = aliveMap[xKey]?[yKey] ?? false
                
                if beforeAlive {
                    // 若活細胞周圍有2~3個細胞, 則繼續存活
                    if yRow == 2 || yRow == 3 {
                        haveLife = true
                    }
                } else {
                    // 若死細胞周圍有3個細胞, 則誕生
                    if yRow == 3 {
                        haveLife = true
                    }
                }
                
                if haveLife {
                    afterDotArray.append(Dot(x: xKey, y: yKey, color: CommonUtils.validColor[0]))
                }
            }
        }
        
        // 更新dotArray
        self.dotArray = afterDotArray
    }
    
    func calcLangtonsStatus(antX: Int, antY: Int, antHead: Int) -> (Int, Int, Int) {
        
        guard var dotArray = self.dotArray else {
            return (antX, antY, antHead)
        }
        
        var dotMap: Dictionary<String, Bool> = [:]
        
        // 遍歷dotArray確認有沒有該點為黑, 並檢查重複
        var isAtBlack = false
        for i in stride(from: dotArray.count - 1, through: 0, by: -1) {
            let x = dotArray[i].x
            let y = dotArray[i].y
            
            // 判斷該點是否重複
            let locationString = "\(x)-\(y)"
            if let _ = dotMap[locationString] {
                // 該點有過值, 已經判斷過, 僅移除
                dotArray.remove(at: i)
                continue
            }
            
            // 該點第一次出現
            dotMap[locationString] = true
            
            // 出現對應點, 紀錄他正在黑色點點, 並改為白色
            if x == antX && y == antY {
                isAtBlack = true
                dotArray.remove(at: i)
            }
        }
        
        // 依照黑色或白色做處理
        let newAntX: Int
        let newAntY: Int
        var newAntHead: Int
        
        if isAtBlack {
            newAntHead = antHead - 1
            // 轉一圈
            newAntHead = newAntHead < 1 ? 4 : newAntHead
        } else {
            newAntHead = antHead + 1
            // 轉一圈
            newAntHead = newAntHead > 4 ? 1 : newAntHead
            
            // 本在白格, 將該格化為黑格
            dotArray.append(Dot(x: antX, y: antY, color: CommonUtils.validColor[0]))
        }
        
        // 更新dotArray
        self.dotArray = dotArray
        
        // 若前方撞牆則折返
        switch newAntHead {
        case 1:
            if antY - 1 < 0 {
                newAntHead = 3
            }
        case 2:
            if antX + 1 >= self.width {
                newAntHead = 4
            }
        case 3:
            if antY + 1 >= self.height {
                newAntHead = 1
            }
        case 4:
            if antX - 1 < 0 {
                newAntHead = 2
            }
        default:
            break
        }
        
        // 向前進
        switch newAntHead {
        case 1:
            newAntX = antX
            newAntY = antY - 1
        case 2:
            newAntX = antX + 1
            newAntY = antY
        case 3:
            newAntX = antX
            newAntY = antY + 1
        case 4:
            newAntX = antX - 1
            newAntY = antY
        default:
            newAntX = antX
            newAntY = antY
        }
        
        return (newAntX, newAntY, newAntHead)
    }
    
    func calcScoreBoard() -> [Dictionary<String, Any>]? {
        
        guard let dotArray = self.dotArray else {
            return nil
        }
        
        // 計算顏色數據
        var valueDict: [UIColor: Double] = [:]
        for dot in dotArray {
            let value = dot.value
            let color = dot.color
            if let oldValue = valueDict[color] {
                valueDict[color] = oldValue + value
            } else {
                valueDict[color] = value
            }
        }
        
        // 轉成array以便排序
        var valueColorArray: [Dictionary<String, Any>] = []
        for (color, value) in valueDict {
            valueColorArray.append(["color": color, "value": value])
        }
        
        // 排序顏色數據
        valueColorArray.sort(by: { (a: Dictionary<String, Any>, b: Dictionary<String, Any>) -> Bool in
            guard let va = a["value"] as? Double, let vb = b["value"] as? Double else {
                return false
            }
            return va > vb
        })
        
        return valueColorArray
    }
    
    private func sortDotArray() {
        
        guard var dotArray = self.dotArray else {
            return
        }
        
        dotArray.sort(by: { (a: Dot, b: Dot) -> Bool in
            return a.value > b.value
        })
        
    }
    
    private func judgeDotStatus() {
        
        guard let dotArray = self.dotArray else {
            return
        }
        
        for dot in dotArray {
            // 已經鼠掉就下一個
            if dot.isDied() {
                continue
            }
            
            // 偵測最佳方向, 及該方向是否有dot
            let (bestDirection, dotIndex) = self.getBestDirection(dotArray: dotArray, dot: dot)
            
            // 前往該方向
            dot.gotoDirection(direction: bestDirection, directionDot: dotIndex == -1 ? nil : dotArray[dotIndex])
        }
        
    }
    
    private func removeDiedDot() {
        
        guard var dotArray = self.dotArray else {
            return
        }
        
        for i in stride(from: dotArray.count - 1, through: 0, by: -1) {
            if dotArray[i].isDied() {
                dotArray.remove(at: i)
            }
        }
        
        // 改變了位址, 故需重新賦予
        self.dotArray = dotArray
    }
    
    private func getBestDirection(dotArray: [Dot], dot: Dot) -> (Int, Int) {
        var directionArray = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        var mapArray = [-1, -1, -1, -1, -1, -1, -1, -1, -1]
        
        // 偵測最佳方向評分
        for i in 0..<dotArray.count {
            
            let targetDot = dotArray[i]
            
            // 跑到已經被吃掉的食物時跳過
            if targetDot.isDied() {
                continue
            }
            
            // 跑到自己時跳過
            if dot.x == targetDot.x && dot.y == targetDot.y {
                continue
            }
            
            // 若在芳鄰則記錄起來
            let baseA = targetDot.x - dot.x
            let baseB = targetDot.y - dot.y
            let absA = abs(baseA)
            let absB = abs(baseB)
            if absA < 2 && absB < 2 {
                if baseA < 0 && baseB < 0 {
                    mapArray[Direction.UpperLeft] = i
                } else if baseA == 0 && baseB < 0 {
                    mapArray[Direction.Up] = i
                } else if baseA > 0 && baseB < 0 {
                    mapArray[Direction.UpperRight] = i
                } else if baseA > 0 && baseB == 0 {
                    mapArray[Direction.Right] = i
                } else if baseA > 0 && baseB > 0 {
                    mapArray[Direction.LowerRight] = i
                } else if baseA == 0 && baseB > 0 {
                    mapArray[Direction.Low] = i
                } else if baseA < 0 && baseB > 0 {
                    mapArray[Direction.LowerLeft] = i
                } else if baseA < 0 && baseB == 0 {
                    mapArray[Direction.Left] = i
                }
            }
            
            // 算斜邊長
            let powA = NSDecimalNumber(decimal: pow(Decimal(absA), 2)).doubleValue
            let powB = NSDecimalNumber(decimal: pow(Decimal(absB), 2)).doubleValue
            let hypotenuse = sqrt(powA + powB)
            
            // 如果距離超出自己的覓食範圍就跳過
            if hypotenuse > dot.r {
                continue
            }
            
            // 增加方向評分
            // 1 2 3
            // 8 0 4
            // 7 6 5
            let factor = dot.value >= targetDot.value ? 1.0 : -1.0 // 趨吉避凶因子
            let fraction = Double(targetDot.value) / hypotenuse / (powA + powB) // 每單位價值, 距離越遠越沒價值
            
            let addValueA = fraction * powA
            let addValueB = fraction * powB
            
            // 依照abs比例增加方向分數
            if baseA >= 0 && baseB >= 0 {
                // 右下角
                if absA >= absB {
                    if factor == 1 {
                        directionArray[Direction.Right] += addValueA
                        directionArray[Direction.LowerRight] += addValueB
                    } else {
                        directionArray[Direction.Left] += addValueA
                        directionArray[Direction.UpperLeft] += addValueB
                    }
                } else {
                    if factor == 1 {
                        directionArray[Direction.LowerRight] += addValueA
                        directionArray[Direction.Low] += addValueB
                    } else {
                        directionArray[Direction.UpperLeft] += addValueA
                        directionArray[Direction.Up] += addValueB
                    }
                }
            } else if baseA >= 0 && baseB <= 0 {
                // 右上角
                if absA >= absB {
                    if factor == 1 {
                        directionArray[Direction.Right] += addValueA
                        directionArray[Direction.UpperRight] += addValueB
                    } else {
                        directionArray[Direction.Left] += addValueA
                        directionArray[Direction.LowerLeft] += addValueB
                    }
                } else {
                    if factor == 1 {
                        directionArray[Direction.UpperRight] += addValueA
                        directionArray[Direction.Up] += addValueB
                    } else {
                        directionArray[Direction.LowerLeft] += addValueA
                        directionArray[Direction.Low] += addValueB
                    }
                }
            } else if baseA <= 0 && baseB >= 0 {
                // 左下角
                if absA >= absB {
                    if factor == 1 {
                        directionArray[Direction.Left] += addValueA
                        directionArray[Direction.LowerLeft] += addValueB
                    } else {
                        directionArray[Direction.Right] += addValueA
                        directionArray[Direction.UpperRight] += addValueB
                    }
                } else {
                    if factor == 1 {
                        directionArray[Direction.LowerLeft] += addValueA
                        directionArray[Direction.Low] += addValueB
                    } else {
                        directionArray[Direction.UpperRight] += addValueA
                        directionArray[Direction.Up] += addValueB
                    }
                }
            } else if baseA <= 0 && baseB <= 0 {
                // 左上角
                if absA >= absB {
                    if factor == 1 {
                        directionArray[Direction.Left] += addValueA
                        directionArray[Direction.UpperLeft] += addValueB
                    } else {
                        directionArray[Direction.Right] += addValueA
                        directionArray[Direction.LowerRight] += addValueB
                    }
                } else {
                    if factor == 1 {
                        directionArray[Direction.UpperLeft] += addValueA
                        directionArray[Direction.Up] += addValueB
                    } else {
                        directionArray[Direction.LowerRight] += addValueA
                        directionArray[Direction.Low] += addValueB
                    }
                }
            }
        }
        
        // 選擇最佳方位回傳, 多個相同值則紀錄後random
        var returnDirectionArray = [0]
        for i in 1..<directionArray.count {
            
            // 判斷若是超出邊界則跳過
            if !dot.isDirectionValid(width: self.width, height: self.height, direction: i) {
                continue
            }
            
            let oldValue = directionArray[returnDirectionArray[0]]
            let compareValue = directionArray[i]
            
            // 若是相等, 則新增進去array
            if oldValue == compareValue {
                returnDirectionArray.append(i)
            } else if oldValue < compareValue {
                // 若小於則將array清空塞入新值
                returnDirectionArray = [i]
            }
        }
        
        // 若returnDirectionArray有多個表示可以選擇很多路, random出結果
        let returnDirection = returnDirectionArray[Int.random(in: 0..<returnDirectionArray.count)]
        
        return (returnDirection, mapArray[returnDirection])
    }
    
}
