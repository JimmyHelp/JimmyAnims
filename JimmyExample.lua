local anims = require('JimmyAnims')
anims.excluBlendTime = 4
anims.incluBlendTime = 4
anims.autoBlend = true
anims.dismiss = false
anims.addExcluAnims()
anims.addIncluAnims()
anims.addAllAnims()
anims(animations.BBMODEL_NAME_HERE)
--logTable(anims.animsList)
