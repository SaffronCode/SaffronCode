package otherPlatforms.postMan.model
{
	public class RequestModel
	{
		/**Be care full, it can be some thing like this : 
	"protocol" : "http",
	"variable" : [],
	"host" : ["185", "184", "32", "33"],
	"query" : [{
			"value" : "0451636155",
			"key" : "codemelli",
			"equals" : true,
			"description" : ""
		}
	],
	"raw" : "http://185.184.32.33/NovinInsuranceServices/Cmn/api/Person/Policies?codemelli=0451636155",
	"path" : ["NovinInsuranceServices", "Cmn", "api", "Person", "Policies"]*/
		public var url:String = '';
		public var method:String ;
		public var header:Vector.<HeaderModel> = new Vector.<HeaderModel>();
		public var body:BodyModel = new BodyModel();
		public var description:String ;
		
		
		
		/**"
				"url": "http://185.83.208.175:8076/api/video/RegisterVideoGroupComment",
				"method": "POST",
				"header": [
					{
						"key": "Content-Type",
						"value": "application/json",
						"description": ""
					}
				],
				"body": {
					"mode": "raw",
					"raw": "{\r\n\tUserId:\"78f242e7-c6ea-4879-93c0-500032350d65\",\r\n\tVideoGroupId:1026,\r\n\tCommentText:\"من این گروه را دوست دارم\"\r\n}"
				},
				"description": ""
			}*/
		public function RequestModel()
		{
		}
	}
}