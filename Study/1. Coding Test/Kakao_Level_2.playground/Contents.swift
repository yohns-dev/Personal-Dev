import Foundation

//MARK: 핵심 함수

func nCk(_ n: Int, _ k: Int) -> [[Int]] {
    guard k > 0, k <= n else { return [] }
    var result = [[Int]]()
    var index = Array(0..<k)
    
    while true {
        result.append(index)
        
        var i = k - 1
        while i >= 0 && index[i] == i + n - k { i -= 1 }
        if i < 0 { break }
        
        index[i] += 1
        if i < k - 1 {
            for j in (i+1)..<k {
                index[j] = index[j - 1] + 1
            }
        }
    }
    
    return result
}

//let nCkResult = nCk(6, 3)

func nCk(_ s: String, _ k: Int) -> [String] {
    let chars = Array(s)
    let n = chars.count
    guard k > 0, k <= n else { return [] }
    var result = [String]()
    var index = Array(0..<k)
    
    while true {
        result.append(String(index.map { chars[$0] }))
        var i = k - 1
        while i >= 0 && index[i] == i + n - k { i -= 1 }
        if i < 0 { break }
        index[i] += 1
        if i < k - 1 {
            for j in (i+1)..<k {
                index[j] = index[j - 1] + 1
            }
        }
    }
    
    return result
}

//let nCk_StringResult = nCk("abcdef", 3)

func nPk(_ n: Int, _ k: Int) -> [[Int]] {
    guard k > 0, k <= n else { return [] }
    var result = [[Int]]()
    var index = Array(0..<n)
    let nCk = nCk(n, k)
    
    for nCkValue in nCk {
        var numList = nCkValue
        result.append(numList)
        
        while true {
            if numList.count < 2 { break }
            var i = numList.count - 2
            while i >= 0 && numList[i] >= numList[i + 1] { i -= 1 }
            if i < 0 { break }
            
            var j = numList.count - 1
            while numList[j] < numList[i] { j -= 1 }
            numList.swapAt(i, j)
            numList[(i+1)...].reverse()
            result.append(numList)
        }
    }
    
    return result
}

//let nPkResult = nPk(5, 3)

func nPk(_ s: String, _ k: Int) -> [String] {
    let chars = Array(s)
    let n = chars.count
    guard k > 0, k <= n else { return [] }
    var result = [String]()
    
    var index = Array(0..<k)
    while true {
        var p = index.map { chars[$0] }
        result.append(String(p))
        if k > 1 {
            while true {
                var i = k - 2
                while i >= 0 && p[i] >= p[i + 1] { i -= 1 }
                if i < 0 { break }
                var j = k - 1
                while p[j] <= p[i] { j -= 1 }
                p.swapAt(i, j)
                p[(i + 1)...].reverse()
                result.append(String(p))
            }
        }
        
        var i = k - 1
        while i >= 0 && index[i] == i + n - k { i -= 1 }
        if i < 0 { break }
        index[i] += 1
        if i < k - 1 {
            for j in (i + 1)..<k { index[j] = index[j - 1] + 1 }
        }
    }
    return result
}

//let nPk_StringResult = nPk("abcdef", 3)

func nPk_gosper(_ n: Int, _ k: Int) -> [[Int]] {
    guard k > 0, k <= n, n <= 62 else { return [] }
    var result: [[Int]] = []
    
    var x: UInt64 = (k == 64) ? ~UInt64(0) : (UInt64(1) << UInt64(k)) - 1
    let limit: UInt64 = UInt64(1) << UInt64(n)
    
    while x < limit {
        var value: [Int] = []
        var tmp = x
        var pos = 0
        while tmp != 0 {
            if (tmp & 1) == 1 { value.append(pos) }
            pos += 1
            tmp >>= 1
        }
        var p = value
        result.append(p)
        if k > 1 {
            while true {
                var i = k - 2
                while i >= 0 && p[i] >= p[i + 1] { i -= 1 }
                if i < 0 { break }
                
                var j = k - 1
                while p[j] <= p[i] { j -= 1 }
                p.swapAt(i, j)
                
                var l = i + 1
                var r = k - 1
                while l < r {
                    p.swapAt(l, r)
                    l += 1
                    r -= 1
                }
                result.append(p)
            }
        }
        
        let c: UInt64 = x & (~x &+ 1)
        let r: UInt64 = x &+ c
        if (r & limit) != 0 { break }
        x = ((((r ^ x) >> 2) / c) | r)
    }
    
    return result
}

//let nPkGosperResult = nPk_gosper(5, 3)

