diff --git a/enemy.lua b/enemy.lua
index 8766234..f179e7d 100644
--- a/enemy.lua
+++ b/enemy.lua
@@ -1,16 +1,16 @@
-local M = {}
-
 enemies = {}
 
 function spawnEnemy(x, y)
     local enemy = world:newRectangleCollider(x, y, 70, 90, {collision_class = "Danger"})
     enemy.direction = 1
     enemy.speed = 200
+    enemy.animation = animations.enemy
     table.insert(enemies, enemy)
 end
 
 function updateEnemies(dt)
     for i,e in ipairs(enemies) do
+        e.animation:update(dt)
         local ex,ey = e:getPosition()
 
         local colliders = world:queryRectangleArea(ex + (40 * e.direction), ey + 40, 10, 10, {'Platform'})
@@ -22,4 +22,9 @@ function updateEnemies(dt)
     end
 end 
 
-return M
\ No newline at end of file
+function drawEnemies()
+    for i,e in ipairs(enemies) do
+        local ex, ey = e:getPosition()
+        e.animation:draw(sprites.enemySheet, ex, ey, nil, e.direction, 1, 50, 65) 
+    end
+end
\ No newline at end of file
diff --git a/libraries/hump b/libraries/hump
--- a/libraries/hump
+++ b/libraries/hump
@@ -1 +1 @@
-Subproject commit 08937cc0ecf72d1a964a8de6cd552c5e136bf0d4
+Subproject commit 08937cc0ecf72d1a964a8de6cd552c5e136bf0d4-dirty
diff --git a/main.lua b/main.lua
index e15af4b..1e0fc5a 100644
--- a/main.lua
+++ b/main.lua
@@ -9,13 +9,16 @@ function love.load()
 
     sprites = {}
     sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png')
+    sprites.enemySheet = love.graphics.newImage('sprites/enemySheet.png')
 
     local grid = anim8.newGrid(614, 564, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())
+    local enemyGrid = anim8.newGrid(100, 79, sprites.enemySheet:getWidth(), sprites.enemySheet:getHeight())
 
     animations = {}
     animations.idle = anim8.newAnimation(grid('1-15',1), 0.05)
     animations.jump = anim8.newAnimation(grid('1-7',2), 0.05)
     animations.run = anim8.newAnimation(grid('1-15',3), 0.05)
+    animations.enemy = anim8.newAnimation(enemyGrid('1-2',1), 0.03)
 
     wf = require 'libraries/windfield/windfield'
     world = wf.newWorld(0, 800, false)
@@ -35,8 +38,6 @@ function love.load()
     platforms = {}
 
     loadMap()
-
-    spawnEnemy(960, 320)
 end
 
 function love.update(dt)
@@ -54,6 +55,7 @@ function love.draw()
         gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
         world:draw()
         drawPlayer()
+        drawEnemies()
     cam:detach()
 end
 
@@ -82,7 +84,10 @@ end
 
 function loadMap()
     gameMap = sti("maps/level1.lua")
-    for i, obj in pairs(gameMap.layers["Object Layer 1"].objects) do
-        spawnPlatform(obj.x, obj.y, obj.width, obj.height)
+    for i, obj in pairs(gameMap.layers["Platform"].objects) do
+        --spawnPlatform(obj.x, obj.y, obj.width, obj.height)
+    end
+    for i, obj in pairs(gameMap.layers["Object Layer 2"].objects) do
+        spawnEnemy(obj.x, obj.y)
     end
 end
\ No newline at end of file
diff --git a/maps/level1..tmx b/maps/level1..tmx
index b1b9ede..abf30e8 100644
--- a/maps/level1..tmx
+++ b/maps/level1..tmx
@@ -1,5 +1,5 @@
 <?xml version="1.0" encoding="UTF-8"?>
-<map version="1.5" tiledversion="1.7.0" orientation="orthogonal" renderorder="right-down" width="40" height="12" tilewidth="64" tileheight="64" infinite="0" nextlayerid="2" nextobjectid="1">
+<map version="1.5" tiledversion="1.7.0" orientation="orthogonal" renderorder="right-down" width="40" height="12" tilewidth="64" tileheight="64" infinite="0" nextlayerid="4" nextobjectid="9">
  <editorsettings>
   <export target="level1..tmx" format="tmx"/>
  </editorsettings>
