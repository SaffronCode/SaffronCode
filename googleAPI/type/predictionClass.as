/**
 * Created by mes on 1/6/2017.
 */
package googleAPI.type {
public class predictionClass {

    /**"Victoria, Australie"*/
    public var description:String ;

    /**0328fb981d48f228012b5d4b7ab0d0f404f439fd*/
    public var id:String = "";

    /**Lenght and offset*/
    public var matched_substrings:Vector.<matched_substringsClass> = new Vector.<matched_substringsClass>();

    /**ChIJT5UYfksx1GoRNJWCvuL8Tlo*/
    public var place_id:String ;

    /**CjQrAAAAo_uBPVsf1cXUJ8elPYxWjHGcA5aDJ_X8FVCnR4KtmT7UodEpG63s3y4ErHnmdf-6EhDv63zil2W-CTDLTwBgXinCGhTyYDuHKVMZAaIZTGeXxJA7LH8-5g*/
    public var reference:String ;

    /**"main_text" : "Victoria",
     "main_text_matched_substrings" : [
     {
        "length" : 4,
        "offset" : 0
     }
     ],
     "secondary_text" : "Australie"*/
    public var structured_formatting:structured_formattingClass = new structured_formattingClass();


    /**"terms" :  {
               "offset" : 0,
               "value" : "Victoria"
            },
     {
        "offset" : 10,
        "value" : "Australie"
     }*/
    public var terms:Vector.<termsClass> = new Vector.<termsClass>();

    /**"administrative_area_level_1", "political", "geocode"*/
    public var types:Array = [];

    public function predictionClass() {
    }
}
}
