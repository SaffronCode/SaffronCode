/**
 * Created by mes on 1/6/2017.
 */
package googleAPI.service {
import googleAPI.GoogleServices;
import googleAPI.type.PlaceDetailClass;

import restDoaService.RestDoaServiceCaller;

public class PlaceDetail extends RestDoaServiceCaller {

    public var data:PlaceDetailClass = new PlaceDetailClass();

    public function PlaceDetail(offlineDataIsOK_v:Boolean = true, instantOfflineData_v:Boolean = true) {
        var date:Date = new Date();
        date.date -= 300 ;
        super("https://maps.googleapis.com/maps/api/place/details/json", data, offlineDataIsOK_v, instantOfflineData_v, date, true);
    }

    /**The place id value should be somthing like this : ChIJkSpbA5MZpj8RDKHU152hkl0*/
    public function load(placeid:String):void
    {
        super.loadParam({placeid:placeid,key:GoogleServices.getAPIKey()});
    }
}
}