@@ -13,13 +13,15 @@
 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
-0,0,0,1,2,2,2,2,2,2,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
-0,0,0,4,5,5,5,5,5,5,5,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,8,9,
-0,0,0,4,5,5,5,5,5,5,5,6,0,0,0,0,0,0,0,0,0,0,0,1,2,2,2,2,2,2,2,2,2,2,2,3,0,0,0,0,
-0,0,0,4,5,5,5,5,5,5,5,6,0,0,7,8,8,8,8,8,9,0,0,4,5,5,5,5,5,5,5,5,5,5,5,6,0,0,0,0,
-0,0,0,4,5,5,5,5,5,5,5,6,0,0,0,0,0,0,0,0,0,0,0,4,5,5,5,5,5,5,5,5,5,5,5,6,0,0,0,0,
-0,0,0,4,5,5,5,5,5,5,5,6,0,0,0,0,0,0,0,0,0,0,0,4,5,5,5,5,5,5,5,5,5,5,5,6,0,0,0,0,
-0,0,0,4,5,5,5,5,5,5,5,6,0,0,0,0,0,0,0,0,0,0,0,4,5,5,5,5,5,5,5,5,5,5,5,6,0,0,0,0
+0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
+0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
+0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
+0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
+0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
+0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
+0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 </data>
  </layer>
+ <objectgroup id="2" name="Object Layer 1"/>
+ <objectgroup id="3" name="Object Layer 2"/>
 </map>
diff --git a/maps/level1.lua b/maps/level1.lua
index 63d9aa8..b8a75ac 100644
--- a/maps/level1.lua
+++ b/maps/level1.lua
@@ -8,8 +8,8 @@ return {
   height = 12,
   tilewidth = 64,
   tileheight = 64,
-  nextlayerid = 4,
-  nextobjectid = 5,
+  nextlayerid = 6,
+  nextobjectid = 11,
   properties = {},
   tilesets = {
     {
@@ -75,7 +75,7 @@ return {
       type = "objectgroup",
       draworder = "topdown",
       id = 3,
-      name = "Object Layer 1",
+      name = "Platform",
       visible = true,
       opacity = 1,
       offsetx = 0,
@@ -84,19 +84,6 @@ return {
       parallaxy = 1,
       properties = {},
       objects = {
-        {
-          id = 1,
-          name = "",
-          type = "",
-          shape = "rectangle",
-          x = 192,
-          y = 320,
-          width = 576,
-          height = 448,
-          rotation = 0,
-          visible = true,
-          properties = {}
-        },
         {
           id = 2,
           name = "",
@@ -135,6 +122,60 @@ return {
           rotation = 0,
           visible = true,
           properties = {}
+        },
+        {
+          id = 6,
+          name = "",
+          type = "",
+          shape = "rectangle",
+          x = -640,
+          y = 768,
+          width = 0,
+          height = 0,
+          rotation = 0,
+          visible = true,
+          properties = {}
+        }
+      }
+    },
+    {
+      type = "objectgroup",
+      draworder = "topdown",
+      id = 5,
+      name = "Object Layer 2",
+      visible = true,
+      opacity = 1,
+      offsetx = 0,
+      offsety = 0,
+      parallaxx = 1,
+      parallaxy = 1,
+      properties = {},
+      objects = {
+        {
+          id = 7,
+          name = "",
+          type = "",
+          shape = "rectangle",
+          x = 1088,
+          y = 448,
+          width = 64,
+          height = 64,
+          rotation = 0,
+          visible = true,
+          properties = {}
+        },
+        {
+          id = 9,
+          name = "",
+          type = "",
+          shape = "rectangle",
+          x = 1728,
+          y = 384,
+          width = 64,
+          height = 64,
+          rotation = 0,
+          visible = true,
+          properties = {}
         }
       }
     }