func nPk_gosper(_ s: String, _ k: Int) -> [String] {
    let chars = Array(s)
    let n = chars.count
    guard k > 0, k <= n, n <= 62 else { return [] }
    var result = [String]()
    
    var x: UInt64 = (UInt64(1) << UInt64(k)) - 1
    let limit: UInt64 = UInt64(1) << UInt64(n)

    while x < limit {
        var value = [Character]()
        var tmp = x
        var pos = 0
        while tmp != 0 {
            let tz = tmp.trailingZeroBitCount
            pos += tz
            value.append(chars[pos])
            tmp >>= (tz + 1)
            pos += 1
        }

        var p = value
        result.append(String(p))
        if k > 1 {
            while true {
                var i = k - 2
                while i >= 0 && p[i] >= p[i + 1] { i -= 1 }
                if i < 0 { break }
                var j = k - 1
                while p[j] <= p[i] { j -= 1 }
                p.swapAt(i, j)
                p[(i + 1)...].reverse()
                result.append(String(p))
            }
        }
        
        let c = x & (~x &+ 1)
        let r = x &+ c
        if (r & limit) != 0 { break }
        x = ((((r ^ x) >> 2) / c) | r)
    }
    return result
}

//let npkGosperStringResult = nPk_gosper("abcde", 3)

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

//let result_1 = newsClustingSolution("handshake", "shake hands")


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

//let result_2 = friends4BlockSolution(4,5, ["CCBDE", "AAADE", "AAABF", "CCBBF"])

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

//let result_3 = findMusicSolution("ABC", ["12:00,12:14,HELLO,C#DEFGAB", "13:00,13:05,WORLD,ABCDEF"])

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

//let result_4 = compressionSolution("TOBEORNOTTOBEORTOBEORNOT")

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

//let result_5 = fileNameSortingSolution(["F-5 Freedom Fighter", "B-50 Superfortress", "A-10 Thunderbolt II", "F-14 Tomcat2311dsaad"])

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

//let result_6 = nNumberGameSolution(16, 16, 2, 1)

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

//let result_7 = openChatSolution(["Enter uid1234 Muzi", "Enter uid4567 Prodo","Leave uid1234","Enter uid1234 Prodo","Change uid4567 Ryan"])

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


//let result_8 = candidateKeySolution([["100","ryan","music","2"],["200","apeach","math","2"],["300","tube","computer","3"],["400","con","computer","4"],["500","muzi","music","3"],["600","apeach","music","2"]])

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

//let result_9 = stringCompressionSolution("abcabcabcabcdededededede")

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

//let result_10 = transParenthesesSolution("()))((()")

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

//let result_11 = tupleSolution_1("{{2},{2,1,3},{2,1},{2,1,3,4}}")
//let result_12 = tupleSolution_2("{{2},{2,1,3},{2,1},{2,1,3,4}}")

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

//let result_13 = maxValueExpressionSolution("100-200*300-500+20")

//MARK: 메뉴 리뉴얼

func renuwalMenuSolution(_ orders: [String], _ course: [Int]) -> [String] {
    var result = [String]()
    for i in course {
        var valueDict = [String : Int]()
        for j in orders.map({ String($0.sorted()) }) {
            let nCkList = nCk(j, i)
            for k in nCkList {
                valueDict[k, default: 0] += 1
            }
        }
        guard let valueMax = valueDict.values.max() else { continue }
        let maxDict = valueDict.filter { $0.value == valueMax && $0.value >= 2 }
        result.append(contentsOf: maxDict.keys)
    }
    
    
    return result.sorted()
}

//let result_14 = renuwalMenuSolution(["XYZ", "XWY", "WXA"], [2, 3, 4])

//MARK: 순위 검색

enum Language: Int, CaseIterable {
    case cpp = 0; case java = 1; case python = 2
    init?(value: Substring) {
        switch value {
        case "cpp": self = .cpp; case "java": self = .java; case "python": self = .python; default: return nil
        }
    }
}
enum JobGroup: Int, CaseIterable {
    case backend = 0; case frontend = 1
    init?(value: Substring) {
        switch value {
            case "backend": self = .backend; case "frontend": self = .frontend; default: return nil
        }
    }
}
enum Career: Int, CaseIterable {
    case junior = 0; case senior = 1
    init?(value: Substring) {
        switch value {
            case "junior": self = .junior; case "senior": self = .senior; default: return nil
        }
    }
}
enum Food: Int, CaseIterable {
    case chicken = 0; case pizza = 1
    init?(value: Substring) {
        switch value {
            case "chicken": self = .chicken; case "pizza": self = .pizza; default: return nil
        }
    }
}

