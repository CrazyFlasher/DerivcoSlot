package com.simple.slot.context;
import IPayTableModel;
import IAppModel;
import IReelsModel;
interface IAppContext extends IAppContextImmutable {
    var appModel(get, never):IAppModel;
    var reelsModel(get, never):IReelsModel;
    var payTableModel(get, never):IPayTableModel;
}
