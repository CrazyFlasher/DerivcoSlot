package com.derivco.slot.context;
import com.derivco.slot.models.payTable.IPayTableModelImmutable;
import com.derivco.slot.models.reels.IReelsModelImmutable;
import com.derivco.slot.models.app.IAppModelImmutable;
interface IAppContextImmutable {
    var appModelImmutable(get, never):IAppModelImmutable;
    var reelsModelImmutable(get, never):IReelsModelImmutable;
    var payTableModelImmutable(get, never):IPayTableModelImmutable;
}
