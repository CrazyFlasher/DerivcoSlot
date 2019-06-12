package com.derivco.slot.controller;
import openfl.events.IEventDispatcher;
interface IAppController extends IEventDispatcher {
    function loadResources():IAppController;
    function spin():IAppController;
    function resultsShown():IAppController;
}
