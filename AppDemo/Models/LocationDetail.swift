//
//  LocationDetail.swift
//  AppDemo
//
//  Created by Daniel Bonates on 06/12/21.
//

import Foundation

struct LocationDetail: Decodable {
    let id: Int
    let name: String
    let review: Float
    let type: String
    let about: String
    let phone: String
    let adress: String
    let schedule: Schedule?
    let imageURL: URL?
}

extension LocationDetail {
    init?(from locationDetailSource: LocationDetailSource) {
        self.id = locationDetailSource.id
        self.name = locationDetailSource.name
        self.review = locationDetailSource.review
        self.type = locationDetailSource.type
        self.about = locationDetailSource.about
        self.phone = locationDetailSource.phone
        self.adress = locationDetailSource.adress
        self.schedule = locationDetailSource.schedule
        self.imageURL = URL(string: "https://dboserver.herokuapp.com/images/\(locationDetailSource.id).jpg")!
        
    }
}

extension LocationDetail {
    static let empty: LocationDetail = {
        return LocationDetail(id: 0, name: "", review: 0, type: "", about: "", phone: "", adress: "", schedule: nil, imageURL: nil)
    }()
//    static let empty: LocationDetail = {
//        return LocationDetail(id: 0, name: "", review: 0, type: "", about: "", phone: "", adress: "", schedule: nil, imageURL: nil)
//    }()
}

struct Schedule: Decodable {
    var monday: Day?
    var tuesday: Day?
    var wednesday: Day?
    var thursday: Day?
    var friday: Day?
    var saturday: Day?
    var sunday: Day?
    var daysAvailable: [DayAvailable]

    enum CodingKeys: String, CodingKey {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        monday = try? container.decode(Day.self, forKey: .monday)
        tuesday = try? container.decode(Day.self, forKey: .tuesday)
        wednesday = try? container.decode(Day.self, forKey: .wednesday)
        thursday = try? container.decode(Day.self, forKey: .thursday)
        friday = try? container.decode(Day.self, forKey: .friday)
        saturday = try? container.decode(Day.self, forKey: .saturday)
        sunday = try? container.decode(Day.self, forKey: .sunday)

        daysAvailable = []
        if let sunday = sunday { daysAvailable.append(
            DayAvailable(with: sunday, name: NSLocalizedString("week_day_1", value: "Dom", comment: ""))) }
        if let monday = monday { daysAvailable.append(
            DayAvailable(with: monday, name: NSLocalizedString("week_day_2", value: "Seg", comment: ""))) }
        if let tuesday = tuesday { daysAvailable.append(
            DayAvailable(with: tuesday, name: NSLocalizedString("week_day_3", value: "Ter", comment: ""))) }
        if let wednesday = wednesday { daysAvailable.append(
            DayAvailable(with: wednesday, name: NSLocalizedString("week_day_4", value: "Qua", comment: ""))) }
        if let thursday = thursday { daysAvailable.append(
            DayAvailable(with: thursday, name: NSLocalizedString("week_day_5", value: "Qui", comment: ""))) }
        if let friday = friday { daysAvailable.append(
            DayAvailable(with: friday, name: NSLocalizedString("week_day_6", value: "Sex", comment: ""))) }
        if let saturday = saturday { daysAvailable.append(
            DayAvailable(with: saturday, name: NSLocalizedString("week_day_7", value: "Sab", comment: ""))) }
    }

    /// Agrupado por horario
    /// Essa versão condensa os dias agrupando os que possuem mesmo horario open/close
    func groupedList() -> String {
        let dict = Dictionary(grouping: daysAvailable) { day in
            day.open + " às " + day.close
        }

        return dict.map { key, value -> String in
            let days = value.map { $0.name.capitalized }
            let schedule = key
            return "• " + days.joined(separator: ", ") + ": " + schedule

        }.joined(separator: "\n")
    }

    /// Lista um dia por linha
    func daysList() -> String {
         return daysAvailable.map { $0.scheduleInfo }.joined(separator: "\n")
    }
}

struct DayAvailable {
    let name: String
    let open: String
    let close: String

    init(with day: Day, name: String) {
        self.name = name
        self.open = day.open
        self.close = day.close
    }

    var scheduleInfo: String {
        return name + ": " + open + NSLocalizedString("until_equivalent", value: " às ", comment: "") + close
    }
}

struct Day: Decodable {
    let open: String
    let close: String
}

struct LocationDetailSource: Decodable {
    let id: Int
    let name: String
    let review: Float
    let type: String
    let about: String
    let phone: String
    let adress: String // typo error on api
    let schedule: Schedule // nó com inconsistencia, será tratado com decodeIfPresent

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case review
        case type
        case about
        case schedule
        case phone
        case adress
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        review = try container.decode(Float.self, forKey: .review)
        type = try container.decode(String.self, forKey: .type)
        about = try container.decode(String.self, forKey: .about)

        phone = try container.decode(String.self, forKey: .phone)
        adress = try container.decode(String.self, forKey: .adress)

        // paying a beer for api folks! 😜
        if let result = try? container.decodeIfPresent(Schedule.self, forKey: .schedule) {
            schedule = result
        } else if let result = try? container.decodeIfPresent([Schedule].self, forKey: .schedule), let first = result.first {
            schedule = first
        } else {
            throw APIError.invalidResponseFormat
        }
    }
}
