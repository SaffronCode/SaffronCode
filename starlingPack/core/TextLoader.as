/**
 * Created by mes on 24/09/2017.
 */
package starlingPack.core {
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class TextLoader {

    private var loader:URLLoader ;

    public var loadedText:String ;


    private var onLoaded:Function ;
    private var onError:Function ;

    public function TextLoader() {
        loader = new URLLoader();
        loader.addEventListener(Event.COMPLETE,xmlLoaded);
        loader.addEventListener(IOErrorEvent.IO_ERROR, urlWasWrong)
    }

    private function urlWasWrong(event:IOErrorEvent):void {
        SaffronLogger.log("*** requested url was wrong ***")
        callError();
    }

    private function xmlLoaded(event:Event):void {

        loadedText = loader.data as String ;

        if(onLoaded!=null)
        {
            if(onLoaded.length==0)
            {
                onLoaded();
            }
            else
            {
                onLoaded(loadedText);
            }
        }
    }

    private function callError():void {
        if(onError!=null)
        {
            onError();
        }
    }

    public function disopose():void
    {
        onLoaded = null ;
        onError = null ;
        try {
            loader.close();
        }catch (e){};
    }

    /**You can take the bitmap directly from an input on the onLoadedFunction or loadedBitmap variable*/
    public function load(textURL:String,onLoadedFunction:Function,onErrorFunction:Function=null):void
    {
        SaffronLogger.log("*** Load "+textURL+" on URLLoader class ***");
        onLoaded = onLoadedFunction ;
        onError = onErrorFunction ;
        loader.load(new URLRequest(textURL));
    }
}
}
