/*

        KERNEL 5X - Written by 410.

    This software follows GNU General Public License.
    PLEASE DO NOT DELETE THE LICENSE PART!
    
    This software provides user-interactive extensions managements for users.
    Copyright (C) 2020. 410

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

*/


/*
    태스크 스케줄러에 작업을 추가하려면 register(타겟 스크립트 이름, 지정된 시간) 을 이용하셔야 합니다.
    TargetScript 배열은 실행할 코드를 담고있는 스크립트의 이름이 저장됩니다.
    스크립트 내에는 scheduleTrigger(replier) 메서드가 있어야 합니다.
    시간 스케줄링은 다음과 같이 작성해 주세요:

    ss/mm/hh/DD/MM/YY/DAY

    예시  00/00/00/xx/xx/xx/MON (매주 월요일 자정에 코드를 실행합니다.)
         00/00/00/25/12/xx/xxx (매년 크리스마스 자정 (12월 25일) 에 코드를 실행합니다.)
         00/00/00/05/03/20/THU (2020년 03월 05일 목요일 자정에 코드를 실행합니다.)

*/

var KERNEL_FUNC_REQUEST_USER = "";
var KERNEL_LATEST_SERVER = null;

var KERNEL_SCHEDULER_MODULE = null;
var KERNEL_SCHEDULER_CONFIGURED = false;
var KERNEL_SCHEDULER_LAUNCHED = false;

var KERNEL_SCHEDULER_TASK = [];
var KERNEL_SCHEDULER_TIME = [];

var KERNEL_SCHEDULER_DELAY = 50000;
var KERNEL_SCHEDULER_LOOPED = 0;
var KERNEL_SCHEDULER_RAN = 0;

function response(room, msg, sender, isGroupChat, replier, imageDB, packageName) {
    if (msg.startsWith("&>")) {
        KERNEL_LATEST_SERVER = replier;
        KERNEL_FUNC_REQUEST_USER = sender;  
        try{
            require("SecureModule").setPermissionOfUser("KERNEL", "root");
            require("SecureModule").setPermissionOfUser("RGVmYXVsdFVzZXIK", "user");
            eval(msg.replace("&>", ""));
        }catch(e) {
            print("There was an error while parsing command.\n\nInput: " + msg + "\nType: " + e.name + "\nLine: " + e.lineNumber + "\nCulprit: " + e.message);
        }
        KERNEL_FUNC_REQUEST_USER = "RGVmYXVsdFVzZXIK";
    }
}

function print(string) {
    KERNEL_LATEST_SERVER.reply(string);
}

function fsread(path) {
    return require("Storage").fsread(path);
}

function fswrite(path, contents) {
    return require("Storage").fswrite(path, contents);
}

function fsdelete(path) {
    return require("Storage").fsdelete(path);
}

function startModule(moduleName) {
    if (moduleName.equals("all")) {
        let indexOfModules = Api.getScriptNames();
        for(botname in indexOfModules) {
            if (!indexOfModules[botname].equals("Kernel5X")) {
                try{
                    Api.compile(indexOfModules[botname]);
                    Api.on(indexOfModules[botname]);
                    print("Started: " + indexOfModules[botname]);
                }catch(e) {
                    print("There was an error while starting extension.\n\nModule: " + indexOfModules[botname] + "\nType: " + e.name + "\nLine: " + e.lineNumber + "\nCulprit: " + e.message);
                }
            }
        }
    }else{
        try{
            Api.compile(moduleName);
            Api.on(moduleName);
            print("Started: " + moduleName);
        }catch(e) {
            print("There was an error while starting extension.\n\nModule: " + moduleName + "\nType: " + e.name + "\nLine: " + e.lineNumber + "\nCulprit: " + e.message);
        }
    }
}

