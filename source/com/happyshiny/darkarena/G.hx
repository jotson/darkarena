package com.happyshiny.darkarena;

import com.happyshiny.darkarena.entities.Lantern;
import com.happyshiny.darkarena.entities.Player;
import com.happyshiny.darkarena.entities.Powerup;
import com.happyshiny.darkarena.entities.Zombie;
import com.happyshiny.darkarena.entities.Bullet;
import com.happyshiny.darkarena.states.GameoverState;
import com.happyshiny.util.SoundManager;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxU;

class G
{
    public static var FONT : String = "assets/fonts/ShareTech-Regular.ttf";

    public static var player : Player;

    public static var powerups : FlxGroup;
    public static var zombies : FlxGroup;
    public static var bodies : FlxGroup;
    public static var bullets : FlxGroup;
    public static var particles : FlxGroup;

    public static var zombieTimer : Float = 0;
    public static var zombieSpawnTime : Float = 5;

    public static var gunTypePistol = { strength: 1, cooldown: 0.5, burst: 1, clip: 30 };
    public static var gunTypeShotgun = { strength: 3, cooldown: 1, burst: 2, clip: 10 };
    public static var gunTypeMGBurst = { strength: 1, cooldown: 1, burst: 3, clip: 30 };
    public static var gunTypeMGAuto = { strength: 1, cooldown: 1, burst: 30, clip: 30 };
    public static var gunTypeShotgunAuto = { strength: 3, cooldown: 1, burst: 3, clip: 9 };
    public static var gunTypes = [gunTypePistol, gunTypeShotgun, gunTypeMGBurst, gunTypeMGAuto, gunTypeShotgunAuto];
    public static var gun = gunTypePistol;
    public static var gunTimers = { nextShot: 0.0, cooldown: 0.0, burst: 0, ammo: gun.clip };

    public static var powerupTimers = { timer: 0.0, lanterns: 0, ammo: 0, guns: 0, maxLanterns: 2, maxAmmo: 2, maxGuns: 2, cooldown: 15 };

    public static function reset()
    {
        zombieSpawnTime = 5;
    }

    public static function update()
    {
        zombieTimer -= FlxG.elapsed;
        gunTimers.cooldown -= FlxG.elapsed;
        gunTimers.nextShot -= FlxG.elapsed;

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

        G.addPowerup();
    }

    public static function addPowerup()
    {
        powerupTimers.timer -= FlxG.elapsed;

        if (powerupTimers.timer > 0) return;

        powerupTimers.timer = powerupTimers.cooldown;

        if (powerupTimers.lanterns < powerupTimers.maxLanterns)
        {
            var o = cast(powerups.recycle(Lantern), Powerup);
            o.revive();
        }

        if (powerupTimers.guns < powerupTimers.maxGuns)
        {
            // var o = cast(powerups.recycle(Gun), Powerup);
            // o.revive();
        }
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

        if (FlxG.mouse.pressed() && gunTimers.cooldown <= 0 && gunTimers.nextShot <= 0 && gunTimers.ammo > 0)
        {
            if (gunTimers.nextShot <= -0.2) gunTimers.burst = 0;

            gunTimers.nextShot = 0.1;

            gunTimers.burst += 1;
            if (gunTimers.burst >= gun.burst)
            {
                gunTimers.cooldown = gun.cooldown;
                gunTimers.burst = 0;
            }

            FlxG.camera.shake(0.005, 0.08);

            var p = FlxG.mouse.getScreenPosition();
            var bullet = cast(G.bullets.recycle(Bullet), Bullet);
            bullet.revive();
            bullet.strength = gun.strength;
            bullet.x = G.player.x + G.player.width/2;
            bullet.y = G.player.y + G.player.height/2;
            bullet.fireAt(p);

            gunTimers.ammo -= 1;
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

        FlxG.overlap(player, powerups,
            function(player, powerup)
            {
                switch(FlxU.getClassName(powerup, true))
                {
                    case "Lantern":
                        G.player.getLantern();
                        powerup.kill();

                    case "Gun":
                        // Switch gun, update ammo, etc
                        powerup.kill();
                }
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
