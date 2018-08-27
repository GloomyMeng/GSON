//
//  GSON.swift
//  GSON
//
//  Created by Gloomy Sunday on 2018/8/23.
//

import PerfectLib

public enum GSONError: Int, Error {
    case unsupportedType = 999
    case indexOutOfBounds = 900
    case elementTooDeep = 902
    case wrongType = 901
    case notExist = 500
    case invalidJSON = 490
}

public enum Type: Int {
    case int
    case uint
    case double
    case string
    case bool
    case array
    case dictionary
    case null
    case unknown
}

public struct GSON {
    
    /// PARSES THE JSON STRING INTO A JSON STRUCT
    ///
    /// - Parameter jsonString: JSON STRING
    public init?(parseJSON jsonString: String) {
        do {
            let jsons = try jsonString.jsonDecode()
            self.init(jsons)
        } catch {
            Log.error(message: "Can't convert json, string is:\n\(jsonString)")
            return nil
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter object: <#object description#>
    public init(_ object: Any) {
        switch object {
            //        case <#pattern#>:
        //            <#code#>
        default: self.init(jsonObject: object)
        }
    }
    
    // MARK: - PRIVATE METHODS
    
    /// CREATE A GSON USING THE OBJECT
    ///
    /// - Parameter jsonObject: <#jsonObject description#>
    private init(jsonObject: Any) { self.object = jsonObject }

    public var isNull: Bool { return type == .null }
    
    static var nullValue = "null"
    static var null: GSON { return GSON.init(nullValue) }
    fileprivate var rawArray: [Any] = []
    fileprivate var rawDictionary: [String: Any] = [:]
    fileprivate var rawString: String = ""
    fileprivate var rawInt: Int = 0
    fileprivate var rawUInt: UInt = 0
    fileprivate var rawDouble: Double = 0.0
    fileprivate var rawBool: Bool = false
    
    public fileprivate(set) var type: Type = .null
    public fileprivate(set) var error: GSONError?
    public var object: Any {
        get {
            switch type {
            case .array:        return rawArray
            case .dictionary:   return rawDictionary
            case .string:       return rawString
            case .int:          return rawInt
            case .uint:         return rawUInt
            case .double:       return rawDouble
            case .bool:         return rawBool
            case .null:         return GSON.null
            case .unknown:      return GSON.null
            }
        }
        set {
            error = nil
            switch unwrap(newValue) {
            case let array as [Any]:                type = .array; rawArray = array
            case let dictionary as [String: Any]:   type = .dictionary; rawDictionary = dictionary
            case let string as String:
                if string == GSON.nullValue { type = .null }
                else { type = .string; rawString = string }
            case let int as Int:                    type = .int; rawInt = int
            case let int8 as Int8:                  type = .int; rawInt = Int(int8)
            case let int16 as Int16:                type = .int; rawInt = Int(int16)
            case let int32 as Int32:                type = .int; rawInt = Int(int32)
            case let int64 as Int64:                type = .int; rawInt = Int(int64)
            case let uint as UInt:                  type = .uint; rawUInt = uint
            case let uint8 as UInt8:                type = .uint; rawUInt = UInt(uint8)
            case let uint16 as UInt16:              type = .uint; rawUInt = UInt(uint16)
            case let uint32 as UInt32:              type = .uint; rawUInt = UInt(uint32)
            case let uint64 as UInt64:              type = .uint; rawUInt = UInt(uint64)
            case let double as Double:              type = .double; rawDouble = double
            case let float as Float:                type = .double; rawDouble = Double(float)
            case let bool as Bool:                  type = .bool; rawBool = bool
            default:
                type = .unknown
                error = .unsupportedType
            }
        }
    }
}

private func unwrap(_ object: Any) -> Any {
    switch object {
    case let gson as GSON:                  if gson == GSON.null  { return GSON.nullValue } else { return unwrap(gson.object) }
    case let array as [Any]:                return array.map(unwrap)
    case let dictionary as [String: Any]:
        var r = dictionary
        for tuple in dictionary {
            r[tuple.key] = unwrap(tuple.value)
        }
        
        return r
    default:                                return object
    }
}


public enum Index<T: Any>: Comparable {
    
    case array(Int)
    case dictionary(DictionaryIndex<String, T>)
    case null
    
    public static func < (lhs: Index<T>, rhs: Index<T>) -> Bool {
        switch (lhs, rhs) {
        case (.array(let left), .array(let right)):             return left < right
        case (.dictionary(let left), .dictionary(let right)):   return left < right
        default:                                                return false
        }
    }
    
    public static func == (lhs: Index<T>, rhs: Index<T>) -> Bool {
        switch (lhs, rhs) {
        case (.array(let left), .array(let right)):             return left == right
        case (.dictionary(let left), .dictionary(let right)):   return left == right
        case (.null, .null):                                    return true
        default:                                                return false
        }
    }
}

public typealias GSONIndex = Index<GSON>
public typealias GSONRawIndex = Index<Any>

extension GSON: Collection {
    
    public typealias Index = GSONRawIndex
    
    public var startIndex: Index {
        switch type {
        case .array:        return .array(rawArray.startIndex)
        case .dictionary:   return .dictionary(rawDictionary.startIndex)
        default:            return .null
        }
    }
    
    public var endIndex: Index {
        switch type {
        case .array:        return .array(rawArray.endIndex)
        case .dictionary:   return .dictionary(rawDictionary.endIndex)
        default:            return .null
        }
    }
    
    public func index(after i: Index) -> Index {
        switch i {
        case .array(let idx):       return .array(rawArray.index(after: idx))
        case .dictionary(let idx):  return .dictionary(rawDictionary.index(after: idx))
        default:                    return .null
        }
    }
    
    public subscript (position: Index) -> (String, GSON) {
        switch position {
        case .array(let idx):       return (String.init(idx), GSON.init(rawArray[idx]))
        case .dictionary(let idx):
            let tuple = rawDictionary[idx]
            return (tuple.key, GSON.init(tuple.value))
        default:                    return ("", GSON.null)
        }
    }
}

public enum GSONKey {
    case index(Int)
    case key(String)
}

public protocol GSONSubscriptType { var gsonKey: GSONKey { get } }
extension Int: GSONSubscriptType { public var gsonKey: GSONKey { return .index(self) } }
extension String: GSONSubscriptType { public var gsonKey: GSONKey { return .key(self) } }

extension GSON {
    
    fileprivate subscript (index index: Int) -> GSON {
        get {
            if type != .array {
                var r = GSON.null
                r.error = error ?? .wrongType
                return r
            } else if rawArray.indices.contains(index) {
                return GSON.init(rawArray[index])
            } else {
                var r = GSON.null
                r.error = error ?? .indexOutOfBounds
                return r
            }
        }
        
        set { if type == .array && rawArray.indices.contains(index) && newValue.error == nil { rawArray[index] = newValue.object } }
    }
    
    fileprivate subscript (key key: String) -> GSON {
        get {
            var r = GSON.null
            
            if type == .dictionary {
                if let value = rawDictionary[key] { return GSON.init(value) }
                else { r.error = .notExist }
            } else if type == .unknown || type == .null {
                r.error = error ?? .notExist
            } else { r.error = .wrongType }
            
            return r
        }
        
        set { if type == .dictionary && newValue.error == nil { rawDictionary[key] = newValue.object } }
    }

    fileprivate subscript (sub sub: GSONSubscriptType) -> GSON {
        get {
            switch sub.gsonKey {
            case .index(let index): return self[index: index]
            case .key(let key):     return self[key: key]
            }
        }
        
        set {
            switch sub.gsonKey {
            case .index(let index): self[index: index] = newValue
            case .key(let key):     self[key: key] = newValue
            }
        }
    }
    
    public subscript (path: [GSONSubscriptType]) -> GSON {
        get { return path.reduce(self) { $0[sub: $1]} }
        
        set {
            switch path.count {
            case 0: return
            case 1: self[sub: path[0]].object = newValue.object
            default:
                var aPath = path
                let first = aPath.removeFirst()
                var nextGSON = self[sub: first]
                nextGSON[aPath] = newValue
                self[sub: first] = nextGSON
            }
        }
    }

    
    public subscript (path: GSONSubscriptType...) -> GSON {
        get { return self[path] }
        set { self[path] = newValue }
    }
}

extension GSON: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) { self.init(value) }
    
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) { self.init(value) }
    
    public init(unicodeScalarLiteral value: StringLiteralType) { self.init(value) }
}

