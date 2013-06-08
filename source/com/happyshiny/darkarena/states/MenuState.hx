package com.happyshiny.darkarena.states;

import nme.Assets;
import nme.display.BitmapData;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import nme.Lib;
import nme.net.URLRequest;
import nme.ui.Mouse;
import nme.events.KeyboardEvent;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxU;

import com.happyshiny.util.SoundManager;
import org.flixel.tweens.FlxTween;

class MenuState extends FlxState
{
    private var flagrantdisregard : FlxText;
    private var bacongamejam : FlxText;

    public override function create():Void
    {
        // Keyboard events
        Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

        FlxG.camera.antialiasing = true;

        #if (web || desktop)
        FlxG.mouse.show();
        #end

        add(new FlxSprite(0, 0, "assets/images/floor.png"));
        var mask = new FlxSprite(FlxG.width/2, FlxG.height/2, "assets/images/darkness-mask.png");
        mask.scale.x = 20;
        mask.scale.y = 20;
        mask.x -= mask.width/2;
        mask.y -= mask.height/2;
        mask.addAnimation('default', [0], 10);
        mask.addAnimationCallback(
            function(name, frame, index)
            {
                mask.scale.x = Math.random()*4 + 20;
                mask.scale.y = mask.scale.x;
            }
        );
        mask.play('default');
        add(mask);

        var grid = FlxG.height/16;

        var t = new FlxText(0, grid * 2, FlxG.width, "Dark Arena");
        t.setFormat(G.FONT, 60, 0xff990000, "center", 0x000000, true);
        add(t);

        flagrantdisregard = new FlxText(0, grid * 4, FlxG.width, "John Watson - flagrantdisregard.com");
        flagrantdisregard.setFormat(G.FONT, 25, 0xff99cc00, "center", 0x000000, true);
        add(flagrantdisregard);

        bacongamejam = new FlxText(0, grid * 5, FlxG.width, "Created for BaconGameJam05 - bacongamejam.org");
        bacongamejam.setFormat(G.FONT, 25, 0xff99cc00, "center", 0x000000, true);
        add(bacongamejam);

        var t = new FlxText(0, grid * 6, FlxG.width, "Theme: \"Lights Out\"");
        t.setFormat(G.FONT, 25, 0xff99cc00, "center", 0x000000, true);
        add(t);

        var t = new FlxText(0, grid * 9, FlxG.width, "- WASD to move / Mouse to shoot -");
        t.setFormat(G.FONT, 25, 0xff99cc00, "center", 0x000000, true);
        add(t);

        var t = new FlxText(0, grid * 13, FlxG.width, "Press any key to start");
        t.setFormat(G.FONT, 30, 0xff990000, "center", 0x00000, true);
        FlxG.tween(t, { alpha: 0.2 }, 0.5, { type: FlxTween.PINGPONG });
        add(t);

        // SoundManager.playMusic("music");
    }
    
    public function onKeyUp(e : KeyboardEvent):Void
    {
        // Any key
        FlxG.switchState(new GameState());
    }

    public override function destroy():Void
    {
        Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);

        super.destroy();
    }

    public override function update():Void
    {
        super.update();

        if (FlxG.mouse.justPressed())
        {
            if (flagrantdisregard.overlapsPoint(FlxG.mouse.getScreenPosition()))
            {
                Lib.getURL(new URLRequest("http://flagrantdisregard.com"), "");
                return;
            }
            if (bacongamejam.overlapsPoint(FlxG.mouse.getScreenPosition()))
            {
                Lib.getURL(new URLRequest("http://bacongamejam.org"), "");
                return;
            }

            FlxG.switchState(new GameState());
        }
    }   
}
