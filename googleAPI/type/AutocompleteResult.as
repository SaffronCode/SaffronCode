/**
 * Created by mes on 1/6/2017.
 */
package googleAPI.type {
public class AutocompleteResult {

    public var predictions:Vector.<predictionClass> = new Vector.<predictionClass>();

    /**OK,*/
    public var status:String = ""

    /**{
   "predictions" : [
      {
         "description" : "Victoria, Australie",
         "id" : "0328fb981d48f228012b5d4b7ab0d0f404f439fd",
         "matched_substrings" : [
            {
               "length" : 4,
               "offset" : 0
            }
         ],
         "place_id" : "ChIJT5UYfksx1GoRNJWCvuL8Tlo",
         "reference" : "CjQrAAAAo_uBPVsf1cXUJ8elPYxWjHGcA5aDJ_X8FVCnR4KtmT7UodEpG63s3y4ErHnmdf-6EhDv63zil2W-CTDLTwBgXinCGhTyYDuHKVMZAaIZTGeXxJA7LH8-5g",
         "structured_formatting" : {
            "main_text" : "Victoria",
            "main_text_matched_substrings" : [
               {
                  "length" : 4,
                  "offset" : 0
               }
            ],
            "secondary_text" : "Australie"
         },
         "terms" : [
            {
               "offset" : 0,
               "value" : "Victoria"
            },
            {
               "offset" : 10,
               "value" : "Australie"
            }
         ],
         "types" : [ "administrative_area_level_1", "political", "geocode" ]
      },
      {
         "description" : "Victorville, Californie, États-Unis",
         "id" : "dd296d3fde2a539b9279cdd817c01183f69d07a7",
         "matched_substrings" : [
            {
               "length" : 4,
               "offset" : 0
            }
         ],
         "place_id" : "ChIJedLdY1pkw4ARdjT0JVkRlQ0",
         "reference" : "CkQ8AAAAtD11A-sl7LlnmZXezmU8h8Ffz8KYp8MWWuVqDvn1sZw8C6vjdmf2WlHgMBghQjd4v3WwedF21xMgkqEPOuy66hIQGFVqPCVk_1QVYfoItWukwxoUAJj_6Z8lsJqAQpVwTb6m7TaSShE",
         "structured_formatting" : {
            "main_text" : "Victorville",
            "main_text_matched_substrings" : [
               {
                  "length" : 4,
                  "offset" : 0
               }
            ],
            "secondary_text" : "Californie, États-Unis"
         },
         "terms" : [
            {
               "offset" : 0,
               "value" : "Victorville"
            },
            {
               "offset" : 13,
               "value" : "Californie"
            },
            {
               "offset" : 25,
               "value" : "États-Unis"
            }
         ],
         "types" : [ "locality", "political", "geocode" ]
      },
      {
         "description" : "Victoria, Texas, États-Unis",
         "id" : "003e8789b133eaa54fe0e7fdde07944c4849c1b5",
         "matched_substrings" : [
            {
               "length" : 4,
               "offset" : 0
            }
         ],
         "place_id" : "ChIJO6wtLttmQoYRfSZjb1YN4u4",
         "reference" : "CkQ0AAAAe5BKUCM9H-Suk97BoGhsAUW_VpiVixc2d8uHACVaXb38rnXBWOh5_1KdDwszS9jfpxFTafFYdLY-D84LP6qIERIQek5sf-IT9zA35kIvOg4e5xoUWlCiasVZSRMV_xB0tVkDkZI3MjU",
         "structured_formatting" : {
            "main_text" : "Victoria",
            "main_text_matched_substrings" : [
               {
                  "length" : 4,
                  "offset" : 0
               }
            ],
            "secondary_text" : "Texas, États-Unis"
         },
         "terms" : [
            {
               "offset" : 0,
               "value" : "Victoria"
            },
            {
               "offset" : 10,
               "value" : "Texas"
            },
            {
               "offset" : 17,
               "value" : "États-Unis"
            }
         ],
         "types" : [ "locality", "political", "geocode" ]
      },
      {
         "description" : "Victoria, BC, Canada",
         "id" : "d5892cffd777f0252b94ab2651fea7123d2aa34a",
         "matched_substrings" : [
            {
               "length" : 4,
               "offset" : 0
            }
         ],
         "place_id" : "ChIJcWGw3Ytzj1QR7Ui7HnTz6Dg",
         "reference" : "CjQsAAAA4FjDPhS7RJ2FpEFi_uTqTQ4iC6YcK7wfSL6mCvg63lvXOY9ejzYJ_sr1FWSU4uFSEhB6v1BkHaKOBfEHj61rXZ5AGhRGzsjD-XetsSDQoT7jMrVIpwDrUw",
         "structured_formatting" : {
            "main_text" : "Victoria",
            "main_text_matched_substrings" : [
               {
                  "length" : 4,
                  "offset" : 0
               }
            ],
            "secondary_text" : "BC, Canada"
         },
         "terms" : [
            {
               "offset" : 0,
               "value" : "Victoria"
            },
            {
               "offset" : 10,
               "value" : "BC"
            },
            {
               "offset" : 14,
               "value" : "Canada"
            }
         ],
         "types" : [ "locality", "political", "geocode" ]
      },
      {
         "description" : "Victory Avenue, Dallas, Texas, États-Unis",
         "id" : "842c2a0035b20f27b880c37f53206bb0757017f1",
         "matched_substrings" : [
            {
               "length" : 4,
               "offset" : 0
            }
         ],
         "place_id" : "EipWaWN0b3J5IEF2ZW51ZSwgRGFsbGFzLCBUZXhhcywgw4l0YXRzLVVuaXM",
         "reference" : "CjQuAAAA164gXBSSkFzESDHi3y5eryDDmIT7bMYLG42A0FxqM0SE_q5BpDaHmc5h1H_3pjJIEhAj_RCPNu7uT9KeaewQzUN0GhQnihCVhILl-UMlmKEgrzLeXdly1A",
         "structured_formatting" : {
            "main_text" : "Victory Avenue",
            "main_text_matched_substrings" : [
               {
                  "length" : 4,
                  "offset" : 0
               }
            ],
            "secondary_text" : "Dallas, Texas, États-Unis"
         },
         "terms" : [
            {
               "offset" : 0,
               "value" : "Victory Avenue"
            },
            {
               "offset" : 16,
               "value" : "Dallas"
            },
            {
               "offset" : 24,
               "value" : "Texas"
            },
            {
               "offset" : 31,
               "value" : "États-Unis"
            }
         ],
         "types" : [ "route", "geocode" ]
      }
   ],
   "status" : "OK"
}
     */
    public function AutocompleteResult() {
    }
}
}
