import Foundation


//MARK: 가장 많이 받은 선물

func giftSolution_1(_ friends: [String], _ gifts: [String]) -> Int {
    var givenHistory = [String : Int]()
    var receivedHistory = [String : Int]()
    var totalHistory = [String : [String : Int]]()
    var giftIndices = [String : Int]()
    var giftNextNumber = [String : Int]()
    
    for friend in friends {
        givenHistory[friend] = 0
        receivedHistory[friend] = 0
        totalHistory[friend] = [:]
        giftIndices[friend] = 0
        giftNextNumber[friend] = 0
    }
    
    for gift in gifts {
        let giftInfo = gift.components(separatedBy: " ")
        givenHistory[giftInfo[0]]! += 1
        receivedHistory[giftInfo[1]]! += 1
        totalHistory[giftInfo[0]]![giftInfo[1], default: 0] += 1
    }
    
    for friend in friends {
        giftIndices[friend] = givenHistory[friend]! - receivedHistory[friend]!
    }
    
    for i in 0..<friends.count {
        for j in i+1..<friends.count {
            let friend1 = friends[i]
            let friend2 = friends[j]
            
            let friend12 = totalHistory[friend1]?[friend2] ?? 0
            let friend21 = totalHistory[friend2]?[friend1] ?? 0
            
            if friend12 > friend21 {
                giftNextNumber[friend1]! += 1
            }
            else if friend12 < friend21 {
                giftNextNumber[friend2]! += 1
            }
            else {
                if giftIndices[friend1]! > giftIndices[friend2]! {
                    giftNextNumber[friend1]! += 1
                }
                else if giftIndices[friend1]! < giftIndices[friend2]! {
                    giftNextNumber[friend2]! += 1
                }
            }
            
        }
    }
    
    return giftNextNumber.values.max() ?? 0
}

func giftSolution_2(_ friends: [String], _ gifts: [String]) -> Int {
    var duplicationCountList = [String : Int]()
    var reversalDuplicationList = [String : [Int]]()
    var giftIndices = [String: Int]()
    var giftNumberList = [String : Int]()
    
    //duplicationCountList
    duplicationCountList = gifts.reduce(into: [:]) { $0[$1, default: 0] += 1 }
    
    for (key , value) in duplicationCountList {
        let parts = key.split(separator: " ").map { String($0)}
        guard parts.count == 2 else { continue }
        
        // giftIndices
        giftIndices[parts[0], default: 0] += value
        giftIndices[parts[1], default: 0] -= value
        
        //reversal
        if reversalDuplicationList["\(parts[1]) \(parts[0])"] != nil { continue }
        let otherValue = duplicationCountList["\(parts[1]) \(parts[0])"] ?? 0
        reversalDuplicationList[key] = [value, otherValue]
    }
    
    for i in 0..<friends.count {
        for j in (i+1)..<friends.count {
            let friend1 = friends[i]
            let friend2 = friends[j]
            
            let friend12 = duplicationCountList["\(friend1) \(friend2)"] ?? 0
            let friend21 = duplicationCountList["\(friend2) \(friend1)"] ?? 0
            
            if friend12 > friend21 {
                giftNumberList[friend1, default: 0] += 1
            } else if friend12 < friend21 {
                giftNumberList[friend2, default: 0] += 1
            } else {
                let gift1 = giftIndices[friend1] ?? 0
                let gift2 = giftIndices[friend2] ?? 0
                if gift1 > gift2 {
                    giftNumberList[friend1, default: 0] += 1
                } else if gift1 < gift2 {
                    giftNumberList[friend2, default: 0] += 1
                }
            }
        }
    }
    
    return giftNumberList.values.max() ?? 0
}

let result_1 = giftSolution_1(["muzi", "ryan", "frodo", "neo"], ["muzi frodo", "muzi frodo", "ryan muzi", "ryan muzi", "ryan muzi", "frodo muzi", "frodo ryan", "neo muzi"])
let result_2 = giftSolution_2(["muzi", "ryan", "frodo", "neo"], ["muzi frodo", "muzi frodo", "ryan muzi", "ryan muzi", "ryan muzi", "frodo muzi", "frodo ryan", "neo muzi"])

