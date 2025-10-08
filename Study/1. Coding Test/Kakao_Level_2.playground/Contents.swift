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

//MARK: 방금 그 곡

func findMusicSolution(_ m: String, _ musicinfos: [String]) -> String {
    var resultDict = [(String, Int)]()
    
    for i in musicinfos {
        //        let mTransString = findMusicSolution_sub_SharpStringToLowecaseString(m, regex: /[A-Z]#?/)
        let mTransString = findMusicSolution_sub_SharpStringToLowecaseString(m, separator: "#")
        var musicinfoToList = i.split(separator: ",").map { String($0) }
        let playTime = findMusicSolution_sub_DateDistance(musicinfoToList[0], musicinfoToList[1])
        //정규식을 사용하지 않는 방식
        musicinfoToList[3] = findMusicSolution_sub_SharpStringToLowecaseString(String(musicinfoToList[3]), separator: "#")
        //        musicinfoToList[3] = findMusicSolution_sub_SharpStringToLowecaseString(String(musicinfoToList[3]), regex: /[A-Z]#?/)
        let totalPlayTone = String(repeating: musicinfoToList[3], count: (playTime / musicinfoToList[3].count) + 1).prefix(playTime)
        
        if totalPlayTone.contains(mTransString) {
            resultDict.append( (String(musicinfoToList[2]), playTime))
        }
    }
    
    if resultDict.isEmpty {
        return "(None)"
    }
    else {
        guard let result = resultDict.max(by: {$0.1 < $1.1}) else { return "" }
        return result.0
    }
}

func findMusicSolution_sub_SharpStringToLowecaseString(_ s: String, regex: Regex<Substring>) -> String {
    let transToLowerCase = s.matches(of: regex).map {
        if String($0.0).count != 1 {
            let transResult = String($0.0).lowercased().dropLast(1)
            return String(transResult)
        }
        else {
            return String($0.0)
        }
    }
    
    let result = transToLowerCase.reduce(into: "", { $0 += $1 })
    
    return result
    
}

func findMusicSolution_sub_SharpStringToLowecaseString(_ s: String, separator: String? = nil) -> String {
    if separator != nil {
        var separatorList: [String] = []
        var buffer: String = ""
        guard let separator = separator else { return "" }
        for str in s {
            if String(str) != separator { buffer += String(str) }
            else {
                let trans = buffer.last?.lowercased() ?? ""
                buffer.removeLast(1)
                buffer += trans
                separatorList.append(buffer)
                buffer = ""
            }
        }
        
        separatorList.append(buffer)
        
        let result = separatorList.reduce(into: "") { $0 += $1 }
        
        return result
    }
    
    return ""
}

func findMusicSolution_sub_DateDistance(_ time1: String, _ time2: String) -> Int {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    
    let start = formatter.date(from: time1)!
    let end = formatter.date(from: time2)!
    
    let distance = Calendar.current.dateComponents([.minute], from: start, to: end).minute ?? 0
    
    return Int(abs(distance))
}

let result_3 = findMusicSolution("ABC", ["12:00,12:14,HELLO,C#DEFGAB", "13:00,13:05,WORLD,ABCDEF"])

//MARK: 압축

func compressionSolution(_ msg: String) -> [Int] {
    var result = [Int]()
    var compressionDict = [String: Int]()
    let msgList = Array(String(msg))
    let alphabetUnicodeList = (UnicodeScalar("A").value...UnicodeScalar("Z").value).compactMap {
        String(UnicodeScalar($0)!)
    }
    
    for i in alphabetUnicodeList.indices {
        compressionDict[alphabetUnicodeList[i]] = i+1
    }
    
    var index = 1
    var compareString = ""
    
    for i in msgList {
        index += 1
        if let value = compressionDict[compareString + String(i)] {
            compareString += String(i)
            continue
        }
        else {
            result.append(compressionDict[compareString]!)
            compareString += String(i)
            compressionDict[compareString] = compressionDict.count + 1
            compareString = String(i)
            
        }
    }
    
    if index == msgList.count + 1 {
        result.append(compressionDict[compareString]!)
    }
    
    return result
}

let result_4 = compressionSolution("TOBEORNOTTOBEORTOBEORNOT")

//MARK: 파일명 정렬
func fileNameSortingSolution(_ files: [String]) -> [String] {
    let trans = files.sorted {
        let right = fileNameSortingSolution_sub_separator($0)
        let left = fileNameSortingSolution_sub_separator($1)
        if right[0].lowercased() == left[0].lowercased() {
            return Int(right[1])! < Int(left[1])!
        }
        else {
            return right[0].lowercased() < left[0].lowercased()
        }
    }
    
    return trans
}

