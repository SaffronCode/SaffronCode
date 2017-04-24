package otherPlatforms.postMan.model
{
	public class OriginalRequestModel
	{
		public var url:String ;
		public var method:String ;
		public var header:Vector.<HeaderModel> = new Vector.<HeaderModel>();
		public var body:BodyModel = new BodyModel();
		/**{
						"url": "http://185.83.208.175:8076/api/Video/GetVideoGroupComments?videoGroupId=1026",
						"method": "GET",
						"header": [
							{
								"key": "Content-Type",
								"value": "application/json",
								"enabled": true,
								"description": "The mime type of this content"
							}
						],
						"body": {
							"mode": "formdata",
							"formdata": [
								{
									"key": "videoGroupId",
									"value": "1026",
									"type": "text",
									"enabled": true
								}
							]
						}
					}*/
		public function OriginalRequestModel()
		{
		}
	}
}