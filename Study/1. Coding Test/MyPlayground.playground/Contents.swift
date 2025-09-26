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

let result = giftSolution_1(["1", "2", "3"], ["1 2", "1 3", "1 3", "2 1", "3 3"])
print(result)

