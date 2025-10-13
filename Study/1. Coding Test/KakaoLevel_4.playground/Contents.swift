import Foundation


//MARK: 1,2,3 떨어트리기

func solution_1(_ edges: [[Int]], _ target: [Int]) -> [Int] {
    // 노드의 사이클 찾기
    // 사이클의 최소 횟수(ceil 3)와 최대 횟수 max 값을 각각 구하고 최소 횟수의 최대 값이 이 범위 안에 있는 지 확인
    // 범위 안이라면 최소 횟수의 사이클 만큼 크기를 만들고 필요 없는 부분은 삭제 - 이부분 생각해보기 
    // 해당 리스트에 전체적으로 1을 추가하고 뒤에서 부터 값을 최대 값으로 넣어도 되는 지 확인하면서 값 변경
    var n = 0
    for i in edges { n = max(n, i[0], i[1]) }
    
    var tree = Array(repeating: [Int](), count: n + 1) // var1
    
    for i in edges { tree[i[0]].append(i[1]) }
    for i in tree.indices { tree[i] = tree[i].sorted() }
    
    var node = Array(repeating: 0, count: n+1) // var2
    
    var leaf = Array(repeating: false, count: n + 1) // var3
    for i in tree.indices {
        if tree[i].isEmpty {
            leaf[i] = true
        }
    }
    
    var cycle = [Int]() // var4
    
    var currentNode = 1
    while true {
        let nextNode = tree[currentNode][node[currentNode]]
        if leaf[nextNode] {
            cycle.append(nextNode)
            node[currentNode] = (node[currentNode] + 1) % tree[currentNode].count
            currentNode = 1
            if node.reduce(0, +) == 0 { break }
        }
        else {
            node[currentNode] = (node[currentNode] + 1) % tree[currentNode].count
            currentNode = nextNode
        }
    }
    
    
    // TODO: 이부분 좀 더 생각해보기
    var cycleDict = [Int: Int]()
    for i in cycle { cycleDict[i, default: 0] += 1 }
    
    var minRangeList = [Int]()
    var maxRangeList = [Int]()
    
    for (i,j) in cycleDict {
        
        minRangeList.append(Int(ceil(max(0,ceil(Double(target[i - 1]) / 3.0) - Double(j)) / Double(j))))
        maxRangeList.append(Int(Double(target[i - 1]) / Double(j)))
    }
    
    if minRangeList.max()! > maxRangeList.min()! { return [-1] }
    
    var cicleCount = minRangeList.max()! //var 5
    
    var result = Array(repeating: 1, count: n)
    
    
    
    
    
    print(minRangeList, maxRangeList)
    
    return []
}

let result_1 = solution_1([[2, 4], [1, 2], [6, 8], [1, 3], [5, 7], [2, 5], [3, 6], [6, 10], [6, 9]], [0, 0, 0, 3, 0, 0, 5, 1, 2, 3])
