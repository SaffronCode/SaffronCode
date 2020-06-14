/**
 * Created by mes on 8/12/2017.
 */
package starlingPack.display {
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.events.StageVideoAvailabilityEvent;
import flash.filesystem.File;
import flash.media.StageVideo;

import starling.display.Quad;
import starling.display.Sprite;

import videoPlayer.myVideoPlayer;

import videoShow.VideoClass;
import videoShow.VideoEvents;

public class VideoPlayerStarlingCompatible extends Sprite {

    private static var flashStage:Stage ;

    private var w:Number,h:Number ;

    private var myVideoClass:VideoClass ;

    private var lastPlayStatus:Boolean = false ;

    /** Will dispatch whenever video is over */
    [Event(name="complete", type="flash.events.Event")]
    public var dispatcher:EventDispatcher ;

    public static function setUp(appStage:Stage):void
    {
        flashStage = appStage ;
        flashStage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY,
                onStageVideoState);
        onStageVideoState(null);
    }

    private static function onStageVideoState(event:StageVideoAvailabilityEvent):void {
        var sw:Vector.<StageVideo> = flashStage.stageVideos ;
    }

    public function VideoPlayerStarlingCompatible(Width:Number,Height:Number) {
        w = Width ;
        h = Height ;
        super();
        dispatcher = new EventDispatcher();

        var rect:Quad = new Quad(w,h,0xff0000);
        this.addChild(rect);
        this.alpha = 0 ;
        myVideoClass = new VideoClass(Width,Height);
    }

    public function loadVideo(videoTarget:String):void
    {
        SaffronLogger.log("* the video target is : "+videoTarget);
        flashStage.addChild(myVideoClass);
        myVideoClass.addEventListener(VideoEvents.VIDEO_STATUS_CHANGED, statusChanged)
        myVideoClass.loadThiwVideo(videoTarget,true,NaN,NaN,null,false);
        myVideoClass.addEventListener(MouseEvent.CLICK, dispatchClickEvent)
    }

    private function dispatchClickEvent(event:MouseEvent):void {
        dispatcher.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
    }

    private function statusChanged(event:VideoEvents):void {
        if(!myVideoClass.statusPlay() && myVideoClass.statusPlay()!=lastPlayStatus) {
            dispatcher.dispatchEvent(new Event(Event.COMPLETE));
        }
        lastPlayStatus = myVideoClass.statusPlay();
    }

    override public function set width(value:Number):void
    {
        myVideoClass.width = value ;
        super.width = value ;
    }

    override public function set height(value:Number):void
    {
        myVideoClass.height = value ;
        super.height = value ;
    }

    override public function dispose():void
    {
        myVideoClass.pause();
        flashStage.removeChild(myVideoClass);
        myVideoClass.dispose()
        super.dispose();
    }

    override public function set scale(value:Number):void
    {
        myVideoClass.scaleX = value ;
        myVideoClass.scaleY = value*.85 ;
        super.scale = value ;
    }
    override public function set x(value:Number):void
    {
        super.x = value ;
        myVideoClass.x = value ;
    }
    override public function set y(value:Number):void
    {
        super.y = value ;
        myVideoClass.y = value ;
    }
}
}
