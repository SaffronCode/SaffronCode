package otherPlatforms.postMan.model
{
	public class PostManExportModel
	{
		public var variables:Array = [] ;
		public var info:InfoModel = new InfoModel();
		public var item:Vector.<ItemModel> = new Vector.<ItemModel>();
		/**{
	"variables": [],
	"info": {
		"name": "Panjereh-video share",
		"_postman_id": "7c7d2635-c872-ef3e-fe82-4fd254bbd474",
		"description": "",
		"schema": "https://schema.getpostman.com/json/collection/v2.0.0/collection.json"
	},
	"item": [
		{
			"name": "RegisterVideoGroupComment",
			"request": {
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
			},
			"response": []
		},
		{
			"name": "GetVideoGroupComments",
			"request": {
				"url": "http://185.83.208.175:8076/api/Video/GetVideoGroupComments?videoGroupId=1026",
				"method": "GET",
				"header": [
					{
						"key": "Content-Type",
						"value": "application/json",
						"description": ""
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
				},
				"description": ""
			},
			"response": []
		}
	]
}*/
		public function PostManExportModel()
		{
		}
	}
}