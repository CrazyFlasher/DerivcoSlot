package com.simple.slot.context;

import com.simple.slot.models.app.IAppModel;
import com.simple.slot.models.payTable.IPayTableModel;
import com.simple.slot.models.reels.IReelsModel;

interface IAppContext extends IAppContextImmutable
{
    var appModel(get, never):IAppModel;
    var reelsModel(get, never):IReelsModel;
    var payTableModel(get, never):IPayTableModel;
}