extension GSON: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: IntegerLiteralType) { self.init(value) }
}

extension GSON: ExpressibleByBooleanLiteral {
    
    public init(booleanLiteral value: BooleanLiteralType) { self.init(value) }
}

extension GSON: ExpressibleByFloatLiteral {
    
    public init(floatLiteral value: FloatLiteralType) { self.init(value) }
}

extension GSON: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: Any...) { self.init(elements) }
}

extension GSON: ExpressibleByDictionaryLiteral {
    
    public init(dictionaryLiteral elements: (String, Any)...) { self.init(elements.reduce(into: [String: Any](), { $0[$1.0] = $1.1 })) }
}

extension GSON: RawRepresentable {
    
    public var rawValue: Any { return self.object }
    
    public init?(rawValue: Any) {
        if GSON.init(rawValue).type == .unknown { return nil }
        else { self.init(rawValue) }
    }
    
    public func rawStrings() -> String? {
        do {
            return try jsonEncodedString()
        } catch {
            Log.error(message: "Could not serialize object to JSON because:\(error)")
            return nil
        }
    }
}

extension GSON: JSONConvertible {
    
    public func jsonEncodedString() throws -> String {
        switch type {
        case .array:        return try rawArray.jsonEncodedString()
        case .dictionary:   return try rawDictionary.jsonEncodedString()
        case .string:       return rawString
        case .bool:         return rawBool.description
        case .unknown:      return GSON.nullValue
        case .null:         return GSON.nullValue
        case .int:          return try rawInt.jsonEncodedString()
        case .uint:         return try rawUInt.jsonEncodedString()
        case .double:       return try rawDouble.jsonEncodedString()
        }
    }
}


