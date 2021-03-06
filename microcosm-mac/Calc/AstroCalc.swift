//
//  AstroCalc.swift
//  microcosm-mac
//
//  Created by Yuji Ogata on 2016/09/08.
//  Copyright © 2016年 Yuji Ogata. All rights reserved.
//

import Cocoa

class AstroCalc: NSObject {
    var swiss : SwissEph = SwissEph()
    let common: CommonData = CommonData()

    init(path: String) {
        swiss.swe_set_ephe_path(path)
    }
    
    func PositionCalc(udata: UserData, config: ConfigData) -> [PlanetData] {
        var plist: [PlanetData] = []
        var ret: SweRet
        let iflag: Int = SEFLG_SWIEPH | SEFLG_SPEED

        //        let retc: SweTimeRet = swiss.swe_utc_time_zone(2012, month: 12, day: 21,
        //                                                       hour: 12, minute: 0, second: 0,
        //                                                       timezone: 9.0)
        
        let retc: SweTimeRet = swiss.swe_utc_time_zone(udata.birth_year, month: udata.birth_month, day: udata.birth_day,
                                                       hour: udata.birth_hour, minute: udata.birth_minute, second: udata.birth_second,
                                                       timezone: 9.0)
        ret = swiss.utc_to_jd(retc.year, month: retc.month, day: retc.day, hour: retc.hour, minute: retc.minute, second: retc.second, gregflag: true)

        let ut: Double = ret.tmpDbl6[0]
        
        for i in 0..<10 {
            
            ret = swiss.swe_calc_ut(ut, ipl: i, iflag: iflag)
//                    ret = swiss.swe_calc_ut(2457831.042456, ipl: 3, iflag: iflag)
            let p: PlanetData = PlanetData()
            p.absolute_position = ret.xx[0]
            p.speed = ret.xx[3]
            plist.append(p)
        }
        
        
        return plist
    }
    
    func CuspCalc(_ year: Int, month: Int, day: Int, hour: Int, min: Int, sec: Double, lat: Double, lng: Double, houseKind: Int) -> [Double]
    {
        var ret: SweRet
        var retd: [Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        let retc: SweTimeRet = swiss.swe_utc_time_zone(year, month: month, day: day,
                                                       hour: hour, minute: min, second: sec,
                                                       timezone: 9.0)
        ret = swiss.utc_to_jd(retc.year, month: retc.month, day: retc.day, hour: retc.hour, minute: retc.minute, second: retc.second, gregflag: true)
        
        let ut: Double = ret.tmpDbl6[0]
        
        ret = swiss.swe_houses(tjd_ut:ut, geolat:  lat,geolon:  lng,hsys:  "P")

        for i in 0..<13 {
            retd[i] = ret.cusps[i]
        }
        
        return retd
    }

}
