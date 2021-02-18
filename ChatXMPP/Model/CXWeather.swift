//
//  CXWeather.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 18/02/21.
//

import Foundation

// MARK: - CXWeather
class CXWeather: Codable {
    var coord: CXCoord?
    var weather: [CXWeatherElement]?
    var base: String?
    var main: CXMain?
    var visibility: Int?
    var wind: CXWind?
    var clouds: CXClouds?
    var dt: Int?
    var sys: CXSys?
    var timezone: Int?
    var id: Int?
    var name: String?
    var cod: Int?
    var isSelected:Bool? = false
    

    enum CodingKeys: String, CodingKey {
        case coord = "coord"
        case weather = "weather"
        case base = "base"
        case main = "main"
        case visibility = "visibility"
        case wind = "wind"
        case clouds = "clouds"
        case dt = "dt"
        case sys = "sys"
        case timezone = "timezone"
        case id = "id"
        case name = "name"
        case cod = "cod"
    }

    init(coord: CXCoord?, weather: [CXWeatherElement]?, base: String?, main: CXMain?, visibility: Int?, wind: CXWind?, clouds: CXClouds?, dt: Int?, sys: CXSys?, timezone: Int?, id: Int?, name: String?, cod: Int?) {
        self.coord = coord
        self.weather = weather
        self.base = base
        self.main = main
        self.visibility = visibility
        self.wind = wind
        self.clouds = clouds
        self.dt = dt
        self.sys = sys
        self.timezone = timezone
        self.id = id
        self.name = name
        self.cod = cod
    }
}

// MARK: - CXClouds
class CXClouds: Codable {
    var all: Int?

    enum CodingKeys: String, CodingKey {
        case all = "all"
    }

    init(all: Int?) {
        self.all = all
    }
}

// MARK: - CXCoord
class CXCoord: Codable {
    var lon: Double?
    var lat: Double?

    enum CodingKeys: String, CodingKey {
        case lon = "lon"
        case lat = "lat"
    }

    init(lon: Double?, lat: Double?) {
        self.lon = lon
        self.lat = lat
    }
}

// MARK: - CXMain
class CXMain: Codable {
    var temp: Double?
    var feelsLike: Double?
    var tempMin: Double?
    var tempMax: Double?
    var pressure: Int?
    var humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
    }

    init(temp: Double?, feelsLike: Double?, tempMin: Double?, tempMax: Double?, pressure: Int?, humidity: Int?) {
        self.temp = temp
        self.feelsLike = feelsLike
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.pressure = pressure
        self.humidity = humidity
    }
}

// MARK: - CXSys
class CXSys: Codable {
    var type: Int?
    var id: Int?
    var country: String?
    var sunrise: Int?
    var sunset: Int?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case id = "id"
        case country = "country"
        case sunrise = "sunrise"
        case sunset = "sunset"
    }

    init(type: Int?, id: Int?, country: String?, sunrise: Int?, sunset: Int?) {
        self.type = type
        self.id = id
        self.country = country
        self.sunrise = sunrise
        self.sunset = sunset
    }
}

// MARK: - CXWeatherElement
class CXWeatherElement: Codable {
    var id: Int?
    var main: String?
    var weatherDescription: String?
    var icon: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case weatherDescription = "description"
        case icon = "icon"
    }

    init(id: Int?, main: String?, weatherDescription: String?, icon: String?) {
        self.id = id
        self.main = main
        self.weatherDescription = weatherDescription
        self.icon = icon
    }
}

// MARK: - CXWind
class CXWind: Codable {
    var speed: Double?
    var deg: Int?

    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case deg = "deg"
    }

    init(speed: Double?, deg: Int?) {
        self.speed = speed
        self.deg = deg
    }
}
