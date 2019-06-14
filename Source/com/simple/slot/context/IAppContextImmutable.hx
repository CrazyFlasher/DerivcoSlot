package com.simple.slot.context;
import com.simple.slot.models.payTable.IPayTableModelImmutable;
import com.simple.slot.models.reels.IReelsModelImmutable;
import com.simple.slot.models.app.IAppModelImmutable;
interface IAppContextImmutable {
    var appModelImmutable(get, never):IAppModelImmutable;
    var reelsModelImmutable(get, never):IReelsModelImmutable;
    var payTableModelImmutable(get, never):IPayTableModelImmutable;
}