func fileNameSortingSolution_sub_separator(_ str: String) -> [String] {
    var header: String = ""
    var number: String = ""
    var isNotTransed: Bool = false
    var isEtc: Bool = false
    
    for i in str {
        if (i.isLetter || i == "-" || i == "." || i == " ") && !isNotTransed {
            header += String(i)
        }
        else if isNotTransed && i.isLetter {
            isEtc = true
        }
        else if i.isNumber && !isEtc {
            if !isNotTransed { isNotTransed = true }
            number += String(i)
        }
    }
    
    return [header, number]
}

let result_5 = fileNameSortingSolution(["F-5 Freedom Fighter", "B-50 Superfortress", "A-10 Thunderbolt II", "F-14 Tomcat2311dsaad"])

//MARK: n진수 게임

func nNumberGameSolution(_ n: Int, _ t: Int, _ m: Int, _ p: Int) -> String {
    var result = ""
    var nNumberString = ""
    for i in 0..<t*m {
        let nNumber = String(i, radix: n).uppercased()
        nNumberString += nNumber
    }
    
    result = String(nNumberString.enumerated()
        .filter { index, _ in index % m == (p-1)}
        .reduce(into: "") { result, element in
            result.append(element.element)
        }
        .prefix(t))
    
    return result
}

let result_6 = nNumberGameSolution(16, 16, 2, 1)

//MARK: 오픈 채팅방

func openChatSolution(_ record: [String]) -> [String] {
    var result = [String]()
    var userDict = [String: String]()
    var eventList = [(String, String)]()
    
    for i in record {
        let splitedRecord = i.split(separator: " ")
        eventList.append((String(splitedRecord[0]), String(splitedRecord[1])))
        if splitedRecord[0] != "Leave" {
            userDict[String(splitedRecord[1])] = String(splitedRecord[2])
        }
        
    }
    
    for i in eventList {
        switch i.0 {
        case "Enter": result.append("\(userDict[String(i.1)]!)님이 들어왔습니다.")
        case "Leave": result.append("\(userDict[String(i.1)]!)님이 나갔습니다.")
        case "Change": continue
        default:
            continue
        }
    }
    
    return result
}

let result_7 = openChatSolution(["Enter uid1234 Muzi", "Enter uid4567 Prodo","Leave uid1234","Enter uid1234 Prodo","Change uid4567 Ryan"])

//MARK: 후보키

func candidateKeySolution(_ relation: [[String]]) -> Int {
    let row = relation.count
    let col = relation.first?.count ?? 0
    var candidates: [Int] = []
    var seen: Set<String>
    
    guard row > 0, col > 0 else { return 0 }
    
    for i in 1..<(1 << col) {
        var forContinue = false
        for candidate in candidates {
            if (candidate & i) == candidate { forContinue = true; break }
        }
        
        if forContinue { continue }
        
        seen = Set<String>()
        
        for j in 0..<row {
            var temp: [String] = []
            
            for k in 0..<col where (i & (1 << k) != 0) {
                temp.append(relation[j][k])
            }
            
            let tempString = temp.joined(separator: "\u{1F}")
            seen.insert(tempString)
        }
        
        if seen.count == row { candidates.append(i) }
    }
    
    return candidates.count
}


let result_8 = candidateKeySolution([["100","ryan","music","2"],["200","apeach","math","2"],["300","tube","computer","3"],["400","con","computer","4"],["500","muzi","music","3"],["600","apeach","music","2"]])

//MARK: 문자열 압축

func stringCompressionSolution(_ s: String) -> Int {
    let stringCount = s.count
    var result = stringCount
    
    if stringCount <= 1 { return result }
    
    for i in 1...(stringCount / 2) {
        var index = 0
        var totalCount = 0
        let startIndex = s.index(s.startIndex, offsetBy: 0)
        let endIndex = s.index(startIndex, offsetBy: i)
        index += i
        
        var compareString = s[startIndex..<endIndex]
        var duplicationCount = 1
        for j in 0..<((stringCount / i)-1) {
            let startIndex = s.index(s.startIndex, offsetBy: index, limitedBy: s.endIndex) ?? s.endIndex
            let endIndex = s.index(startIndex, offsetBy: i, limitedBy: s.endIndex) ?? s.endIndex
            index += i
            
            let nextString = s[startIndex..<endIndex]
            
            if nextString == compareString { duplicationCount += 1 }
            else {
                totalCount += compareString.count
                if duplicationCount > 1 { totalCount += String(duplicationCount).count }
                compareString = nextString
                duplicationCount = 1
            }
        }
        
        totalCount += compareString.count
        if duplicationCount > 1 { totalCount += String(duplicationCount).count }
        totalCount += (stringCount % i)
        result = min(totalCount, result)
    }
    
    return result
}

let result_9 = stringCompressionSolution("abcabcabcabcdededededede")

//MARK: 괄호 변환