func searchRankSolution(_ info: [String], _ query: [String]) -> [Int] {
    var result = [Int]()
    let allCaseCount = Language.self.allCases.count * JobGroup.self.allCases.count * Career.self.allCases.count * Food.self.allCases.count
    var searchList = Array(repeating: [Int](), count: allCaseCount)
    
    for i in info {
        let splitedInfo = i.split(separator: " ")
        guard let A = Language(value: splitedInfo[0])?.rawValue,
              let B = JobGroup(value: splitedInfo[1])?.rawValue,
              let C = Career(value: splitedInfo[2])?.rawValue,
              let D = Food(value: splitedInfo[3])?.rawValue,
              let score = Int(splitedInfo[4])
        else {return []}
        searchList[searchRankSolution_sub_mixedRadix(A,B,C,D)].append(score)
    }
    
    searchList = searchList.map { $0.sorted() }
    
    for j in query {
        let splitedQuery = j.split(separator: " ")
        let A = (splitedQuery[0] == "-") ? Language.allCases.map { $0.rawValue } : Language(value: splitedQuery[0]).map { [$0.rawValue] } ?? []
        let B = (splitedQuery[2] == "-") ? JobGroup.allCases.map { $0.rawValue } : JobGroup(value: splitedQuery[2]).map { [$0.rawValue] } ?? []
        let C = (splitedQuery[4] == "-") ? Career.allCases.map { $0.rawValue } : Career(value: splitedQuery[4]).map { [$0.rawValue] } ?? []
        let D = (splitedQuery[6] == "-") ? Food.allCases.map { $0.rawValue } : Food(value: splitedQuery[6]).map { [$0.rawValue] } ?? []
        
        guard let score = Int(splitedQuery[7]) else { result.append(0); continue}
        
        var count: Int = 0
        for a in A {
            for b in B {
                for c in C {
                    for d in D {
                        let mixedRadixNum = searchRankSolution_sub_mixedRadix(a,b,c,d)
                        let valueList = searchList[mixedRadixNum]
                        if valueList.isEmpty { continue }
                        var valueCount = 0, maxCount = valueList.count
                        while valueCount < maxCount  {
                            let mask = (valueCount + maxCount) / 2
                            if valueList[mask] < score { valueCount = mask + 1 } else { maxCount = mask }
                        }
                        count += (valueList.count - valueCount)
                    }
                }
            }
        }
        result.append(count)
        
        
    }
    
    return result
}

func searchRankSolution_sub_mixedRadix(_ a: Int, _ b: Int, _ c: Int, _ d: Int) -> Int {
    return (((a * JobGroup.allCases.count) + b) * Career.allCases.count + c) * Food.allCases.count + d
}

//let result_15 = searchRankSolution(["java backend junior pizza 150","python frontend senior chicken 210","python frontend senior chicken 150","cpp backend senior pizza 260","java backend junior chicken 80","python backend senior chicken 50"], ["java and backend and junior and pizza 100","python and frontend and senior and chicken 200","cpp and - and senior and pizza 250","- and backend and senior and - 150","- and - and - and chicken 100","- and - and - and - 150"])

//MARK: 거리두기 확인하기

func distancingCheckSolution(_ places: [[String]]) -> [Int] {
    var result: [Int] = []
    
    for place in places {
        result.append(distancingCheckSolution_sub_isNearPerson(place: place, distance: 2))
    }
    
    return result
}

func distancingCheckSolution_sub_directions(_ maxDistance: Int) -> [(Int, Int)] {
    var result = [(Int, Int)]()
    for row in -maxDistance...maxDistance {
        for col in -maxDistance...maxDistance {
            let distance = abs(row) + abs(col)
            if distance > 0 && distance <= maxDistance {
                result.append((row,col))
            }
        }
    }
    
    return result
}

func distancingCheckSolution_sub_isNearPerson(place : [String], distance: Int) -> Int {
    let place: [[Character]] = place.map { Array($0) }
    let rowCount = place.count
    let colCount = place[0].count
    let directions = distancingCheckSolution_sub_directions(distance)
    
    for row in 0..<rowCount {
        for col in 0..<colCount {
            if place[row][col] == "P" {
                for direction in directions {
                    let nextRow = row + direction.0
                    let nextCol = col + direction.1
                    
                    if nextRow < 0 || nextCol < 0 || nextRow >= rowCount || nextCol >= colCount { continue }
                    
                    if place[nextRow][nextCol] == "P" {
                        let distance = abs(direction.0) + abs(direction.1)
                        
                        if distance == 1 { return 0 }
                        else if distance == 2 {
                            if direction.0 == 0 { if place[row][col + direction.1 / 2] != "X" { return 0 }}
                            else if direction.1 == 0 { if place[row + direction.0 / 2][col] != "X" { return 0 }}
                            else { if !(place[row][nextCol] == "X" && place[nextRow][col] == "X") { return 0 }}
                        }
                        
                    }
                    
                }
            }
        }
    }
    return 1
}

let result_16 = distancingCheckSolution([["POOOP", "OXXOX", "OPXPX", "OOXOX", "POXXP"], ["POOPX", "OXPXP", "PXXXO", "OXXXO", "OOOPP"], ["PXOPX", "OXOXP", "OXPOX", "OXXOP", "PXPOX"], ["OOOXX", "XOOOX", "OOOXX", "OXOOX", "OOOOO"], ["PXPXP", "XPXPX", "PXPXP", "XPXPX", "PXPXP"]])
