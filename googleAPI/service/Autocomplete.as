/**
 * Created by mes on 1/6/2017.
 */
package googleAPI.service {
import googleAPI.GoogleServices;
import googleAPI.type.AutocompleteResult;

import restDoaService.RestDoaServiceCaller;

public class Autocomplete extends RestDoaServiceCaller {

    public var data:AutocompleteResult = new AutocompleteResult();

    public function Autocomplete(offlineDataIsOK_v:Boolean = false, instantOfflineData_v:Boolean = false) {
        var date:Date = new Date();
        date.date -= 30 ;
        super("https://maps.googleapis.com/maps/api/place/autocomplete/json", data, offlineDataIsOK_v, instantOfflineData_v, date, true);
    }

    public function load(input:String):void
    {
        super.loadParam({input:input,key:GoogleServices.getAPIKey()})
    }
}
}