//MARK: 개인정보 수집 유효기간
/// today: 오늘 날짜 ex) "2025.09.29"
/// terms: ["약관 종류 약관 유효기간"] ex) ["A 6", "B 12", "C 3"]
/// privacies: ["약관 동의 날짜 약관 종류"] ex) ["2025.09.29 A", "2025.09.28 B"]
func privacySolution(_ today: String, _ terms: [String], _ privacies: [String]) -> [Int] {
    var result: [Int] = []
    let term: [String : Int] = termsFormatter(terms)
    
    for index in privacies.indices {
        let separtedPrivacy = privacies[index].split(separator: " ")
        let agreeDate = String(separtedPrivacy[0])
        let agreeType = String(separtedPrivacy[1])
        
        guard let addDate = dateAddFormatter(agreeDate, term[agreeType] ?? 0, .month) else { continue }
        
        if addDate <= today {
            result.append(index + 1)
        }
    }
    
    
    return result
}

func termsFormatter(_ terms: [String]) -> [String : Int] {
    let termsDict: [String : Int] = terms.reduce(into: [:]) { result, term in
        let parts = term.split(separator: " ")
        result[String(parts[0])] = Int(parts[1])
    }
    
    return termsDict
}

func dateAddFormatter(_ date: String, _ addDay: Int, _ addType: Calendar.Component) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd"
    guard let date = dateFormatter.date(from: date) else { return nil }
    guard let addedDate = Calendar.current.date(byAdding: addType, value: addDay, to: date) else { return nil }
    
    let result = dateFormatter.string(from: addedDate)
    
    return result
}

let result_3 = privacySolution("2022.05.19", ["A 6", "B 12", "C 3"], ["2021.05.02 A", "2021.07.01 B", "2022.02.19 C", "2022.02.20 C"])

//MARK: 성격 유형 검사하기
/// survey: RT, TR, FC, CF, MJ, JM, AN, NA의 값을 가진 리스트
/// choices: 선택한 번호로 4번을 기준으로 survey에 앞뒤 문자에 점수를 부여함.
/// 1: 매우 비동의 3점
/// 2: 비동의 2점
/// 3: 약간 비동의 1점
/// 4: 모르겠음 0점
/// 5: 약간 동의 1점
/// 6: 동의 2점
/// 7: 매우 동의 3점
func personalitySolution(_ survey: [String], _ choices: [Int]) -> String {
    var surveyDict: [String: Int] = ["R" : 0, "T" : 0, "F" : 0, "C" : 0, "M" : 0, "J" : 0, "A" : 0, "N" : 0]
    var surveyPair: [(String, String)] = [("R", "T"), ("C", "F"), ("J", "M"), ("A", "N")]
    var result: String = ""
    
    for (survey, choice) in zip(survey, choices) {
        let partList = Array(survey)
        if choice < 4 { surveyDict[String(partList[0]), default: 0] += (4 - choice) }
        else if choice > 4 { surveyDict[String(partList[1]), default: 0] += ( choice - 4 ) }
    }
    
    for (left, right) in surveyPair {
        if surveyDict[left]! > surveyDict[right]! { result += left }
        else if surveyDict[left]! < surveyDict[right]! { result += right }
        else { result += left }
    }
    
    
    return result
}

let reuslt_4 = personalitySolution(["TR", "RT", "TR"], [7, 1, 3])


//MARK: 신고 결과 받기

func reportSolution(_ id_list: [String], _ report: [String], _ k: Int) -> [Int] {
    var result: [Int] = []
    var duplicatedReport: [String] = []
    var reformReport = [String : [String]]()
    var reportNumber = [String : Int]()
    var sendResultId = [String : Int]()
    
    duplicatedReport = Array(Set(report))
    
    for value in duplicatedReport {
        let reportPart = value.split(separator: " ")
        reformReport[String(reportPart[0]), default: []].append( String(reportPart[1]))
        reportNumber[String(reportPart[1]), default: 0] += 1
    }
    
    let deactivatedId: Set<String> = Set(reportNumber.filter { $0.value >= k }.map { $0.key })
    
    for value in reformReport {
        let sendNumber = value.value.filter { deactivatedId.contains($0) }.count
        sendResultId[value.key, default: 0] = sendNumber
    }
    
    result = id_list.map { sendResultId[$0] ?? 0 }
    
    return result
}

let result_5 = reportSolution(["con", "ryan"], ["ryan con", "ryan con", "ryan con", "ryan con"], 3)

//MARK: 숫자 문자열과 영단어
/// 단순 for문 이용한 재배치
func wordToNumberSolution_1(_ s: String) -> Int {
    var text = s
    let numberStringDict: [String : String] = ["zero": "0", "one" : "1", "two": "2", "three": "3", "four": "4",  "five": "5", "six": "6", "seven": "7", "eight": "8", "nine": "9"]
    
    for (key, value) in numberStringDict {
        text = text.replacingOccurrences(of: key, with: value)
    }
    
    return Int(text) ?? 0
}