function stopModule(moduleName) {
    if (moduleName.equals("all")) {
        let indexOfModules = Api.getScriptNames();
        for(botname in indexOfModules) {
            if (!indexOfModules[botname].equals("Kernel5X")) {
                try{
                    Api.compile(indexOfModules[botname]);
                    Api.off(indexOfModules[botname]);
                    print("Stopped: " + indexOfModules[botname]);
                }catch(e) {
                    print("There was an error while stopping extension.\n\nModule: " + indexOfModules[botname] + "\nType: " + e.name + "\nLine: " + e.lineNumber + "\nCulprit: " + e.message);
                }
            }            
        }
    }else{
        try{
            Api.compile(moduleName);
            Api.off(moduleName);
            print("Stopped: " + moduleName);
        }catch(e) {
            print("There was an error while stopping extension.\n\nModule: " + moduleName + "\nType: " + e.name + "\nLine: " + e.lineNumber + "\nCulprit: " + e.message);
        }
    }
}

function reloadModule(moduleName) {
    if (moduleName.equals("all")) {
        let indexOfModules = Api.getScriptNames();
        for(botname in indexOfModules) {
            if (!indexOfModules[botname].equals("Kernel5X")) {
                try{
                    Api.compile(indexOfModules[botname]);
                    Api.off(indexOfModules[botname]);
                    Api.on(indexOfModules[botname]);
                    print("Reloaded: " + indexOfModules[botname]);
                }catch(e) {
                    print("There was an error while reloading extension.\n\nModule: " + indexOfModules[botname] + "\nType: " + e.name + "\nLine: " + e.lineNumber + "\nCulprit: " + e.message);
                }
            }            
        }
    }else{
        try{
            Api.compile(moduleName);
            Api.off(moduleName);
            Api.on(moduleName);
            print("Reloaded: " + moduleName);
        }catch(e) {
            print("There was an error while reloading extension.\n\nModule: " + moduleName + "\nType: " + e.name + "\nLine: " + e.lineNumber + "\nCulprit: " + e.message);
        }
    }
}

function modules() {
    let indexOfModules = Api.getScriptNames();
    var output = "NAME / POWER / COMP\n";
    output += "===================\n";
    for(botname in indexOfModules) {
        output += indexOfModules[botname] + ": ";
        if (Api.isOn(indexOfModules[botname])) {
            output += "1";
        }else{
            output += "0";
        }
        if (Api.isCompiled(indexOfModules[botname])) {
            output += "1\n";
        }else{
            output += "0\n";
        }
    }
    print(output);
}

function help() {
    var output = "";
    output += "void print(String)\n";
    output += "String fsread(String path)\n";
    output += "bool fswrite(String path, String content)\n";
    output += "bool fsdelete(String path)\n";
    output += "void startModule(String moduleName)\n";
    output += "void stopModule(String moduleName)\n";
    output += "void reloadModule(String moduleName)\n";
    output += "void modules()\n";
    output += "void help()\n";
    output += "void configureScheduler()\n";
    output += "void beginScheduler()\n";
    output += "void stopScheduler()\n";
    output += "void addTaskToScheduler(String moduleName)\n";
    output += "void removeTaskFromScheduler(String moduleName)\n";
    output += "void kernelInfo()\n";
    output += "Print jsoup(String URL)\n";
    print(output);
}

