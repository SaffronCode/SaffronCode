package otherPlatforms.postMan
{
	import com.mteamapp.JSONParser;
	
	import contents.TextFile;
	
	import flash.filesystem.File;
	
	import otherPlatforms.postMan.model.BodyModel;
	import otherPlatforms.postMan.model.ItemModel;
	import otherPlatforms.postMan.model.PostManExportModel;

	public class PostManToASFiles
	{
		private static const classFileModel:String = 'package\n{\n\tpublic class [ClassName]\n\t{\n[variables]\n\t\t\n\t\tpublic function [ClassName]()\n\t\t{\n\t\t}\n\t}\n}'

		private static var serviceGenerator:ServiceGenerator;
		
		private static var saveToFolderForServices:File,saveToFolderForTypes:File;
		
		public static function saveClasses(SaveToFolderForServices:File, service:String,SaveToFolderForTypes:File):void
		{
			saveToFolderForServices = SaveToFolderForServices ;
			saveToFolderForTypes = SaveToFolderForTypes ;
			
			if(saveToFolderForServices.exists)
			{
				saveToFolderForServices.deleteDirectory(true);
			}
			if(saveToFolderForTypes.exists)
			{
				saveToFolderForTypes.deleteDirectory(true);
			}
			
			var serviceData:PostManExportModel = new PostManExportModel();
			JSONParser.parse(service,serviceData);
			trace("serviceData : "+serviceData.item.length);
			serviceGenerator = new ServiceGenerator();
			/*for(var i:uint = 0 ; i<serviceData.item.length ; i++)
			{
				createRequestFiles(serviceData.item[i])
			}*/
			
			searchForAllItems(serviceData.item,saveToFolderForServices);
		}
		
		private static function searchForAllItems(rootItems:Vector.<ItemModel>,mySaveToFolderForServices:File):void
		{
			for(var i:int = 0 ; i<rootItems.length ; i++)
			{
				if(rootItems[i].request.url!=null && rootItems[i].request.url!='')
				{
					mySaveToFolderForServices.createDirectory();
					trace(">>test : "+rootItems[i].request.url);
					createRequestFiles(rootItems[i],mySaveToFolderForServices);
				}
				searchForAllItems(rootItems[i].item,mySaveToFolderForServices.resolvePath(rootItems[i].name));
			}
		}
		
		private static function createRequestFiles(itemModel:ItemModel,mySaveToFolderForServices:File):void
		{
			serviceGenerator.ServiceName = correctNames(itemModel.name) ;
			mySaveToFolderForServices = mySaveToFolderForServices.resolvePath(serviceGenerator.ServiceName);
			var mySaveToFolderForTypes:File = saveToFolderForTypes.resolvePath(serviceGenerator.ServiceName);
			serviceGenerator.IsGet = itemModel.request.method=="GET" ;
			serviceGenerator.myWebServiceLocation = URLCatcher(itemModel.request.url) ;
			serviceGenerator.description = URLCatcher(itemModel.request.description) ;
			
			serviceGenerator.inputObject = bodyToObject(itemModel.request.body);
			serviceGenerator.inputObjectClassName = createClassName(serviceGenerator.ServiceName,'Request');
			
			if(itemModel.response.length>0 && itemModel.response[0].body!=null)
			{
				trace("***** : "+itemModel.response[itemModel.response.length-1].body);
				trace("******** : "+JSONCorrector(itemModel.response[itemModel.response.length-1].body));
				serviceGenerator.outPutObject = JSON.parse(JSONCorrector(itemModel.response[itemModel.response.length-1].body)) ;
				serviceGenerator.outPutObjectClassName = createClassName(serviceGenerator.ServiceName,'Respond');
				trace("serviceGenerator.outPutObject : "+serviceGenerator.outPutObject);
				if(serviceGenerator.outPutObject is Array || serviceGenerator.outPutObject is Vector.<*>)
				{
					trace("It was vector");
					SaveJSONtoAs(serviceGenerator.outPutObject[0],mySaveToFolderForTypes,serviceGenerator.outPutObjectClassName);
				}
				else
				{
					trace("It was Object");
					SaveJSONtoAs(serviceGenerator.outPutObject,mySaveToFolderForTypes,serviceGenerator.outPutObjectClassName);
				}
			}
			else
			{
				serviceGenerator.outPutObject = null ;
				serviceGenerator.outPutObjectClassName = '' ;
			}
			
			//serviceGenerator.inPutClass = 
			if(serviceGenerator.inputObject!=null)
			{
				if(serviceGenerator.inputObject is Array)
				{
					SaveJSONtoAs(serviceGenerator.inputObject[0],mySaveToFolderForTypes,serviceGenerator.inputObjectClassName);
				}
				else
				{
					SaveJSONtoAs(serviceGenerator.inputObject,mySaveToFolderForTypes,serviceGenerator.inputObjectClassName);
				}
			}
			
			var serviceFile:File = mySaveToFolderForServices.resolvePath(serviceGenerator.ServiceName+'.as');
			if(serviceFile.exists)
			{
				WebServiceGenerator.log(serviceFile.name+" was duplicated");
			}
			TextFile.save(serviceFile,serviceGenerator.toString());
		}
		
		/**Check the url object*/
		private static function URLCatcher(url:String):String
		{
			if(url==null)
			{
				url = '' ;
			}
			if(url.indexOf('"raw"')==-1)
			{
				return url ;
			}
			else
			{
				var urlObj:Object = JSON.parse(url);
				return urlObj.raw ;
			}
		}
		
		/**The wrong names can be like this : http://185.83.208.175:821/api/Service/GetBranches*/
		private static function correctNames(name:String):String
		{
			name = name.split('/').join('');
			name = name.split('\\').join('');
			var fileName:String = name.replace(/(^.*\/|)([^\/?\(]+)([?].*$|$|\(.*$)/gi,'$2');
			var fileNameSplitted:Array = fileName.split("'").join('').split('"').join('').split(' ');
			if(fileNameSplitted.length>1)
			{
                fileName = fileNameSplitted[0] ;
                for (var i:int = 1; i < fileNameSplitted.length; i++)
				{
                    fileName += uperCaseFirstChar(fileNameSplitted[i]);
                }
            }
			return fileName ;
		}

		/**chante name to Name*/
        private static function uperCaseFirstChar(fileName:String):String
		{
			if(fileName.length>0)
			{
                return fileName.substring(0,1).toUpperCase()+fileName.substring(1);
			}
			return fileName ;
        }
		
		private static function bodyToObject(body:BodyModel):Object
		{
			var bodyObject:Object ;
			if(body.mode == "formdata")
			{
				if(body.formdata.length>0)
				{
					bodyObject = {} ;
					for(var i:int ; i<body.formdata.length ; i++)
					{
						bodyObject[body.formdata[i].key] = body.formdata[i].value ;
					}
				}
			}
			else
			{
				if(body.raw!='' && body.raw!=null)
				{
					//trace("JSON is : "+body.raw);
					var convertedJSON:String = JSONCorrector(body.raw) ;
					//trace("convertedJSON JSON is : "+convertedJSON);
					try
					{
						bodyObject = JSON.parse(convertedJSON) ;
					}
					catch(e)
					{
						trace("JSON input model was wrnog : "+JSONCorrector(body.raw));
					};
				}
			}
			return bodyObject;
		}
		
		/**This will replace dfafd:"dfds" with "dfafd":"dfds"*/
		private static function JSONCorrector(wrongJSON:String):String
		{
			trace("Current entered json is : "+wrongJSON);
			if(wrongJSON=="True")
			{
				return "true" ;
			}
			else if(wrongJSON=="False")
			{
				return 'false';
			}
			//																					↓ Remove comments
			return wrongJSON.replace(/([,\{][\s\n\r]*)([a-z]+[\s]*[\s]*):/gi,'$1"$2":').replace(/\/\*[^*]*\*\//gi,'');
		}
		
		/**This will save the json to as file<br>
		 * Waring!! each class has to have a variable with a special name*/
		public static function SaveJSONtoAs(jsonObject:Object,directory:File,rootClassName:String):File
		{
			trace("Target file directory is : "+directory.nativePath);
			trace("Create class : "+rootClassName);
			var myAsClass:String = classFileModel ;
			myAsClass = myAsClass.split("[ClassName]").join(rootClassName) ;
			
			var newClassName:String ;
			var parameters:String = '' ;
			var sortedParams:Array = [];
			for(var names:String in jsonObject)
			{
				sortedParams.push(names);
			}
			sortedParams.sort();
			trace("sortedParams : "+sortedParams);
			for(var i:int=0 ; i <sortedParams.length ; i++)
			{
				var paramName:String = sortedParams[i] ;
				parameters+='\t\t/**"'+paramName+'":"'+jsonObject[paramName]+'"*/\n' ;
				parameters+='\t\tpublic var '+paramName+':' ;
				trace(">>>>>"+paramName);
				if(jsonObject[paramName] is String)
				{
					parameters+='String ;'
				}
				else if(jsonObject[paramName] is Number)
				{
					parameters+='Number ;';
				}
				else if(jsonObject[paramName] is Boolean)
				{
					parameters+='Boolean ;';
				}
				else if(jsonObject[paramName] is Array)
				{
					trace(">>>"+paramName);
					if(jsonObject[paramName].length>0 &&
						!(jsonObject[paramName][0] is Number) &&
						!(jsonObject[paramName][0] is String) &&
						!(jsonObject[paramName][0] is Boolean))
					{
						newClassName = createClassName(rootClassName+paramName,"Model",jsonObject[paramName][0]);
						parameters+='Vector.<'+newClassName+'> = new Vector.<'+newClassName+'>()';
						SaveJSONtoAs(jsonObject[paramName][0],directory,newClassName);
					}
					else
					{
						parameters+='Array = [] ;';
					}
				}
				else if(jsonObject[paramName]==null)
				{
					parameters+='* ;';
				}
				else
				{
					//The parameter is class
					
					newClassName = createClassName(rootClassName+paramName,"Model",jsonObject[paramName]);
					parameters+=newClassName+' = new '+newClassName+'()';
					SaveJSONtoAs(jsonObject[paramName],directory,newClassName);
				}
				parameters+='\n';
			}
			myAsClass = myAsClass.split('[variables]').join(parameters);
			
			var targetFile:File = directory.resolvePath(rootClassName+'.as') ;
			if(targetFile.exists)
			{
				WebServiceGenerator.log(targetFile.name+" was duplicated");
			}
			TextFile.save(targetFile,myAsClass);
			return targetFile ;
		}
		
		/**Craetes a standard class name*/
		internal static function createClassName(objectName:String,OffsetName:String = "Model",paramList:Object=null):String
		{
			/*var paramNames:String = '';
			if(paramList!=null)
			{
				var params:Array = [];
				for(var names:String in paramList)
				{
					params.push(names.charAt(0).toUpperCase());
				}
				params.sort();
				paramNames = params.join('');
			}*/
			return objectName.charAt(0).toUpperCase()+objectName.substr(1)+OffsetName/*+paramNames*/ ;
		}
	}
}