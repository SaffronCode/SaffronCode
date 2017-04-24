package otherPlatforms.postMan.model
{
	public class BodyModel
	{
		public var mode:String ;
		public var raw:String ;
		public var formdata:Vector.<FormdataModel> = new Vector.<FormdataModel>(); ;
		/**"mode": "raw",
					"raw": "{\r\n\tUserId:\"78f242e7-c6ea-4879-93c0-500032350d65\",\r\n\tVideoGroupId:1026,\r\n\tCommentText:\"من این گروه را دوست دارم\"\r\n}
					 * "formdata": [
								{
									"key": "videoGroupId",
									"value": "1026",
									"type": "text",
									"enabled": true
								}
							]"*/
		public function BodyModel()
		{
		}
	}
}