func transParenthesesSolution(_ p: String) -> String {
    if p.isEmpty { return "" }
    var result = ""
    var pString = p
    var buffers: [String] = []
    var remain: String = ""
    
    while p.count > result.count {
        let (u,v) = transParenthesesSolution_sub_transToUnV(pString)
        if u == "" {
            if remain != "" { result += remain; remain = "" }
            if let suffix = buffers.popLast() {
                result += suffix
                continue
            }
            else {
                break
            }
        }
        
        var isRightU: Bool = true
        var balanceCount: Int = 0
        for str in u.description {
            balanceCount += (str == "(") ? 1 : -1
            if balanceCount < 0 { isRightU = false; break }
        }
        
        if isRightU {
            if buffers.isEmpty {
                result += u
            }
            else {
                remain += u
            }
            pString = v
        }
        else {
            result += remain + "("
            let transedU = u.dropFirst().dropLast().map { $0 == "(" ? ")" : "(" }.joined()
            buffers.append(")" + transedU)
            pString = v
            remain = ""
        }
    }
    
    return result
}

func transParenthesesSolution_sub_transToUnV(_ p: String) -> (u: String, v: String) {
    if p == "" { return ("", "") }
    var balanceCount: Int = 0
    var uIndex: String.Index = p.startIndex
    
    for i in p.indices {
        balanceCount += (p[i] == "(") ? 1 : -1
        if balanceCount == 0 { uIndex = i; break }
    }
    let vIndex = p.index(after: uIndex)
    let u: String = String(p[...uIndex])
    let v: String = String(p[vIndex...])
    return (u,v)
}

let result_10 = transParenthesesSolution("()))((()")

//MARK: 튜플

func tupleSolution_1(_ s: String) -> [Int] {
   var transedSToList: [[Int]] = []
    var result: [Int] = []
    
    for match in s.matches(of: /\{([0-9,]+)\}/) {
        let result = match.1.split(separator: ",").compactMap { Int($0) }
        transedSToList.append(result)
    }
    transedSToList = transedSToList.sorted { $0.count < $1.count }
    
    for i in transedSToList {
        if i.count == 1 { result.append(i[0]) }
        else { result.append(i.filter { result.contains($0) == false }[0])}
    }
    
    return result
}

func tupleSolution_2(_ s: String) -> [Int] {
    var result: [Int] = []
    
    let toJson = s.replacingOccurrences(of: "{", with: "[").replacingOccurrences(of: "}", with: "]")
    guard let data = toJson.data(using: .utf8), var transedSToList = try? JSONDecoder().decode([[Int]].self, from: data) else { return []}
    
    transedSToList = transedSToList.sorted { $0.count < $1.count }
    
    for i in transedSToList {
        if i.count == 1 { result.append(i[0]) }
        else { result.append(i.filter { result.contains($0) == false }[0])}
    }
    
    return result
}

let result_11 = tupleSolution_1("{{2},{2,1,3},{2,1},{2,1,3,4}}")
let result_12 = tupleSolution_2("{{2},{2,1,3},{2,1},{2,1,3,4}}")

//MARK: 수식 최대화

func maxValueExpressionSolution(_ expression: String) -> Int64 {
    var resultList = [Int64]()
    var numList = [Int64]()
    var symbolList = [String]()
    
    var buffer = ""
    for i in expression {
        if i.isNumber { buffer += String(i) }
        else {
            symbolList.append(String(i))
            numList.append(Int64(buffer) ?? 0)
            buffer = ""
        }
    }
    numList.append(Int64(buffer) ?? Int64(0))
    
    let symbolKind = Array(Set(symbolList)).sorted()
    var calculationList = [[String]]()
    if symbolKind.isEmpty { calculationList = [[]]}
    else {
        var calculation = symbolKind
        calculationList.append(calculation)
        var isDone: Bool = true
        while isDone {
            if calculation.count < 2 { isDone = false;break }
            var i = calculation.count - 2
            while i >= 0 && calculation[i] >= calculation[i+1] { i -= 1 }
            if i < 0 { isDone = false;break }
            
            var j = calculation.count - 1
            while calculation[j] <= calculation[i] { j -= 1 }
            calculation.swapAt(i, j)
            
            var left = i+1, right = calculation.count - 1
            while left < right {
                calculation.swapAt(left, right)
                left += 1
                right -= 1
            }
            isDone = true
            calculationList.append(calculation)
        }
    }
    
    for cal in calculationList {
        var nums = numList
        var symbols = symbolList
        for calSymbol in cal {
            var i = 0
            while i < symbols.count {
                if symbols[i] == calSymbol {
                    let num1 = nums[i]
                    let num2 = nums[i+1]
                    switch calSymbol {
                    case "+": nums[i] = num1 + num2
                    case "-": nums[i] = num1 - num2
                    case "*": nums[i] = num1 * num2
                    default:
                        nums[i] = 0
                    }
                    nums.remove(at: i+1)
                    symbols.remove(at: i)
                    
                }
                else {
                    i += 1
                }
            }
        }
        resultList.append(abs(nums[0]))
    }
    
    return resultList.max() ?? 0
}

let result_13 = maxValueExpressionSolution("100-200*300-500+20")
