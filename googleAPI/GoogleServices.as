/**
 * Created by mes on 1/6/2017.
 */
package googleAPI {
public class GoogleServices {

    private static var _api:String ;

    public static function setAPIKey(APIKey:String):void
    {
        _api = APIKey;
    }

    public static function getAPIKey():String
    {
        return _api ;
    }
}
}