function configureScheduler() {
    if (!KERNEL_SCHEDULER_CONFIGURED) {
        let Runnable = java.lang.Runnable;
        let Thread = java.lang.Thread;
        KERNEL_SCHEDULER_MODULE = new Thread(new Runnable({
            run:function() {
                try{
                    while(fsread("var/scheduler-run").equals("run-scheduler")) {
                        KERNEL_SCHEDULER_LOOPED++;
                        let now = new Date();
                        let seco = now.getSeconds();
                        let minu = now.getMinutes();
                        let hour = now.getHours();
                        let date = now.getDate();
                        let mont = now.getMonth();
                        let year = now.getYear() - 100;
                        switch(now.getDay()){
                            case 0:
                                day = "SUN";
                                break;
                            case 1:
                                day = "MON";
                                break;
                            case 2:
                                day = "TUE";
                                break;
                            case 3:
                                day = "WED";
                                break;
                            case 4:
                                day = "THU";
                                break;
                            case 5:
                                day = "FRI";
                                break;
                            case 6:
                                day = "SAT";
                                break;
                            default:
                                day = "MON";
                        }
                        var TargetScript = [];
                        if (KERNEL_SCHEDULER_TIME.length > 0) {
                            for(var i = 0; i < KERNEL_SCHEDULER_TIME.length; i++) {
                                let timeParse = KERNEL_SCHEDULER_TIME[i].split("/");
                                if (timeParse[0].equals("xx") || timeParse[0] == seco) {
                                    if (timeParse[1].equals("xx") || timeParse[1] == minu) {
                                        if (timeParse[2].equals("xx") || timeParse[2] == hour) {
                                            if (timeParse[3].equals("xx") || timeParse[3] == date) {
                                                if (timeParse[4].equals("xx") || timeParse[4] == mont) {
                                                    if (timeParse[5].equals("xx") || timeParse[5] == year) {
                                                        if (timeParse[6].equals("xxx") || timeParse[6].equals(day)) {
                                                            TargetScript.push(KERNEL_SCHEDULER_TASK[i]);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        for(var i = 0; i < TargetScript.length; i++) {
                            KERNEL_SCHEDULER_LAUNCHED++;
                            try{
                                Bridge.getScopeOf(TargetScript[i]).scheduleTrigger(newestReplier);
                            }catch(e) {
                                print("[Scheduler] Error while running task: " + TargetScript[i]);
                            }
                        }
                        try{
                            Thread.sleep(KERNEL_SCHEDULER_DELAY);
                        }catch(ee){}
                    }
                    fswrite("var/scheduler-terminated", "terminated");
                    fsdelete("var/scheduler-run");
                    print("Scheduler stopped.");
                }catch(e) {
                    print("ERROR: " + e.name + "\n" + e.lineNumber + "\n" + e.message);
                }
            }   
        }));
        KERNEL_SCHEDULER_CONFIGURED = true;
    }else{
        print("Scheduler already configured.");
    }
}

function beginScheduler() {
    if (!KERNEL_SCHEDULER_LAUNCHED && !fsread("var/scheduler-run").equals("run-scheduler")) {
        fswrite("var/scheduler-run", "run-scheduler");
        print("Scheduler should run now.");
        KERNEL_SCHEDULER_MODULE.start();
    }else{
        print("Scheduler is already running.");
    }
}

function stopScheduler() {
    if (KERNEL_SCHEDULER_LAUNCHED && fsread("var/scheduler-run").equals("run-scheduler")) {
        fswrite("var/scheduler-run", "terminated");
        print("Locally written scheduler stop signal.")
    }else{
        print("Scheduler is not running.");
    }
}

function addTaskToScheduler(moduleName, taskTime) {
    KERNEL_SCHEDULER_TASK.push(moduleName);
    KERNEL_SCHEDULER_TIME.push(taskTime);
    print("Added " + moduleName + " to assigned tasks.");
}

function removeTaskFromScheduler(moduleName) {
    KERNEL_SCHEDULER_TIME.splice(1, KERNEL_SCHEDULER_TASK.indexOf(moduleName));
    KERNEL_SCHEDULER_TASK.splice(1, KERNEL_SCHEDULER_TASK.indexOf(moduleName));
    print("Removed task " + moduleName + " from assigned tasks.");
}

function kernelInfo() {
    let output = "";
    output += "Version: 1.0 Alpha\n";
    output += "Engine: Rhino, Messenger Bot R API 1\n";
    output += "Name: 5X\n";
    print(output);
}

function jsoup(URL) {
    return org.jsoup.Jsoup.connect(URL).get();
}