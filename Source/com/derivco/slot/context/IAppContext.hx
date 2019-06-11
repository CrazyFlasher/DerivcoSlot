package com.derivco.slot.context;
import com.derivco.slot.models.reels.IReelsModel;
import com.derivco.slot.models.payTable.IPayTableModel;
import com.derivco.slot.models.app.IAppModel;
interface IAppContext extends IAppContextImmutable {
    var appModel(get, never):IAppModel;
    var reelsModel(get, never):IReelsModel;
    var payTableModel(get, never):IPayTableModel;
}
