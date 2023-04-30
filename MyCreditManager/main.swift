//
//  main.swift
//  MyCreditManager
//
//  Created by leejungchul on 2023/04/30.
//

import Foundation

var studentList: [Student] = []

while true {
    print("원하는 기능을 입력해 주세요")
    print("1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료")
    let function = readLine() ?? ""
    if function == "1" {
        print("추가할 학생의 이름을 입력해주세요")
        print(createStudent())
    } else if function == "2" {
        print("삭제할 학생의 이름을 입력해주세요")
        print(deleteStudent())
    } else if function == "3" {
        print("성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.")
        print("입력예) Mickey Swift A+")
        print("만약에 학생의 성적 중 해당 과목이 존재하면 기존점수가 갱신됩니다.")
        print(createAndUpdateScore())
    } else if function == "4" {
        print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.")
        print("입력예) Mickey Swift")
        print(deleteScore())
    } else if function == "5" {
        print("평점을 알고싶은 학생의 이름을 입력해주세요.")
        print(readScore())
    } else if function == "6" {
        print(studentList)
    } else if function == "X" {
        print("프로그램을 종료합니다...")
        break
    } else {
        print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
    }
}


func createStudent() -> String {
    let student = readLine() ?? ""
    
    if student.replacingOccurrences(of: " ", with: "") == "" {
        return "입력이 잘못되었습니다. 다시 확인해주세요."
    } else {
        // 학생추가 로직
        if studentList.contains(where: { $0.name == student }) {
            return "\(student)은 이미 존재하는 학생입니다. 추가하지 않습니다."
        } else {
            studentList.append(Student(name: student))
            return "\(student) 학생을 추가했습니다."
        }
    }
}

func deleteStudent() -> String {
    let student = readLine() ?? ""
    // 학생삭제 로직 (학생있으면 삭제, 없으면 찾지 못했습니다.)
    if studentList.contains(where: { $0.name == student }) {
        let studentIdx = studentList.firstIndex { $0.name == student } ?? 0
        studentList.remove(at: studentIdx)
        return "\(student) 학생을 삭제하였습니다."
    } else {
        return "\(student) 학생을 찾지 못했습니다."
    }
}

func createAndUpdateScore() -> String {
    let input = (readLine() ?? "").components(separatedBy: " ")
    if input.count != 3 {
        return "입력이 잘못되었습니다. 다시 확인해주세요."
    }
    let student = input[0]
    let className = input[1]
    let score = input[2]
    
    if student.isEmpty || className.isEmpty || score.isEmpty {
        return "입력이 잘못되었습니다. 다시 확인해주세요."
    }
    
    
    if let studentIdx = studentList.firstIndex(where: { $0.name == student }) {
        studentList[studentIdx].classAndScore[className] = score
        return "\(student) 학생의 \(className) 과목이 \(score)로 추가(변경) 되었습니다."
    } else {
        return "\(student) 학생을 찾지 못했습니다."
    }
}

func deleteScore() -> String {
    let input = (readLine() ?? "").components(separatedBy: " ")
    if input.count != 2 {
        return "입력이 잘못되었습니다. 다시 확인해주세요."
    }
    let student = input[0]
    let className = input[1]
    
    if let studentIdx = studentList.firstIndex(where: { $0.name == student }) {
        studentList[studentIdx].classAndScore[className] = nil
        return "\(student) 학생의 \(className) 과목의 성적이 삭제되었습니다."
    } else {
        return "\(student) 학생을 찾지 못했습니다."
    }
}

func readScore() -> String{
    let student = readLine() ?? ""
    if student == "" {
        return "입력이 잘못되었습니다. 다시 확인해주세요."
    }
    
    if let studentIdx = studentList.firstIndex(where: { $0.name == student }) {
        var result = ""
        var score = 0.0
        let sortedClass = studentList[studentIdx].classAndScore.sorted { $0.key > $1.key }
        for (k, v) in sortedClass {
            score += gradeToScore(grade: v)
            result += "\(k): \(v)\n"
        }
        result += "평점 : \(round(score / Double(sortedClass.count) * 100) / 100)"
        return result
    } else {
        return "\(student) 학생을 찾지 못했습니다."
    }
}

func gradeToScore(grade: String) -> Double {
//    - A+ (4.5점) / A (4점)
//    - B+ (3.5점) / B (3점)
//    - C+ (2.5점) / C (2점)
//    - D+ (1.5점) / D (1점)
//    - F (0점)
    switch grade {
    case "A+":
        return 4.5
    case "A":
        return 4.0
    case "B+":
        return 3.5
    case "B":
        return 3.0
    case "C+":
        return 2.5
    case "C":
        return 2.0
    case "D+":
        return 1.5
    case "D":
        return 1.0
    default:
        return 0
    }
}







struct Student {
    let name: String
    var classAndScore: ClassAndScore
    
    init(name: String) {
        self.name = name
        self.classAndScore = [:]
    }
    
    init(name: String, classAndScore: ClassAndScore) {
        self.name = name
        self.classAndScore = classAndScore
    }
    
}
typealias ClassAndScore = [String: String]

