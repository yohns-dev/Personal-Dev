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
print(result_3)
