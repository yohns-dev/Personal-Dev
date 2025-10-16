import Foundation

//MARK: 1,2,3 떨어트리기

func solution_1(_ edges: [[Int]], _ target: [Int]) -> [Int] {
    var n = 0
    for i in edges { n = max(n, i[0], i[1]) }
    var tree = Array(repeating: [Int](), count: n + 1)
    for i in edges { tree[i[0]].append(i[1]) }
    for i in tree.indices { tree[i].sort() }
    
    var node = Array(repeating: 0, count: n+1)
    var leaf = Array(repeating: false, count: n + 1)
    for i in tree.indices { if tree[i].isEmpty { leaf[i] = true } }
    
    var cycle = [Int]()
    
    var nonZeroPtrCount = 0
    var currentNode = 1
    while true {
        if tree[currentNode].isEmpty {
            let allZero = (1...n).filter { leaf[$0] }.allSatisfy { target[$0 - 1] == 0 }
            return allZero ? [] : [-1]
        }
        let nextNode = tree[currentNode][node[currentNode]]
        
        if leaf[nextNode] {
            cycle.append(nextNode)
            
            let before = node[currentNode]
            let deg = tree[currentNode].count
            let after = (before + 1) % deg
            
            if before == 0 && after != 0 { nonZeroPtrCount += 1 }
            if before != 0 && after == 0 { nonZeroPtrCount -= 1 }
            node[currentNode] = after
            
            currentNode = 1
            
            if nonZeroPtrCount == 0 { break }
        } else {
            let before = node[currentNode]
            let deg = tree[currentNode].count
            let after = (before + 1) % deg
            if before == 0 && after != 0 { nonZeroPtrCount += 1 }
            if before != 0 && after == 0 { nonZeroPtrCount -= 1 }
            node[currentNode] = after
            currentNode = nextNode
        }
    }
    
    var leafListAll = [Int]()
    for i in 1...n { if leaf[i] { leafListAll.append(i) } }
    
    var inCycleLeafSet = Set<Int>()
    for v in cycle { inCycleLeafSet.insert(v) }
    var leafList = [Int]()
    for v in leafListAll { if inCycleLeafSet.contains(v) { leafList.append(v) } }
    
    var leafCycleCount = [Int:Int]()
    for v in cycle { leafCycleCount[v, default: 0] += 1 }
    
    var minCycleCount = [Int:Int]()
    var maxCycleCount = [Int:Int]()
    var totalTarget = 0
    for v in leafList {
        let t = target[v - 1]
        totalTarget += t
        minCycleCount[v] = (t + 2) / 3
        maxCycleCount[v] = t
    }
    let minTotalSum = leafList.reduce(0) { $0 + (minCycleCount[$1] ?? 0) }
    if totalTarget < minTotalSum { return [-1] }
    if minTotalSum == 0 { return totalTarget == 0 ? [] : [-1] }
    
    let cycleCount = cycle.count
    if cycleCount == 0 { return totalTarget == 0 ? [] : [-1] }
    
    var posList = [Int:[Int]]()
    for (idx, v) in cycle.enumerated() { posList[v, default: []].append(idx) }
    
    var bestMid = Int.max
    var remValue = 0
    while remValue < cycleCount {
        var fullLow = Int.min
        var fullHigh = Int.max
        var feasible = true
        
        for v in leafList {
            let f = leafCycleCount[v] ?? 0
            var pref = 0
            if remValue > 0 {
                let arr = posList[v] ?? []
                var lo = 0, hi = arr.count
                let key = remValue - 1
                while lo < hi {
                    let mid = (lo + hi) >> 1
                    if arr[mid] <= key { lo = mid + 1 } else { hi = mid }
                }
                pref = lo
            }
            let loNeed = (minCycleCount[v] ?? 0) - pref
            let hiNeed = (maxCycleCount[v] ?? 0) - pref
            
            if f == 0 {
                if !(loNeed <= 0 && 0 <= hiNeed) { feasible = false; break }
            } else {
                let lo = (loNeed <= 0) ? 0 : ((loNeed + f - 1) / f)
                let hi = hiNeed / f
                if lo > hi { feasible = false; break }
                if lo > fullLow { fullLow = lo }
                if hi < fullHigh { fullHigh = hi }
                if fullLow > fullHigh { feasible = false; break }
            }
        }
        
        if feasible && fullLow <= fullHigh {
            let mid = fullLow * cycleCount + remValue
            if mid >= minTotalSum && mid <= totalTarget {
                if mid < bestMid { bestMid = mid }
            }
        }
        remValue += 1
    }
    if bestMid == Int.max { return [-1] }
    let ans = bestMid
    
    var remaining = [Int:Int]()
    var needSum = [Int:Int]()
    let full = ans / cycleCount
    let rem = ans % cycleCount
    
    for v in leafList {
        let base = (leafCycleCount[v] ?? 0) * full
        var extra = 0
        if rem > 0 {
            let arr = posList[v] ?? []
            var lo = 0, hi = arr.count
            let key = rem - 1
            while lo < hi {
                let mid = (lo + hi) >> 1
                if arr[mid] <= key { lo = mid + 1 } else { hi = mid }
            }
            extra = lo
        }
        remaining[v] = base + extra
        needSum[v] = target[v - 1]
    }
    
    var result = Array(repeating: 0, count: ans)
    var index = ans - 1
    while index >= 0 {
        let v = cycle[index % cycleCount]
        let r = remaining[v] ?? 0
        let need = needSum[v] ?? 0
        if r <= 0 { return [-1] }
        let lower = max(1, need - 3 * (r - 1))
        let upper = min(3, need - (r - 1))
        if lower > upper || upper < 1 { return [-1] }
        let put = upper
        result[index] = put
        needSum[v] = need - put
        remaining[v] = r - 1
        index -= 1
    }
    return result
}

//let result_1 = solution_1( [[2, 4], [1, 2], [6, 8], [1, 3], [5, 7], [2, 5], [3, 6], [6, 10], [6, 9]], [0, 0, 0, 3, 0, 0, 5, 1, 2, 3] )

//MARK: 행렬과 연산
///  col기준 3개의 리스트로 만들어 회전 및 쉬프트 구현하기

func solution_2(_ rc: [[Int]], _ operations: [String]) -> [[Int]] {
    
    return []
}

let result_2 = solution_2([[1, 2, 3], [4, 5, 6], [7, 8, 9]], ["Rotate", "ShiftRow"])

//MARK: 미로 탈출
///Dijkstra 이용하기
func solution_3(_ n: Int, _ start: Int, _ end: Int, _ roads: [[Int]], _ traps: [Int]) -> Int {
    
    return 0
}

let result_3 = solution_3(3, 1, 3, [[1, 2, 2], [3, 2, 3]], [2])

//MARK: 매출 하락 최소화
/// 그리드 방식 -> 각 팀에서 매출이 가장 적은 한 사람을 택하여 시작 -> 각 팀의 팀원이며 팀장인 사람으로 하나씩 변경하여 값 비교 방식

func solution_4(_ sales: [Int], _ links: [[Int]]) -> Int {
    
    return 0
}

let result_4 = solution_4([14, 17, 15, 18, 19, 14, 13, 16, 28, 17], [[10, 8], [1, 9], [9, 7], [5, 4], [1, 5], [5, 10], [10, 6], [1, 3], [10, 2]])
