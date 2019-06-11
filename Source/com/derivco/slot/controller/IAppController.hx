package com.derivco.slot.controller;
import openfl.utils.AssetLibrary;
import openfl.events.IEventDispatcher;
interface IAppController extends IEventDispatcher {
    var library(get, never):AssetLibrary;

    function loadResources():IAppController;
    function startSpin():IAppController;
}
