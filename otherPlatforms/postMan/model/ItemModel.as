package otherPlatforms.postMan.model
{
	import mx.events.Request;

	public class ItemModel
	{
		public var name:String ;
		public var request:RequestModel = new RequestModel();
		public var response:Vector.<ResponseModel> = new Vector.<ResponseModel>() ;
		/**{
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
			"response": [
				{
					"id": "60d15691-2609-444e-bc54-ca066052f958",
					"name": "RespondModel",
					"originalRequest": {
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
					},
					"status": "OK",
					"code": 200,
					"_postman_previewlanguage": "json",
					"_postman_previewtype": "text",
					"header": [
						{
							"name": "Cache-Control",
							"key": "Cache-Control",
							"value": "no-cache",
							"description": "Tells all caching mechanisms from server to client whether they may cache this object. It is measured in seconds"
						},
						{
							"name": "Content-Length",
							"key": "Content-Length",
							"value": "224",
							"description": "The length of the response body in octets (8-bit bytes)"
						},
						{
							"name": "Content-Type",
							"key": "Content-Type",
							"value": "application/json; charset=utf-8",
							"description": "The mime type of this content"
						},
						{
							"name": "Date",
							"key": "Date",
							"value": "Sun, 23 Apr 2017 12:04:35 GMT",
							"description": "The date and time that the message was sent"
						},
						{
							"name": "Expires",
							"key": "Expires",
							"value": "-1",
							"description": "Gives the date/time after which the response is considered stale"
						},
						{
							"name": "Pragma",
							"key": "Pragma",
							"value": "no-cache",
							"description": "Implementation-specific headers that may have various effects anywhere along the request-response chain."
						},
						{
							"name": "Server",
							"key": "Server",
							"value": "Microsoft-IIS/8.5",
							"description": "A name for the server"
						},
						{
							"name": "X-AspNet-Version",
							"key": "X-AspNet-Version",
							"value": "4.0.30319",
							"description": "Custom header"
						},
						{
							"name": "X-Powered-By",
							"key": "X-Powered-By",
							"value": "ASP.NET",
							"description": "Specifies the technology (ASP.NET, PHP, JBoss, e.g.) supporting the web application (version details are often in X-Runtime, X-Version, or X-AspNet-Version)"
						}
					],
					"cookie": [],
					"responseTime": 3413,
					"body": "[{\"Id\":2,\"UserId\":\"78f242e7-c6ea-4879-93c0-500032350d65\",\"VideoGroupId\":1026,\"RegDate\":\"2017-04-23T16:05:16.197\",\"CommentText\":\"من این گروه را دوست دارم\",\"IsConfirmed\":true,\"Users\":null,\"VideoGroup\":null}]"
				}
			]
		}*/
		public function ItemModel()
		{
		}
	}
}