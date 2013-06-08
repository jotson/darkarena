package com.happyshiny.darkarena;

import com.happyshiny.darkarena.entities.Player;
import com.happyshiny.darkarena.entities.Zombie;
import com.happyshiny.darkarena.entities.Bullet;
import com.happyshiny.darkarena.states.GameoverState;
import com.happyshiny.util.SoundManager;
import org.flixel.FlxG;
import org.flixel.FlxGroup;

class G
{
    public static var FONT : String = "assets/fonts/ShareTech-Regular.ttf";

    public static var player : Player;

    public static var zombies : FlxGroup;
    public static var bodies : FlxGroup;
    public static var bullets : FlxGroup;
    public static var particles : FlxGroup;

    public static var zombieTimer : Float = 0;
    public static var zombieSpawnTime : Float = 5;

    public static var gunTypePistol = { strength : 1, cooldown : 0.5, burst: 1, clip: 17 };
    public static var gunTypeShotgun = { strength : 3, cooldown : 1, burst: 1, clip: 2 };
    public static var gunTypeMGBurst = { strength : 1, cooldown : 1, burst: 3, clip: 30 };
    public static var gunTypeMGAuto = { strength : 1, cooldown : 1, burst: 30, clip: 30 };
    public static var gunTypeShotgunAuto = { strength : 3, cooldown : 1, burst: 3, clip: 9 };
    public static var gun = gunTypePistol;
    public static var gunTimer : Float = 0;
    public static var gunCooldown : Float = 0;
    public static var gunBurst : Int = 0;

    public static function reset()
    {
        zombieSpawnTime = 5;
    }

    public static function update()
    {
        zombieTimer -= FlxG.elapsed;
        gunCooldown -= FlxG.elapsed;
        gunTimer -= FlxG.elapsed;

        if (zombieTimer <= 0)
        {
            zombieTimer = zombieSpawnTime;
            zombieSpawnTime -= 0.1;
            if (zombieSpawnTime < 0.5) zombieSpawnTime = 0.5;

            var z = cast(G.zombies.recycle(Zombie), Zombie);
            z.revive();
        }

        G.getInput();
        G.collide();
    }

    public static function getInput()
    {
        G.player.acceleration.y = 0;
        G.player.acceleration.x = 0;

        if (G.player.flickering) return;

        if (FlxG.keys.pressed("W")) G.player.acceleration.y = -Player.ACCELERATION;
        if (FlxG.keys.pressed("A")) G.player.acceleration.x = -Player.ACCELERATION;
        if (FlxG.keys.pressed("S")) G.player.acceleration.y = Player.ACCELERATION;
        if (FlxG.keys.pressed("D")) G.player.acceleration.x = Player.ACCELERATION;

        if (FlxG.mouse.pressed() && gunCooldown <= 0 && gunTimer <= 0)
        {
            if (gunTimer <= -0.2) gunBurst = 0;

            gunTimer = 0.1;

            gunBurst += 1;
            if (gunBurst >= gun.burst)
            {
                gunCooldown = gun.cooldown;
                gunBurst = 0;
            }

            FlxG.camera.shake(0.005, 0.08);

            var p = FlxG.mouse.getScreenPosition();
            var bullet = cast(G.bullets.recycle(Bullet), Bullet);
            bullet.revive();
            bullet.strength = gun.strength;
            bullet.x = G.player.x + G.player.width/2;
            bullet.y = G.player.y + G.player.height/2;
            bullet.fireAt(p);
        }
    }

    public static function collide()
    {
        FlxG.overlap(player, zombies,
            function(player, zombie)
            {
                var zombie : Zombie = cast(zombie, Zombie);
                G.player.hit(zombie.strength, zombie.getMidpoint());
                zombie.hit(0, player.getMidpoint());
            }
        );

        FlxG.overlap(bullets, zombies,
            function(bullet, zombie)
            {
                var bullet : Bullet = cast(bullet, Bullet);
                var zombie : Zombie = cast(zombie, Zombie);
                bullet.kill();
                zombie.hit(bullet.strength, bullet.getMidpoint());
            }
        );
    }

    public static function gameOver()
    {
        FlxG.switchState(new GameoverState());
    }
}
