package com.simple.slot.context;
import IAppModelImmutable;
import IPayTableModelImmutable;
import IReelsModelImmutable;
interface IAppContextImmutable {
    var appModelImmutable(get, never):IAppModelImmutable;
    var reelsModelImmutable(get, never):IReelsModelImmutable;
    var payTableModelImmutable(get, never):IPayTableModelImmutable;
}
