package com.happyshiny.darkarena;

import nme.Lib;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.display.Sprite;
import nme.events.Event;
import nme.display.FPS;
import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.system.FlxDebugger;
import org.flixel.FlxG;
import org.flixel.FlxAssets;

import com.happyshiny.darkarena.states.MenuState;
import com.happyshiny.util.SoundManager;

class Main extends Sprite
{
    public function new()
    {
        super();
        
        if (stage != null) 
            init();
        else 
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(?e:Event = null):Void 
    {
        if (hasEventListener(Event.ADDED_TO_STAGE))
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        initialize();

        addChild(new Game());
    }

    private function initialize():Void 
    {
        Lib.current.stage.align = StageAlign.TOP_LEFT;
        Lib.current.stage.scaleMode = StageScaleMode.SHOW_ALL;

        // Load sounds
        SoundManager.add("ricochet", "ricochet1");
        SoundManager.add("ricochet", "ricochet2");
        SoundManager.add("ricochet", "ricochet3");
        SoundManager.add("ricochet", "ricochet4");
        SoundManager.add("playerhurt", "playerhurt1");
        SoundManager.add("playerhurt", "playerhurt2");
        SoundManager.add("playerhurt", "playerhurt3");
        SoundManager.add("moan", "moan1");
        SoundManager.add("moan", "moan2");
        SoundManager.add("moan", "moan3");
        SoundManager.add("moan", "moan4");
        SoundManager.add("moan", "moan5");
        SoundManager.add("moan", "moan6");
        SoundManager.add("moan", "moan7");
        SoundManager.add("moan", "moan8");
        SoundManager.add("footsteps", "footsteps1");
        SoundManager.add("footsteps", "footsteps2");
        SoundManager.add("footsteps", "footsteps3");
        SoundManager.add("footsteps", "footsteps4");
        SoundManager.add("footsteps", "footsteps5");
        SoundManager.add("footsteps", "footsteps6");
        SoundManager.add("footsteps", "footsteps7");
        SoundManager.add("footsteps", "footsteps8");
        SoundManager.add("hit", "hit1");
        SoundManager.add("hit", "hit2");
        SoundManager.add("hit", "hit3");
        SoundManager.add("hit", "hit4");
        SoundManager.add("gunpickup", "gunpickup1");
        SoundManager.add("gunclick", "gunclick1");
        SoundManager.add("gunreload", "gunreload1");
        SoundManager.add("gunoutofammo", "gunoutofammo1");
        SoundManager.add("autoshotgun", "autoshotgun");
        SoundManager.add("matchstrike", "matchstrike");
        SoundManager.add("heartbeat", "heartbeat");
        SoundManager.add("deathscream", "deathscream");
        SoundManager.add("zombiedeath", "zombiedeath");
    }

    public static function main()
    {
        Lib.current.addChild(new Main());
    }
}

class Game extends FlxGame
{   
    public function new()
    {
        var stageWidth:Int = Lib.current.stage.stageWidth;
        var stageHeight:Int = Lib.current.stage.stageHeight;
        var ratioX:Float = stageWidth / 800;
        var ratioY:Float = stageHeight / 500;
        var ratio:Float = Math.min(ratioX, ratioY);
        var cameraWidth = Math.ceil(stageWidth / ratio);
        var cameraHeight = Math.ceil(stageHeight / ratio);
        var gameFPS = 30;
        var flashFPS = 30;

        super(cameraWidth, cameraHeight, MenuState, ratio, gameFPS, flashFPS);
    }
}
