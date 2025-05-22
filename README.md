# Godot Game
 experimenting with godot

## Major Idea - Guck and Ball torture (GNBT)
 - waves of gore balls, physics everything (need to optimise)
 - emergent gameplay from fun physics
 - bouncing, jump pads, ice patches (skating)
 - more movement
 - points awarded based on coolness (no clamp on camera rotation)
 - balls coalescing into something, more balls, other stuff
 - open playground type levels

~PHYSICS INTERPOLATION MANUAL VS INBUILT IDK~ inbuilt now enabled, mostly fine

## Goals 
 - ~~first person character~~
 - ~~movement tech, sprinting, jumping~~
 - ~~shooting~~ -> projectile weapon after
 - experiment with graphics -> not sure if low res or high res
 - ~~basic enemy ai~~ -> make them scary
 - more interesting terrain
 - hp bar and ~~points~~
 - enemy damage to player
 - interactable level changes by player
 - smoke cigarettes
 - ~speed counter~
 - ~deathbox~
 - ~bullet trails~
 - ~shotgun spread~
 - ENVIRONMENTAL HAZARDS
 - MORE AUDIO + ambience?

Movement
 - ~lerp over with velocity~
 - chromatic aberation with velocity
 - camera shake?
 - zoom effect

Weapons
 - flamethrower
 - gravity gun
 - laser
 - ~rocket launcher~
 - sound of bullet casings landing? (awesome)
 - ~SHOTGUN IMPULSE?~
 - ~SHOTGUN MUZZLE FLASH~
 - ROCKET GLOW EMISSION
 - SHOTGUN THUNDERCLAP
 - SHOTGUN LIGHTNING ?

## Issues
 - weapon models spaz out
 - BAD optmiisation
 - many enemies = many lag
 - occlusion culling is on however enemies running individual scripts is the issue
 - enemies hit player and velocity goes bananas
 - getting trapped in pile of balls causes endlessly increasing velocity
 - ~OPTMIISE DUPLICATE SOUNDS~ mostly
 - ~OPTIMISE NODE LEAKS (lots of memory loss, nodes not getting freed)~ mostly
 - ~immortal simple explosion vfx ~twins~ (no longer twins but still immortal)~
 - ~FIX AUDIO OVERLAP ASAP~ partly fixed - limited to 4 death sounds at once
 - ~EXPLOSION IMPULSE FORCE DEPENDS ON WORLD SPACE COORDINATES?????~
 - when rocket spawns it goes to the right then gets teleported
 - blood orb simply not getting moved anymore

guck cube
 - spit green projectiles
 - ~movement (jumping? sliding? rolling?)~

inverted color text?
https://godotforums.org/d/23079-inverted-blend-on-text/6

amazing skybox: https://www.youtube.com/watch?v=bR0v-yoZYZA
