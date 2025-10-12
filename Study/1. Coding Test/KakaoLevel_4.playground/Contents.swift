import Foundation


//MARK: 1,2,3 떨어트리기
/// 각 부모의 자식 노드로 묶어 값을 저장 할 것

func solution_1(_ edges: [[Int]], _ target: [Int]) -> [Int] {
    // 각 숫자의 자식 표현 [ [], [], [], [], [], [],... ] 형식으로 표현하여 각 자신의 값의 자식을 찾기
    // 위의 형식은 결국 마지막 숫자와 개수가 같아야 함.
    
    var maxIndex = 0
    
    for i in edges {
        if i.count == 2 {
            maxIndex = max(maxIndex, i[0], i[1])
        }
    }
    
    var tree: [[Int]] = Array(repeating: [], count: maxIndex + 1)
    
    for i in edges {
        tree[i[0]].append(i[1])
    }
    
    var nextNode: [Int] = Array(repeating: 0, count: maxIndex + 1)
    
    var index = 0
    for i in target {
        //TODO: node로 변환하기 전에 그 값이 마지막인지 확인 후 그 값이 마지막일 때 처리 추가 하기 혹은 리스트 만들기
//        if i == 0 {
//            var node = tree[nextNode[1] + 1][nextNode[nextNode[1] + 1]]
//            while true {
//                let treeNode = tree[nextNode[node] + 1]
//                if treeNode.isEmpty { break }
//                node = treeNode[nextNode[node] + 1]
//            }
//            print(node)
//        }
        var node = tree[nextNode[1] + 1][nextNode[nextNode[1] + 1]]
        while true {
            let treeNode = tree[node]
            if treeNode.isEmpty { break }
            node = treeNode[nextNode[node]]
        }
        
    }
    
    print(tree)
    print(nextNode)
    print("1")
    return []
}

let result_1 = solution_1([[2, 4], [1, 2], [6, 8], [1, 3], [5, 7], [2, 5], [3, 6], [6, 10], [6, 9]], [0, 0, 0, 3, 0, 0, 5, 1, 2, 3])
