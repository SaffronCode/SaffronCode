/**
 * Created by mes on 1/6/2017.
 */
package googleAPI.type {
public class PlaceDetailClass {

    public var html_attributions:Array = [];

    /**OK,*/
    public var status:String = "";

    /**Full result of the current place*/
    public var result:placeDetailResultClass = new placeDetailResultClass();

    public function PlaceDetailClass() {
    }
}
}
