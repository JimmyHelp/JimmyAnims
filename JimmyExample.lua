local anims = require('JimmyAnims')
anims.excluBlendTime = 4
anims.incluBlendTime = 4
anims.autoBlend = true
anims.dismiss = false
anims.addExcluAnimsController()
anims.addIncluAnimsController()
anims.addAllAnimsController()
anims(animations.BBMODEL_NAME_HERE)
