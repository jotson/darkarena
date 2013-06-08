package com.happyshiny.darkarena.states;

import com.happyshiny.darkarena.entities.Bullet;
import com.happyshiny.darkarena.entities.Player;
import com.happyshiny.darkarena.entities.Zombie;
import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import nme.Lib;
import nme.ui.Mouse;
import nme.events.KeyboardEvent;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxU;

import com.happyshiny.util.SoundManager;

class GameState extends FlxState
{
    public override function create():Void
    {
        // Keyboard events
        Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

        FlxG.camera.antialiasing = true;

        G.reset();

        #if (web || desktop)
        FlxG.mouse.show();
        #end

        add(new FlxSprite(0, 0, "assets/images/floor.png"));

        // var t = new FlxText(0, 50, FlxG.width, "GameState");
        // t.setFormat(G.FONT, 30, 0xffffffff, "center");
        // add(t);

        G.enemies = new FlxGroup();
        G.bullets = new FlxGroup();
        G.particles = new FlxGroup();

        add(G.enemies);
        add(G.bullets);
        add(G.particles);

        // Add player
        G.player = new Player(FlxG.width/2, FlxG.height/2);
        add(G.player);

        // SoundManager.playMusic("music");
    }
    
    public function onKeyUp(e : KeyboardEvent):Void
    {
        // Space bar
        if (e.keyCode == 32)
        {
            
        }

        // Escape key (also Android back button)
        if (e.keyCode == 27)
        {
            FlxG.switchState(new MenuState());
        }
    }

    public override function destroy():Void
    {
        Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);

        super.destroy();
    }

    public override function update():Void
    {
        super.update();

        G.update();
    }   
}
