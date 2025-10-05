import Foundation

//MARK: 뉴스 클러스터링
func newsClustingSolution(_ str1: String, _ str2: String) -> Int {
    var result: Int = 0
    var str1Dict = [String : Int]()
    var str2Dict = [String : Int]()
    var intersectionCount: Int = 0
    
    let transStr1 = str1.replacingOccurrences(of: #"[^a-zA-Z]"#, with: " ", options: .regularExpression).lowercased()
    let transStr2 = str2.replacingOccurrences(of: #"[^a-zA-Z]"#, with: " ", options: .regularExpression).lowercased()
    
    let str1List = zip(transStr1, transStr1.dropFirst()).map { String($0) + String($1) }.filter { !$0.contains(" ") }
    let str2List = zip(transStr2, transStr2.dropFirst()).map { String($0) + String($1) }.filter { !$0.contains(" ") }
    
    if str1List.isEmpty && str2List.isEmpty {
        return 65536
    }
    
    for i in str1List { str1Dict[i, default: 0] += 1 }
    for i in str2List { str2Dict[i, default: 0] += 1 }
    
    for (key, value) in str1Dict {
        if let str2Count = str2Dict[key] {
            let count = min(value, str2Count)
            intersectionCount += count
        }
    }
    result = Int((Double(intersectionCount) / Double((str1List.count + str2List.count) - intersectionCount)) * 65536.0)
    
    return result
}

let result_1 = newsClustingSolution("handshake", "shake hands")


//MARK: 프렌즈 4블록
/// coordinatePlane[m][n]
/// 나중에 remove나 리스트 부분을 수정해서 최소화 가능
func friends4BlockSolution(_ m: Int, _ n: Int, _ board: [String]) -> Int {
    var result: Int = 0
    var coordinatePlane = board.map { Array($0) }
    var disappearDict = [String : Bool]()
    
    while true {
        for i in 0..<m-1 {
            for j in 0..<n-1 {
                if coordinatePlane[i][j] == " " { continue }
                
                if coordinatePlane[i][j] == coordinatePlane[i+1][j+1] && coordinatePlane[i][j] == coordinatePlane[i+1][j] && coordinatePlane[i][j] == coordinatePlane[i][j+1] {
                    disappearDict["\(i),\(j)"] = true
                    disappearDict["\(i+1),\(j)"] = true
                    disappearDict["\(i),\(j+1)"] = true
                    disappearDict["\(i+1),\(j+1)"] = true
                }
            }
        }
        
        if disappearDict.count == 0 {
            break
        }
        
        
        for i in disappearDict.keys {
            let keyArray = i.split(separator: ",").map { Int($0)! }
            coordinatePlane[keyArray[0]][keyArray[1]] = " "
        }
        
        result += disappearDict.count
        disappearDict.removeAll()
        
        for i in 0..<n {
            var emptyList: [Int] = []
            for j in stride(from: m-1, through: 0, by: -1) {
                if coordinatePlane[j][i] == " " {
                    emptyList.append(j)
                    continue
                }
                else if coordinatePlane[j][i] != " " && !emptyList.isEmpty {
                    coordinatePlane[emptyList.first ?? j][i] = coordinatePlane[j][i]
                    coordinatePlane[j][i] = " "
                    emptyList.append(j)
                    emptyList.removeFirst()
                }
            }
        }
    }
    
    
    return result
}

let result_2 = friends4BlockSolution(4,5, ["CCBDE", "AAADE", "AAABF", "CCBBF"])
