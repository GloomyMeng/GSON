//
//  BaseTests.swift
//  GSONTests
//
//  Created by Gloomy Sunday on 2018/8/27.
//

import XCTest
@testable import GSON

class BaseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        
        let gsonValue = GSON.init(parseJSON: bigjsonString)
        XCTAssertEqual(gsonValue?.array?.count, 3)
        XCTAssertEqual(GSON.init("123").description, "123")
        XCTAssertEqual(GSON.init(["1": "2"])["1"].string, "2")
        let dictionary = ["number": 1.0, "null": GSON.null]
        let c = GSON.init(dictionary)
        XCTAssertEqual(c["number"].double, 1.0)
        
        let gsonValue2 = GSON.init(parseJSON: bigjsonString)
        XCTAssertEqual(gsonValue, gsonValue2)
    }
    
    func testCompare() {
        XCTAssertNotEqual(GSON.init("32.1234567890"), GSON.init(32.1234567890))
        let veryLargeNumber: UInt64 = 9876543210987654321
        XCTAssertNotEqual(GSON("9876543210987654321"), GSON(NSNumber(value: veryLargeNumber)))
        XCTAssertNotEqual(GSON("9876543210987654321.12345678901234567890"), GSON(9876543210987654321.12345678901234567890))
        XCTAssertEqual(GSON("😊"), GSON("😊"))
        XCTAssertNotEqual(GSON("😱"), GSON("😁"))
        XCTAssertEqual(GSON([123, 321, 456]), GSON([123, 321, 456]))
        XCTAssertNotEqual(GSON([123, 321, 456]), GSON(123456789))
        XCTAssertNotEqual(GSON([123, 321, 456]), GSON("string"))
        XCTAssertNotEqual(GSON(["1": 123, "2": 321, "3": 456]), GSON("string"))
        XCTAssertEqual(GSON(["1": 123, "2": 321, "3": 456]), GSON(["2": 321, "1": 123, "3": 456]))
        XCTAssertEqual(GSON.null, GSON(GSON.nullValue))
        XCTAssertNotEqual(GSON.null, GSON(123))
    }
    
    func testGSONDoesProductValidWithCorrectKeyPath() {
        let gson = GSON.init(parseJSON: bigjsonString)
        let tweets = gson
        let tweets_array = gson?.array
        let tweets_1 = gson?[1]
        _ = tweets_1?[1]
        let tweets_1_user_name = tweets_1?["user"]["name"]
        let tweets_1_user_name_string = tweets_1?["user"]["name"].string
        XCTAssertNotEqual(tweets?.type, Type.null)
        XCTAssert(tweets_array != nil)
        XCTAssertNotEqual(tweets_1?.type, Type.null)
        XCTAssertEqual(tweets_1_user_name, GSON("Raffi Krikorian"))
        XCTAssertEqual(tweets_1_user_name_string!, "Raffi Krikorian")
        
        let tweets_1_coordinates = tweets_1?["coordinates"]
        let tweets_1_coordinates_coordinates = tweets_1_coordinates?["coordinates"]
        let tweets_1_coordinates_coordinates_point_0_double = tweets_1_coordinates_coordinates?[0].double
        let tweets_1_coordinates_coordinates_point_1_float = tweets_1_coordinates_coordinates?[1].double
        let new_tweets_1_coordinates_coordinates = GSON([-122.25831, 37.871609] as NSArray)
        XCTAssertEqual(tweets_1_coordinates_coordinates, new_tweets_1_coordinates_coordinates)
        XCTAssertEqual(tweets_1_coordinates_coordinates_point_0_double!, -122.25831)
        XCTAssertTrue(tweets_1_coordinates_coordinates_point_1_float! == 37.871609)
        let tweets_1_coordinates_coordinates_point_0_string = tweets_1_coordinates_coordinates?[0].stringValue
        let tweets_1_coordinates_coordinates_point_1_string = tweets_1_coordinates_coordinates?[1].stringValue
        XCTAssertEqual(tweets_1_coordinates_coordinates_point_0_string, "-122.25831")
        XCTAssertEqual(tweets_1_coordinates_coordinates_point_1_string, "37.871609")
        let tweets_1_coordinates_coordinates_point_0 = tweets_1_coordinates_coordinates?[0]
        let tweets_1_coordinates_coordinates_point_1 = tweets_1_coordinates_coordinates?[1]
        XCTAssertEqual(tweets_1_coordinates_coordinates_point_0, GSON(-122.25831))
        XCTAssertEqual(tweets_1_coordinates_coordinates_point_1, GSON(37.871609))
        
        let created_at = gson?[0]["created_at"].string
        let id_str = gson?[0]["id_str"].string
        let favorited = gson?[0]["favorited"].bool
        let id = gson?[0]["id"].int
        let in_reply_to_user_id_str = gson?[0]["in_reply_to_user_id_str"]
        XCTAssertEqual(created_at!, "Tue Aug 28 21:16:23 +0000 2012")
        XCTAssertEqual(id_str!, "240558470661799936")
        XCTAssertFalse(favorited!)
        XCTAssertEqual(id!, 240558470661799936)
        XCTAssertEqual(in_reply_to_user_id_str?.type, Type.unknown)
        XCTAssertEqual(in_reply_to_user_id_str, GSON.null)
        
        let user = gson?[0]["user"]
        let user_name = user?["name"].string
        let user_profile_image_url = user?["profile_image_url"].string
        XCTAssert(user_name == "OAuth Dancer")
        XCTAssert(user_profile_image_url == "http://a0.twimg.com/profile_images/730275945/oauth-dancer_normal.jpg")
        
        let user_dictionary = gson?[0]["user"].dictionary
        let user_dictionary_name = user_dictionary?["name"]?.string
        let user_dictionary_name_profile_image_url = user_dictionary?["profile_image_url"]?.string
        XCTAssert(user_dictionary_name == "OAuth Dancer")
        XCTAssert(user_dictionary_name_profile_image_url == "http://a0.twimg.com/profile_images/730275945/oauth-dancer_normal.jpg")
    }
    
    func testJSONNumberCompare() {
        XCTAssertEqual(GSON(12376352.123321), GSON(12376352.123321))
        XCTAssertGreaterThan(GSON(20.211), GSON(20.112))
        XCTAssertGreaterThanOrEqual(GSON(30.211), GSON(20.112))
        XCTAssertGreaterThanOrEqual(GSON(65232), GSON(65232))
        XCTAssertLessThan(GSON(-82320.211), GSON(20.112))
        XCTAssertLessThanOrEqual(GSON(-320.211), GSON(123.1))
        XCTAssertLessThanOrEqual(GSON(-8763), GSON(-8763))
        
        XCTAssertEqual(GSON(12376352.123321), GSON(12376352.123321))
        XCTAssertGreaterThan(GSON(20.211), GSON(20.112))
        XCTAssertGreaterThanOrEqual(GSON(30.211), GSON(20.112))
        XCTAssertGreaterThanOrEqual(GSON(65232), GSON(65232))
        XCTAssertLessThan(GSON(-82320.211), GSON(20.112))
        XCTAssertLessThanOrEqual(GSON(-320.211), GSON(123.1))
        XCTAssertLessThanOrEqual(GSON(-8763), GSON(-8763))
    }
    
    func testNumberConvertToString() {
        XCTAssertEqual(GSON(true).stringValue, "true")
        XCTAssertEqual(GSON(999.9823).stringValue, "999.9823")
        XCTAssertEqual(GSON(true).int?.description, "1")
        XCTAssertEqual(GSON(false).int?.description, "0")
        XCTAssertEqual(GSON("hello").intValue.description, "0")
        XCTAssertEqual(GSON(["a", "b", "c", "d"]).intValue.description, "0")
        XCTAssertEqual(GSON(["a": "b", "c": "d"]).intValue.description, "0")
    }
    
    func testNumberPrint() {
        
        XCTAssertEqual(GSON(false).description, "false")
        XCTAssertEqual(GSON(true).description, "true")
        
        XCTAssertEqual(GSON(1).description, "1")
        XCTAssertEqual(GSON(22).description, "22")
        #if (arch(x86_64) || arch(arm64))
        XCTAssertEqual(GSON(9.22337203685478E18).description, "9.22337203685478e+18")
        #elseif (arch(i386) || arch(arm))
        XCTAssertEqual(GSON(2147483647).description, "2147483647")
        #endif
        XCTAssertEqual(GSON(-1).description, "-1")
        XCTAssertEqual(GSON(-934834834).description, "-934834834")
        XCTAssertEqual(GSON(-2147483648).description, "-2147483648")
        
        XCTAssertEqual(GSON(1.5555).description, "1.5555")
        XCTAssertEqual(GSON(-9.123456789).description, "-9.123456789")
        XCTAssertEqual(GSON(-0.00000000000000001).description, "-1e-17")
        XCTAssertEqual(GSON(-999999999999999999999999.000000000000000000000001).description, "-1e+24")
        XCTAssertEqual(GSON(-9999999991999999999999999.88888883433343439438493483483943948341).stringValue, "-9.999999992e+24")
        
        XCTAssertEqual(GSON(Int(Int.max)).description, "\(Int.max)")
        XCTAssertEqual(GSON(Int.min).description, "\(Int.min)")
        XCTAssertEqual(GSON(UInt.max).description, "\(UInt.max)")
        XCTAssertEqual(GSON(UInt64.max).description, "\(UInt64.max)")
        XCTAssertEqual(GSON(Int64.max).description, "\(Int64.max)")
        XCTAssertEqual(GSON(UInt64.max).description, "\(UInt64.max)")
        
        XCTAssertEqual(GSON(Double.infinity).description, "inf")
        XCTAssertEqual(GSON(-Double.infinity).description, "-inf")
        XCTAssertEqual(GSON(Double.nan).description, "nan")
        
        XCTAssertEqual(GSON(1.0/0.0).description, "inf")
        XCTAssertEqual(GSON(-1.0/0.0).description, "-inf")
        XCTAssertEqual(GSON(0.0/0.0).description, "nan")
    }
    
    func testNullJSON() {
        XCTAssertEqual(GSON.null.debugDescription, "null")
        
        let gson: GSON = GSON.null
        XCTAssertEqual(gson.debugDescription, "null")
        XCTAssertNil(gson.error)
        let gson1: GSON = GSON(GSON.nullValue)
        if gson1 != GSON.null {
            XCTFail("gson1 should be nil")
        }
    }
    
    func testExistance() {
        let dictionary = ["number": 1111]
        let gson = GSON(dictionary)
        XCTAssertFalse(gson["unspecifiedValue"].exists())
        XCTAssertFalse(gson[0].exists())
        XCTAssertTrue(gson["number"].exists())
        
        let array = [["number": 1111]]
        let jsonForArray = GSON(array)
        XCTAssertTrue(jsonForArray[0].exists())
        XCTAssertFalse(jsonForArray[1].exists())
        XCTAssertFalse(jsonForArray["someValue"].exists())
    }
    
    func testErrorHandle() {
        let gson = GSON.init(parseJSON: bigjsonString)
        
        if gson?["wrong-type"].string != nil {
            XCTFail("Should not run into here")
        } else {
            XCTAssertEqual(gson?["wrong-type"].error, GSONError.wrongType)
        }

        if gson?[0]["not-exist"].string != nil {
            XCTFail("Should not run into here")
        } else {
            XCTAssertEqual(gson?[0]["not-exist"].error, GSONError.notExist)
        }

        let wrongJSON = GSON(NSObject())
        if let error = wrongJSON.error {
            XCTAssertEqual(error, GSONError.unsupportedType)
        }
    }

    func testReturnObject() {
        let gson = GSON.init(parseJSON: bigjsonString)
        XCTAssertNotNil(gson?.object)
    }

    func testErrorThrowing() {
        let invalidJson = "{\"foo\": 300]"  // deliberately incorrect GSON
        _ = GSON.init(parseJSON: invalidJson)
    }

    
    var bigjsonString: String = """
[
  {
  "coordinates":null,
  "truncated":false,
  "created_at":"Tue Aug 28 21:16:23 +0000 2012",
  "favorited":false,
  "id_str":"240558470661799936",
  "in_reply_to_user_id_str":null,
  "entities":{
  "urls":[
  
  ],
  "hashtags":[
  
  ],
  "user_mentions":[
  
  ]
  },
  "text":"just another test",
  "contributors":null,
  "id":240558470661799936,
  "retweet_count":0,
  "in_reply_to_status_id_str":null,
  "geo":null,
  "retweeted":false,
  "in_reply_to_user_id":null,
  "place":null,
  "user":{
  "name":"OAuth Dancer",
  "profile_sidebar_fill_color":"DDEEF6",
  "profile_background_tile":true,
  "profile_sidebar_border_color":"C0DEED",
  "profile_image_url":"http://a0.twimg.com/profile_images/730275945/oauth-dancer_normal.jpg",
  "created_at":"Wed Mar 03 19:37:35 +0000 2010",
  "location":"San Francisco, CA",
  "follow_request_sent":false,
  "id_str":"119476949",
  "is_translator":false,
  "profile_link_color":"0084B4",
  "entities":{
  "url":{
  "urls":[
          {
          "expanded_url":null,
          "url":"http://bit.ly/oauth-dancer",
          "indices":[
                     0,
                     26
                     ],
          "display_url":null
          }
          ]
  },
  "description":null
  },
  "default_profile":false,
  "url":"http://bit.ly/oauth-dancer",
  "contributors_enabled":false,
  "favourites_count":7,
  "utc_offset":null,
  "profile_image_url_https":"https://si0.twimg.com/profile_images/730275945/oauth-dancer_normal.jpg",
  "id":119476949,
  "listed_count":1,
  "profile_use_background_image":true,
  "profile_text_color":"333333",
  "followers_count":28,
  "lang":"en",
  "protected":false,
  "geo_enabled":true,
  "notifications":false,
  "description":"",
  "profile_background_color":"C0DEED",
  "verified":false,
  "time_zone":null,
  "profile_background_image_url_https":"https://si0.twimg.com/profile_background_images/80151733/oauth-dance.png",
  "statuses_count":166,
  "profile_background_image_url":"http://a0.twimg.com/profile_background_images/80151733/oauth-dance.png",
  "default_profile_image":false,
  "friends_count":14,
  "following":false,
  "show_all_inline_media":false,
  "screen_name":"oauth_dancer"
  },
  "in_reply_to_screen_name":null,
  "in_reply_to_status_id":null
  },
  {
  "coordinates":{
  "coordinates":[
                 -122.25831,
                 37.871609
                 ],
  "type":"Point"
  },
  "truncated":false,
  "created_at":"Tue Aug 28 21:08:15 +0000 2012",
  "favorited":false,
  "id_str":"240556426106372096",
  "in_reply_to_user_id_str":null,
  "entities":{
  "urls":[
          {
          "expanded_url":"http://blogs.ischool.berkeley.edu/i290-abdt-s12/",
          "url":"http://t.co/bfj7zkDJ",
          "indices":[
                     79,
                     99
                     ],
          "display_url":"blogs.ischool.berkeley.edu/i290-abdt-s12/"
          }
          ],
  "hashtags":[
  
  ],
  "user_mentions":[
                   {
                   "name":"Cal",
                   "id_str":"17445752",
                   "id":17445752,
                   "indices":[
                              60,
                              64
                              ],
                   "screen_name":"Cal"
                   },
                   {
                   "name":"Othman Laraki",
                   "id_str":"20495814",
                   "id":20495814,
                   "indices":[
                              70,
                              77
                              ],
                   "screen_name":"othman"
                   }
                   ]
  },
  "text":"lecturing at the analyzing big data with twitter class at @cal with @othman  http://t.co/bfj7zkDJ",
  "contributors":null,
  "id":240556426106372096,
  "retweet_count":3,
  "in_reply_to_status_id_str":null,
  "geo":{
  "coordinates":[
                 37.871609,
                 -122.25831
                 ],
  "type":"Point"
  },
  "retweeted":false,
  "possibly_sensitive":false,
  "in_reply_to_user_id":null,
  "place":{
  "name":"Berkeley",
  "country_code":"US",
  "country":"United States",
  "attributes":{
  
  },
  "url":"http://api.twitter.com/1/geo/id/5ef5b7f391e30aff.json",
  "id":"5ef5b7f391e30aff",
  "bounding_box":{
  "coordinates":[
                 [
                  [
                   -122.367781,
                   37.835727
                   ],
                  [
                   -122.234185,
                   37.835727
                   ],
                  [
                   -122.234185,
                   37.905824
                   ],
                  [
                   -122.367781,
                   37.905824
                   ]
                  ]
                 ],
  "type":"Polygon"
  },
  "full_name":"Berkeley, CA",
  "place_type":"city"
  },
  "user":{
  "name":"Raffi Krikorian",
  "profile_sidebar_fill_color":"DDEEF6",
  "profile_background_tile":false,
  "profile_sidebar_border_color":"C0DEED",
  "profile_image_url":"http://a0.twimg.com/profile_images/1270234259/raffi-headshot-casual_normal.png",
  "created_at":"Sun Aug 19 14:24:06 +0000 2007",
  "location":"San Francisco, California",
  "follow_request_sent":false,
  "id_str":"8285392",
  "is_translator":false,
  "profile_link_color":"0084B4",
  "entities":{
  "url":{
  "urls":[
          {
          "expanded_url":"http://about.me/raffi.krikorian",
          "url":"http://t.co/eNmnM6q",
          "indices":[
                     0,
                     19
                     ],
          "display_url":"about.me/raffi.krikorian"
          }
          ]
  },
  "description":{
  "urls":[
  
  ]
  }
  },
  "default_profile":true,
  "url":"http://t.co/eNmnM6q",
  "contributors_enabled":false,
  "favourites_count":724,
  "utc_offset":-28800,
  "profile_image_url_https":"https://si0.twimg.com/profile_images/1270234259/raffi-headshot-casual_normal.png",
  "id":8285392,
  "listed_count":619,
  "profile_use_background_image":true,
  "profile_text_color":"333333",
  "followers_count":18752,
  "lang":"en",
  "protected":false,
  "geo_enabled":true,
  "notifications":false,
  "description":"Director of @twittereng's Platform Services. I break things.",
  "profile_background_color":"C0DEED",
  "verified":false,
  "time_zone":"Pacific Time (US &amp; Canada)",
  "profile_background_image_url_https":"https://si0.twimg.com/images/themes/theme1/bg.png",
  "statuses_count":5007,
  "profile_background_image_url":"http://a0.twimg.com/images/themes/theme1/bg.png",
  "default_profile_image":false,
  "friends_count":701,
  "following":true,
  "show_all_inline_media":true,
  "screen_name":"raffi"
  },
  "in_reply_to_screen_name":null,
  "in_reply_to_status_id":null
  },
  {
  "coordinates":null,
  "truncated":false,
  "created_at":"Tue Aug 28 19:59:34 +0000 2012",
  "favorited":false,
  "id_str":"240539141056638977",
  "in_reply_to_user_id_str":null,
  "entities":{
  "urls":[
  
  ],
  "hashtags":[
  
  ],
  "user_mentions":[
  
  ]
  },
  "text":"You'd be right more often if you thought you were wrong.",
  "contributors":null,
  "id":240539141056638977,
  "retweet_count":1,
  "in_reply_to_status_id_str":null,
  "geo":null,
  "retweeted":false,
  "in_reply_to_user_id":null,
  "place":null,
  "source":"web",
  "user":{
  "name":"Taylor Singletary",
  "profile_sidebar_fill_color":"FBFBFB",
  "profile_background_tile":true,
  "profile_sidebar_border_color":"000000",
  "profile_image_url":"http://a0.twimg.com/profile_images/2546730059/f6a8zq58mg1hn0ha8vie_normal.jpeg",
  "created_at":"Wed Mar 07 22:23:19 +0000 2007",
  "location":"San Francisco, CA",
  "follow_request_sent":false,
  "id_str":"819797",
  "is_translator":false,
  "profile_link_color":"c71818",
  "entities":{
  "url":{
  "urls":[
          {
          "expanded_url":"http://www.rebelmouse.com/episod/",
          "url":"http://t.co/Lxw7upbN",
          "indices":[
                     0,
                     20
                     ],
          "display_url":"rebelmouse.com/episod/"
          }
          ]
  },
  "description":{
  "urls":[
  
  ]
  }
  },
  "default_profile":false,
  "url":"http://t.co/Lxw7upbN",
  "contributors_enabled":false,
  "favourites_count":15990,
  "utc_offset":-28800,
  "profile_image_url_https":"https://si0.twimg.com/profile_images/2546730059/f6a8zq58mg1hn0ha8vie_normal.jpeg",
  "id":819797,
  "listed_count":340,
  "profile_use_background_image":true,
  "profile_text_color":"D20909",
  "followers_count":7126,
  "lang":"en",
  "protected":false,
  "geo_enabled":true,
  "notifications":false,
  "description":"Reality Technician, Twitter API team, synthesizer enthusiast; a most excellent adventure in timelines. I know it's hard to believe in something you can't see.",
  "profile_background_color":"000000",
  "verified":false,
  "time_zone":"Pacific Time (US &amp; Canada)",
  "profile_background_image_url_https":"https://si0.twimg.com/profile_background_images/643655842/hzfv12wini4q60zzrthg.png",
  "statuses_count":18076,
  "profile_background_image_url":"http://a0.twimg.com/profile_background_images/643655842/hzfv12wini4q60zzrthg.png",
  "default_profile_image":false,
  "friends_count":5444,
  "following":true,
  "show_all_inline_media":true,
  "screen_name":"episod"
  },
  "in_reply_to_screen_name":null,
  "in_reply_to_status_id":null
  }
  ]
"""
}

