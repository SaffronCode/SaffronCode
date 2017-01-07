/**
 * Created by mes on 1/6/2017.
 */
package googleAPI.type {
public class placeDetailResultClass {

    /**{
            "long_name" : "Yazd",
            "short_name" : "Yazd",
            "types" : [ "locality", "political" ]
         },*/
    public var address_components:Vector.<address_componentsClass> = new Vector.<address_componentsClass>();

    /**"\u003cspan class=\"locality\"\u003eYazd\u003c/span\u003e, \u003cspan class=\"region\"\u003eYazd Province\u003c/span\u003e, \u003cspan class=\"country-name\"\u003eIran\u003c/span\u003e"*/
    public var adr_address:String ;

    /**Yazd, Yazd Province, Iran*/
    public var formatted_address:String = "" ;

    /**"location" : {
            "lat" : 31.8974232,
            "lng" : 54.3568562
         },
     "viewport" : {*/
    public var geometry:geometryClass = new geometryClass();

    /**https://maps.gstatic.com/mapfiles/place_api/icons/geocode-71.png*/
    public var icon:String ;

    /**8f6938f9b6ee5bc8be749c3c390dcd3a582ab1ec*/
    public var id:String ;

    /**Yazd*/
    public var name:String ;

    public var photos:Vector.<photosClass> = new Vector.<photosClass>();

    /**ChIJkSpbA5MZpj8RDKHU152hkl0*/
    public var place_id:String ;

    /**CmRbAAAAOkYBdwbJOS8V16t_o3MkPQxdoQlFzzMjw3VMsDqAZ0qxjafeZXJjKKyhATjQ0yXSB0o9Nw99vaRP5RFUIKq0iUeSQ_G1an2kvIcZtd7OafLtF8YovqjahxyXXdURff0AEhDlVdJm32BlJdJ5*/
    public var reference:String ;

    /**GOOGLE*/
    public var scope:String ;

    /**"locality", "political"*/
    public var types:Array = [] ;

    /**https://maps.google.com/?q=Yazd,+Yazd+Province,+Iran&ftid=0x3fa61993035b2a91:0x5d92a19dd7d4a10c*/
    public var url:String ;

    /**210*/
    public var utc_offset:int ;

    /**Yazd*/
    public var vicinity:String ;

    public function placeDetailResultClass() {
    }
}
}