extension GSON: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String { return (try? self.jsonEncodedString()) ?? "unknown" }
    public var debugDescription: String { return description }
}

extension GSON {
    
    /// OPTIONAL [GSON]
    public var array: [GSON]? { return type == .array ? rawArray.map { GSON.init($0) } : nil }
    
    /// NON-OPTIONAL [GSON]
    public var arrayValue: [GSON] { return array ?? [] }
    
    /// OPTIONAL [ANY]
    public var arrayObject: [Any]? {
        get { return type == .array ? rawArray : nil }
        set { object = newValue ?? GSON.nullValue }
    }
}

extension GSON {
    
    /// OPTIONAL [STRING: GSON]
    public var dictionary: [String: GSON]? {
        guard type == .dictionary else { return nil }
        var r = [String: GSON].init(minimumCapacity: rawDictionary.count)
        rawDictionary.forEach { r[$0.key] = GSON.init($0.value) }
        return r
    }
    
    /// NON-OPTIONAL [STRING: GSON]
    public var dictionaryValue: [String: GSON] { return dictionary ?? [:] }
    
    /// OPTIONAL [STRING: ANY]
    public var dictionaryObject: [String: Any]? {
        get { return type == .dictionary ? rawDictionary : nil }
        set { object = newValue ?? GSON.nullValue }
    }
}

extension GSON {
    
    /// OPTIONAL BOOL
    public var bool: Bool? {
        get {
            switch type {
            case .bool:     return rawBool
            case .int:      return rawInt != 0
            case .uint:     return rawUInt != 0
            case .double:   return rawDouble != 0.0
            case .string:   return ["true", "y", "t", "1", "yes"].contains { rawString.lowercased() == $0 }
            default:        return nil
            }
        }
        set { object = newValue ?? GSON.nullValue }
    }

    /// NON-OPTIONAL BOOL
    public var boolValue: Bool {
        get { return bool ?? false }
        set { object = newValue }
    }
}

extension GSON {
    
    /// OPTIONAL STRING
    public var string: String? {
        get {
            switch type {
            case .string:       return rawString
            case .int:          return String.init(rawInt)
            case .uint:          return String.init(rawUInt)
            case .double:       return String.init(rawDouble)
            case .bool:         return rawBool.description
            default:            return nil
            }
        }
        set { object = newValue ?? GSON.nullValue }
    }

    /// NON-OPTIONAL STRING
    public var stringValue: String {
        get { return string ?? "" }
        set { object = newValue }
    }
}

extension GSON {
    
    /// OPTIONAL INT
    public var int: Int? {
        get {
            switch type {
            case .string:       return Int(rawString)
            case .int:          return rawInt
            case .uint:         return rawUInt > Int.max ? nil : Int(rawUInt)
            case .double:       return Int(rawDouble)
            case .bool:         return rawBool ? 1 : 0
            default:            return nil
            }
        }
        set { object = newValue ?? GSON.nullValue }
    }
    
    /// NON-OPTIONAL INT
    public var intValue: Int {
        get { return int ?? 0 }
        set { object = newValue }
    }
}

extension GSON {
    
    /// OPTIONAL INT
    public var uint: UInt? {
        get {
            switch type {
            case .string:       return UInt(rawString)
            case .int:          return rawInt < 0 ? nil : UInt(rawInt)
            case .uint:         return rawUInt
            case .double:       return UInt(rawDouble)
            case .bool:         return rawBool ? 1 : 0
            default:            return nil
            }
        }
        set { object = newValue ?? GSON.nullValue }
    }
    
