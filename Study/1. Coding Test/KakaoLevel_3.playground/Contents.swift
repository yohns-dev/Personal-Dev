import Foundation

//MARK: 주사위 고르기

func solution_1(_ dice: [[Int]]) -> [Int] {
    let n = dice.count
    let k = n/2
    
    //초기 설정 1,2,...,k
    var diceCombine: [Int] = Array(0..<k)
    var bestCombine: [Int] = diceCombine
    var bestWinRate: Double = 0
    
    while true {
        
        // 주사위 고르기
        var chosenDice = Array(repeating: false, count: n)
        for i in 0..<k { chosenDice[diceCombine[i]] = true }
        var bCombine: [Int] = []
        for i in 0..<n { if !chosenDice[i] { bCombine.append(i) } }
        
        // 합 경우의 수
        var sumADict: [Int : Int] = [0 : 1]
        for i in diceCombine {
            var sum = [Int : Int]()
            for (pSum, pCount) in sumADict {
                for num in dice[i] {
                    sum[pSum + num, default: 0] += pCount
                }
            }
            sumADict = sum
        }
        
        var sumBDict: [Int : Int] = [0 : 1]
        for i in bCombine {
            var sum = [Int : Int]()
            for (pSum, pCount) in sumBDict {
                for num in dice[i] {
                    sum[pSum + num, default: 0] += pCount
                }
            }
            sumBDict = sum
        }
        
        // A의 경우가 B보다 큰 경우
        let minSumB = sumBDict.keys.min() ?? 0
        let maxSumB = sumBDict.keys.max() ?? 0
        let offset = -minSumB
        var winBArray = Array(repeating: 0, count: maxSumB - minSumB + 1)
        for (sum, count) in sumBDict { winBArray[sum + offset] += count }
        
        for i in 1..<winBArray.count { winBArray[i] += winBArray[i - 1] }
        
        var winCount : Int = 0
        for (sumA, countA) in sumADict {
            if (sumA - 1) >= minSumB {
                let index = min(sumA - 1 + offset, winBArray.count - 1)
                if index >= 0 { winCount += countA * winBArray[index] }
            }
        }
        
        // 승률 계산
        let totalCount = sumADict.values.reduce(0, +) * sumBDict.values.reduce(0, +)
        let rate = Double(winCount) / Double(totalCount)
        if rate > bestWinRate {
            bestWinRate = rate
            bestCombine = diceCombine
        }
        
        // 다음 조합 변경
        var i = k - 1
        while i >= 0 && diceCombine[i] == i + n - k { i -= 1 }
        if i < 0 { break }
        diceCombine[i] += 1
        var j = i + 1
        while j < k {
            diceCombine[j] = diceCombine[j - 1] + 1
            j += 1
        }
    }
    
    return bestCombine.map { $0 + 1 }
}

//let result_1 = solution_1([[1, 2, 3, 4, 5, 6], [3, 3, 3, 3, 4, 4], [1, 3, 3, 4, 4, 4], [1, 1, 4, 4, 5, 5]])

//MARK: n+1 카드 게임

func solution_2(_ coin: Int, _ cards: [Int]) -> Int {
    let n = cards.count
    var coins = coin
    var target = n + 1
    var hand = Set(cards.prefix(n/3))
    var pool = Set<Int>()
    var index = n/3
    var rounds = 1
    
    while true {
        if index >= n { break }
        pool.insert(cards[index])
        index += 1
        
        if index < n { pool.insert(cards[index]); index += 1 }
        
        var card1 = -1, card2 = -1
        var found = false
        
        // 손에 있는 경우
        for i in hand {
            let value = target - i
            if value != i && hand.contains(value) {
                card1 = i
                card2 = value
                found = true
            }
        }
        
        if found {
            hand.remove(card1)
            hand.remove(card2)
            rounds += 1
            continue
        }
        
        //코인 한개로 가능한 경우
        if coins >= 1 {
            for i in hand {
                let value = target - i
                if pool.contains(value) { card1 = i; card2 = value; found = true; break }
            }
            
            if found {
                hand.remove(card1)
                pool.remove(card2)
                coins -= 1
                rounds += 1
                continue
            }
        }
        
        //코인 2개로 되는 경우
        
        if coins >= 2 {
            for i in pool {
                let value = target - i
                if value != i && pool.contains(value) { card1 = i; card2 = value; found = true; break }
            }
            if found {
                pool.remove(card1)
                pool.remove(card2)
                coins -= 2
                rounds += 1
                continue
            }
        }
        
        break
        
    }
    
    return rounds
}

//let result_2 = solution_2(3, [1, 2, 3, 4, 5, 8, 6, 7, 9, 10, 11, 12])

//MARK: 산 모양 타일링

func solution_3(_ n: Int, _ tops: [Int]) -> Int {
    let m = 10007
    var a = 1
    var b = (tops[0] == 1 ? 3 : 2) % m
    if 2 * n == 1 { return b }
    
    var cur = 0
    if 2 * n >= 2 {
        for i in 2...(2 * n) {
            if i % 2 == 1 && tops[i / 2] == 1 { cur = ( (b * 2) % m + a ) % m }
            else { cur = (b + a) % m }
            a = b
            b = cur
        }
    }
    return b % m
}

let result_3 = solution_3(4, [1, 1, 0, 1])

//MARK:

func solution_4() {
    
}

let result_4 = 0

//MARK:

func solution_5() {
    
}

let result_5 = 0

//MARK:

func solution_6() {
    
}

let result_6 = 0

//MARK:

func solution_7() {
    
}

let result_7 = 0

//MARK:

func solution_8() {
    
}

let result_8 = 0

//MARK:

func solution_9() {
    
}

let result_9 = 0

//MARK:

func solution_10() {
    
}

let result_10 = 0

//MARK:

func solution_11() {
    
}

let result_11 = 0

//MARK:

func solution_12() {
    
}

let result_12 = 0

//MARK:

func solution_13() {
    
}

let result_13 = 0

//MARK:

func solution_14() {
    
}

let result_14 = 0

//MARK:

func solution_15() {
    
}

let result_15 = 0


