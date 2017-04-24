package otherPlatforms.postMan.model
{
	public class RequestModel
	{
		public var url:String ;
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