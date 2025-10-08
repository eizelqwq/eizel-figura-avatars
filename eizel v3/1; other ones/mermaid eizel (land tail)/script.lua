-- Auto generated script file --

--hide vanilla model
vanilla_model.PLAYER:setVisible(false)

--hide vanilla armor model
vanilla_model.ARMOR:setVisible(false)

--hide vanilla cape model
vanilla_model.CAPE:setVisible(false)

--hide vanilla elytra model
vanilla_model.ELYTRA:setVisible(false)

local anims = require("JimmyAnims")
anims(animations.mermaid_eizel)

local GSBlend = require("GSAnimBlend")


animations.mermaid_eizel.water:priority(1)
animations.mermaid_eizel.waterup:priority(2)
animations.mermaid_eizel.waterdown:priority(3)
animations.mermaid_eizel.waterwalk:priority(4)
animations.mermaid_eizel.waterwalkback:priority(5)
animations.mermaid_eizel.swim:priority(6)