    /// NON-OPTIONAL INT
    public var uintValue: UInt {
        get { return uint ?? 0 }
        set { object = newValue }
    }
}

extension GSON {
    
    /// OPTIONAL DOUBLE
    public var double: Double? {
        get {
            switch type {
            case .string:       return Double(rawString)
            case .int:          return Double(rawInt)
            case .uint:         return Double(rawInt)
            case .double:       return rawDouble
            case .bool:         return rawBool ? 1.0 : 0.0
            default:            return nil
            }
        }
        set { object = newValue ?? GSON.nullValue }
    }
    
    /// NON-OPTIONAL STRING
    public var doubleValue: Double {
        get { return double ?? 0.0 }
        set { object = newValue }
    }
}

extension GSON {
    
    public var null: GSON? {
        get {
            switch type {
            case .null, .unknown:     return GSON.null
            default:        return nil
            }
        }
        set {
            object = GSON.nullValue
        }
    }
    
    public func exists() -> Bool { return error == nil }
}

extension GSON: Comparable { }
public func ==(lhs: GSON, rhs: GSON) -> Bool {
    switch (lhs.type, rhs.type) {
    case (.int, .int):                  return lhs.rawInt == rhs.rawInt
    case (.uint, .uint):                return lhs.rawUInt == rhs.rawUInt
    case (.double, .double):            return lhs.rawDouble == rhs.rawDouble
    case (.int, .uint), (.int, .double),
         (.uint, .int), (.uint, .double),
         (.double, .int), (.double, .uint),
         (.bool, .int), (.bool, .uint), (.bool, .double),
         (.int, .bool), (.uint, .bool), (.double, .bool):
        return lhs.doubleValue == rhs.doubleValue
    case (.string, .string):            return lhs.rawString == rhs.rawString
    case (.bool, .bool):                return lhs.rawBool == rhs.rawBool
    case (.array, .array):
        return lhs.description == rhs.description
    case (.dictionary, .dictionary):
        return lhs.description == rhs.description
    case (.null, .null), (.unknown, .null), (.null, .unknown), (.unknown, .unknown):
        return true
    default:                            return false
    }
}

public func <=(lhs: GSON, rhs: GSON) -> Bool {
    switch (lhs.type, rhs.type) {
    case (.int, .int):                  return lhs.rawInt <= rhs.rawInt
    case (.uint, .uint):                return lhs.rawUInt <= rhs.rawUInt
    case (.double, .double):            return lhs.rawDouble <= rhs.rawDouble
    case (.int, .uint), (.int, .double),
         (.uint, .int), (.uint, .double),
         (.double, .int), (.double, .uint),
         (.bool, .int), (.bool, .uint), (.bool, .double),
         (.int, .bool), (.uint, .bool), (.double, .bool):
        return lhs.doubleValue <= rhs.doubleValue
    case (.string, .string):            return lhs.rawString <= rhs.rawString
    case (.bool, .bool):                return lhs.rawBool == rhs.rawBool
    case (.array, .array):
        return lhs.description == rhs.description
    case (.dictionary, .dictionary):
        return lhs.description == rhs.description
    case (.null, .null), (.unknown, .null), (.null, .unknown), (.unknown, .unknown):
        return true
    default:                            return false
    }
}

public func >=(lhs: GSON, rhs: GSON) -> Bool {
    switch (lhs.type, rhs.type) {
    case (.int, .int):                  return lhs.rawInt >= rhs.rawInt
    case (.uint, .uint):                return lhs.rawUInt >= rhs.rawUInt
    case (.double, .double):            return lhs.rawDouble >= rhs.rawDouble
    case (.int, .uint), (.int, .double),
         (.uint, .int), (.uint, .double),
         (.double, .int), (.double, .uint),
         (.bool, .int), (.bool, .uint), (.bool, .double),
         (.int, .bool), (.uint, .bool), (.double, .bool):
        return lhs.doubleValue >= rhs.doubleValue
    case (.string, .string):            return lhs.rawString >= rhs.rawString
    case (.bool, .bool):                return lhs.rawBool == rhs.rawBool
    case (.array, .array):
        return lhs.description == rhs.description
    case (.dictionary, .dictionary):
        return lhs.description == rhs.description
    case (.null, .null), (.unknown, .null), (.null, .unknown), (.unknown, .unknown):
        return true
    default:                            return false
    }
}