/// buffer를 이용하여 s의 n번만에 끝내는 방식 효율적인 방법
func wordToNumberSolution_2(_ s: String) -> Int {
    let numberStringDict: [String : String] = ["zero": "0", "one" : "1", "two": "2", "three": "3", "four": "4",  "five": "5", "six": "6", "seven": "7", "eight": "8", "nine": "9"]
    
    var buffer: String = ""
    var output: String = ""
    
    for value in s {
        if value.isNumber {
            output.append(value)
            buffer.removeAll(keepingCapacity: true)
        }
        else {
            buffer.append(value)
            if let transformedNumber = numberStringDict[buffer] {
                output.append(transformedNumber)
                buffer.removeAll(keepingCapacity: true)
            }
        }
    }
    
    return Int(output) ?? 0
}

let result_6 = wordToNumberSolution_1("one4seveneight")
let result_7 = wordToNumberSolution_2("one4seveneight")

func userIDRecommendSolution_1(_ new_id: String) -> String {
    // stage 1
    var result: String = new_id.lowercased()
    
    // stage 2
    result = result.replacingOccurrences(of: #"[^a-z0-9._-]"#, with: "", options: .regularExpression)
    
    // stage 3
    var buffer: String = ""
    var isDotStraight: Bool = false
    for value in result {
        if value == "." && isDotStraight == false {
            isDotStraight = true
            buffer += String(value)
        }
        else if value == "." && isDotStraight {
            continue
        }
        else {
            buffer += String(value)
            isDotStraight = false
        }
    }
    result = buffer
    
    // stage 4
    if result.first == "." {
        result.removeFirst(1)
    }
    if result.last == "." {
        result.removeLast(1)
    }
    
    // stage 5
    if result == "" {
        result += "a"
    }
    
    // stage 6
    if result.count >= 16 {
        result = String(result.prefix(15))
        if result.last == "." {
            result.removeLast(1)
        }
    }
    
    // stage 7
    while result.count <= 2 {
        result += result.suffix(1)
    }
    
    
    
    return result
}

func userIDRecommendSolution_2(_ new_id: String) -> String {
    // stage 1
    var result = new_id.lowercased()
    
    // stage 2
    result = result.replacingOccurrences(of: #"[^a-z0-9._-]"#, with: "", options: .regularExpression)
    
    // stage 3
    result = result.replacingOccurrences(of: #"\.{2,}"#, with: ".", options: .regularExpression)
    
    // stage 4
    result = result.trimmingCharacters(in: CharacterSet(charactersIn: (".")))
    
    // stage 5
    if result.isEmpty { result = "a" }
    
    // stage 6
    if result.count >= 16 {
        result = String(result.prefix(15))
        result = result.trimmingCharacters(in: CharacterSet(charactersIn: (".")))
    }
    
    // stage 7
    if result.count < 3 {
        while result.count < 3 {
            result.append(String(result.suffix(1)))
        }
    }
    
    return result
}

let result_8 = userIDRecommendSolution_1("...!@BaT#*..y.abcdefghijklm...")
let result_9 = userIDRecommendSolution_2("...!@BaT#*..y.abcdefghijklm...")

func keyPadSolution_1(_ numbers: [Int], _ hand: String) -> String {
    var result: String = ""
    let hand: String = hand.prefix(1).uppercased()
    var leftFingerNumber: Int = 10
    var rightFingerNumber: Int = 12
    
    for number in numbers {
        if number % 3 == 1 {
            leftFingerNumber = number
            result.append("L")
        }
        else if number % 3 == 0 && number != 0 {
            rightFingerNumber = number
            result.append("R")
        }
        else {
            var number = number
            if number == 0 { number = 11 }
            let rightNumberDistance = abs(number - rightFingerNumber)
            let leftNumberDistance = abs(number - leftFingerNumber)
            
            let dividingRight = (rightNumberDistance / 3, rightNumberDistance % 3)
            let dividingLeft = (leftNumberDistance / 3, leftNumberDistance % 3)
            
            var leftDistance: Int = dividingLeft.0 + dividingLeft.1
            var rightDistance: Int = dividingRight.0 + dividingRight.1
            
            if leftDistance == rightDistance {
                result.append(hand)
                if hand == "R" {
                    rightFingerNumber = number
                }
                else {
                    leftFingerNumber = number
                }
            }
            else {
                if leftDistance > rightDistance {
                    result.append("R")
                    rightFingerNumber = number
                }
                else {
                    result.append("L")
                    leftFingerNumber = number
                }
            }
        }
    }
    return result
}

/// 이건 시간이 없음으로 생략
/// 숫자를 받아요면 좌표로 변환하고 기준이 되는 좌표에 행렬 빼기를 시행하고 그 두 좌표의 더한 값이 결국 거리가 되기 때문 이것으로 분별이 가능
func keyPadSolution_2(_ numbers: [Int], _ hand: String) -> String {
    var result: String = ""
    //    var leftFingerLocation: [Int] = [1,4]
    //    var rightFingerLocation: [Int] = [3,4]
    
    for number in numbers {
        
    }
    
    
    return result
}

let result_10 = keyPadSolution_1([7, 0, 8, 2, 8, 3, 1, 5, 7, 6, 2], "left")
let result_11 = keyPadSolution_2([1, 3, 4, 5, 8, 2, 1, 4, 5, 9, 5], "right")

//MARK: 크레인 인형뽑기 게임
/// board[row][col]
func clawMachineGameSolution(_ board: [[Int]], _ moves: [Int]) -> Int {
    var result: Int = 0
    var board = board
    var bucket: [Int] = []
    
    for col in moves {
        for row in board.indices {
            if board[row][col-1] != 0 {
                bucket.append(board[row][col-1])
                board[row][col-1] = 0
                if bucket.count >= 2 && bucket[bucket.count-1] == bucket[bucket.count-2] {
                    result += 2
                    bucket.removeLast(2)
                    
                }
                break
            }
        }
    }
    
    return result
}

let result_12 = clawMachineGameSolution([[0,0,0,0,0],[0,0,1,0,3],[0,2,5,0,1],[4,2,4,4,2],[3,5,1,3,1]], [1,5,3,5,1,2,1,4])

//MARK: 실패율
/// 실패율 : 도달하였으나 깨지 못한 플레이어의 수 / 도달한 플레이어의 수
func failureRateSolution(_ N: Int, _ stages: [Int]) -> [Int] {
    var result = [Int]()
    var stageStayNumber = Array(repeating: 0, count: N+2)
    var failureDict = [Int: Double]()
    var clearNumber: Int = stages.count
    
    for stage in stages {
        if stage <= N { stageStayNumber[stage] += 1 }
        else { stageStayNumber[N+1] += 1 }
    }
    
    for stage in 1...N {
        let failureRate = (clearNumber == 0) ? 0.0 : Double(stageStayNumber[stage]) / Double(clearNumber)
        clearNumber -= stageStayNumber[stage]
        failureDict[stage] = failureRate
    }
    
    result = failureDict.sorted { leftValue, rightValue in
        if leftValue.value == rightValue.value {
            return leftValue.key < rightValue.key
        }
        
        return leftValue.value > rightValue.value
    }.map { $0.key }
    
    return result
}

let result_13 = failureRateSolution(5, [2, 1, 2, 6, 2, 4, 3, 3])

//MARK: 다트 게임

func dartGameSolution(_ dartResult: String) -> Int {
    var numberBuffer: String = ""
    var dartScore = [Int]()
    
    for i in dartResult {
        if i.isNumber { numberBuffer.append(i); continue }
        if i == "S" || i == "D" || i == "T" {
            let score: Int
            guard let point = Int(numberBuffer) else { continue }
            numberBuffer = ""
            
            switch i {
            case "S": score = Int(pow(Double(point), 1))
            case "D": score = Int(pow(Double(point), 2))
            case "T": score = Int(pow(Double(point), 3))
            default: score = point
            }
            dartScore.append(score)
        }
        else if i == "*" || i == "#" {
            
            switch i {
            case "*":
                dartScore[dartScore.count - 1] *= 2
                if dartScore.count >= 2 {
                    dartScore[dartScore.count - 2] *= 2
                }
            case "#": dartScore[dartScore.count - 1] *= -1
            default : break
            }
        }
    }
    
    
    return dartScore.reduce(0, +)
}

let result_14 = dartGameSolution("1S2D*3T")

//MARK: 비밀지도

func marauderMapSolution(_ n: Int, _ arr1: [Int], _ arr2: [Int]) -> [String] {
    var result = [String]()
    
    for i in 0..<n {
        let orBitWise = arr1[i] | arr2[i]
        let binary = String(orBitWise, radix: 2)
        let transBinary = (n > binary.count) ? String(repeating: "0", count: n - binary.count) + binary : binary
        let trans1ToWall = transBinary.replacingOccurrences(of: "1", with: "#")
        let trans0ToSpace = trans1ToWall.replacingOccurrences(of: "0", with: " ")
        result.append(trans0ToSpace)
    }
    
    return result
}

let result_15 = marauderMapSolution(6, [46, 33, 33, 22, 31, 50], [27, 56, 19, 14, 14, 10])
