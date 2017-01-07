/**
 * Created by mes on 1/6/2017.
 */
package googleAPI.service {
import contents.PageData;

import googleAPI.GoogleServices;
import googleAPI.type.AutocompleteResult;

import restDoaService.RestDoaServiceCaller;

public class AutocompletePlaces extends RestDoaServiceCaller {

    public var data:AutocompleteResult = new AutocompleteResult();

    public function AutocompletePlaces() {
        var date:Date = new Date();
        date.date -= 30 ;
        super("https://maps.googleapis.com/maps/api/place/autocomplete/json", data, true, true, date, true);
    }

    public function load(input:String):void
    {
        super.loadParam({input:input,key:GoogleServices.getAPIKey()})
    }
	
	/**Each linkData is predictionClass*/
	public function pageData():contents.PageData
	{
		var pageData:PageData = new PageData();
		for(var i = 0 ; data.predictions!=null && i<data.predictions.length ; i++)
		{
			pageData.links1.push(data.predictions[i].linkData());
		}
		return pageData ;
	}
}
}