public func >(lhs: GSON, rhs: GSON) -> Bool {
    switch (lhs.type, rhs.type) {
    case (.int, .int):                  return lhs.rawInt > rhs.rawInt
    case (.uint, .uint):                return lhs.rawUInt > rhs.rawUInt
    case (.double, .double):            return lhs.rawDouble > rhs.rawDouble
    case (.int, .uint), (.int, .double),
         (.uint, .int), (.uint, .double),
         (.double, .int), (.double, .uint),
         (.bool, .int), (.bool, .uint), (.bool, .double),
         (.int, .bool), (.uint, .bool), (.double, .bool):
        return lhs.doubleValue > rhs.doubleValue
    case (.string, .string):            return lhs.rawString > rhs.rawString
    default:                            return false
    }
}

public func <(lhs: GSON, rhs: GSON) -> Bool {
    switch (lhs.type, rhs.type) {
    case (.int, .int):                  return lhs.rawInt < rhs.rawInt
    case (.uint, .uint):                return lhs.rawUInt < rhs.rawUInt
    case (.double, .double):            return lhs.rawDouble < rhs.rawDouble
    case (.int, .uint), (.int, .double),
         (.uint, .int), (.uint, .double),
         (.double, .int), (.double, .uint),
         (.bool, .int), (.bool, .uint), (.bool, .double),
         (.int, .bool), (.uint, .bool), (.double, .bool):
        return lhs.doubleValue < rhs.doubleValue
    case (.string, .string):            return lhs.rawString < rhs.rawString
    default:                            return false
    }
}

extension GSON: Codable {
    
    private static var codeableTypes: [Codable.Type] {
        return [
            Bool.self,
            Int.self,
            Int8.self,
            Int16.self,
            Int32.self,
            Int64.self,
            UInt.self,
            UInt8.self,
            UInt16.self,
            UInt32.self,
            UInt64.self,
            Double.self,
            String.self,
            [GSON].self,
            [String: GSON].self,
        ]
    }
    
    public init(from decoder: Decoder) throws {
        var object: Any?
        if let container = try? decoder.singleValueContainer(), !container.decodeNil() {
            for type in GSON.codeableTypes {
                if object != nil { break }
                
                switch type {
                case let boolType as Bool.Type:                         object = try? container.decode(boolType)
                case let intType as Int.Type:                           object = try? container.decode(intType)
                case let int8Type as Int8.Type:                         object = try? container.decode(int8Type)
                case let int16Type as Int16.Type:                       object = try? container.decode(int16Type)
                case let int32Type as Int32.Type:                       object = try? container.decode(int32Type)
                case let int64Type as Int64.Type:                       object = try? container.decode(int64Type)
                case let uintType as UInt.Type:                         object = try? container.decode(uintType)
                case let uint8Type as UInt8.Type:                       object = try? container.decode(uint8Type)
                case let uint16Type as UInt16.Type:                     object = try? container.decode(uint16Type)
                case let uint32Type as UInt32.Type:                     object = try? container.decode(uint32Type)
                case let uint64Type as UInt64.Type:                     object = try? container.decode(uint64Type)
                case let doubleType as Double.Type:                     object = try? container.decode(doubleType)
                case let stringType as String.Type:                     object = try? container.decode(stringType)
                case let arrayType as [GSON].Type:                      object = try? container.decode(arrayType)
                case let dictionaryType as [String: GSON].Type:         object = try? container.decode(dictionaryType)
                default:                                                break
                }
            }
        }
        
        self.init(object ?? GSON.nullValue)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        guard !isNull else {
            try container.encodeNil()
            return
        }
        
        switch object {
        case let boolValue as Bool:                         try container.encode(boolValue)
        case let intValue as Int:                           try container.encode(intValue)
        case let int8Value as Int8:                         try container.encode(int8Value)
        case let int16Value as Int16:                       try container.encode(int16Value)
        case let int32Value as Int32:                       try container.encode(int32Value)
        case let int64Value as Int64:                       try container.encode(int64Value)
        case let uintValue as UInt:                         try container.encode(uintValue)
        case let uint8Value as UInt8:                       try container.encode(uint8Value)
        case let uint16Value as UInt16:                     try container.encode(uint16Value)
        case let uint32Value as UInt32:                     try container.encode(uint32Value)
        case let uint64Value as UInt64:                     try container.encode(uint64Value)
        case let doubleValue as Double:                     try container.encode(doubleValue)
        case let stringValue as String:                     try container.encode(stringValue)
        case is [Any]:                                      try container.encode(arrayValue)
        case is [String: Any]:                              try container.encode(dictionaryValue)
        default:                                            break
        }
    }
}
