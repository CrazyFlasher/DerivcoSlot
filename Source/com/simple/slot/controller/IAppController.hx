package com.simple.slot.controller;
import com.simple.slot.models.reels.FixedResultVo;
import openfl.events.IEventDispatcher;
interface IAppController extends IEventDispatcher {
    function loadResources():IAppController;
    function spin(fixedDataList:Array<FixedResultVo>):IAppController;
    function resultsShown():IAppController;
    function updateBalance(value:Int):IAppController;
    function updateSpinCost(value:Int):IAppController;
}
