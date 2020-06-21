var SERVER = null;

var SCHEDULE_TIME = [];
var ASSIGNED_TASK = [];
var SAVED_SESSION = [];

function response(room, msg, sender, isGroupChat, replier, imageDB, packageName) {
    SERVER = replier;
    if (msg.startsWith("/컨퍼런스 ")) {
        try{
            parse(msg.replace("/컨퍼런스 ", ""));
        }catch(e){
            print("예약 설정중 오류가 발생했습니다.\n" + "\nType: " + e.name + "\nLine: " + e.lineNumber + "\nCulprit: " + e.message);
        }
    }else if (msg.equals("/컨퍼런스")) {
        print("Parameter 가 충분하지 않습니다.\n사용법: /컨퍼런스 [날짜] [시간] [짧은 내용]\n날짜는 - 로, 시간은 : 로 구분합니다.\n예: 2020-06-13 16:20");
    }else if (msg.equals("/레지스터")) {
        if (Bridge.getScopeOf("Kernel5X").KERNEL_SCHEDULER_TASK.indexOf("MakeMeeting") < 0) {
            Bridge.getScopeOf("Kernel5X").addTaskToScheduler("MakeMeeting", "xx/xx/xx/xx/xx/xx/xxx");
            print("MakeMeeting 이 커널 예약태스크로 추가되었습니다.");
        }else{
            print("MakeMeeting 이 이미 커널 예약태스크로 등록되어있습니다.");
        }
    }
}

function parse(string) {
    let args = string.split(" ");
    let time = "";
    if (args.length < 3) {
        print("오류: Parameter 가 충분하지 않습니다.\n사용법: /컨퍼런스 [날짜] [시간] [짧은 내용]\n날짜는 - 로, 시간은 : 로 구분합니다.\n예: 2020-06-13 16:20");
        return null;
    }
    if (!args[0].includes("-")) {
        print("오류: 날짜를 인식하지 못하였습니다.");
        return null;
    }else{
        let testParse = args[0].split("-");
        if (testParse.length != 3) {
            print("오류: 날짜 형식이 바르지 않습니다: " + args[0].replace("/", "-") + "\n데이터 길이: " + testParse.length);
            return null;
        }else{
            time = args[0].split("-")[2];
            time += "/" + args[0].split("-")[1];
            time += "/" + args[0].split("-")[0];
        }
    }
    if (!args[1].includes(":")) {
        print("오류: 시간을 인식하지 못하였습니다.");
        return null;
    }else{
        testParse = args[1].split(":");
        if (testParse.length != 2) {
            print("오류: 시간 형식이 바르지 않습니다: " + args[1] + "\n데이터 길이: " + testParse.length);
            return null;
        }else{
            time = args[1].split(":")[0] + "/" + time;
            time = args[1].split(":")[1] + "/" + time;
        }
    }
    let taskMessage = "";
    for(var i = 2; i < args.length; i++) {
        taskMessage += args[i] + " "; 
    }
    SCHEDULE_TIME.push(time);
    ASSIGNED_TASK.push(taskMessage);
    SAVED_SESSION.push(SERVER);
    time = time.split("/");
    time.reverse();
    print("알림이 설정되었습니다.\n내용: " + taskMessage + "\n일시: " + time[0] + "년 " + time[1] + "월 " + time[2] + "일 " + time[3] + "시 " + time[4] + "분");
}

function scheduleTrigger(server) {
    SERVER = server;
    let now = new Date();
    let minu = now.getMinutes();
    let hour = now.getHours();
    let date = now.getDate();
    let mont = now.getMonth();
    let year = now.getYear() - 100;
    var TargetScript = [];
    var SessionDat = [];
    if (SCHEDULE_TIME.length > 0) {
        for(var i = 0; i < SCHEDULE_TIME.length; i++) {
            let timeParse = SCHEDULE_TIME[i].split("/");
            if (timeParse[0].equals("xx") || timeParse[0] == minu) {
                if (timeParse[1].equals("xx") || timeParse[1] == hour) {
                    if (timeParse[2].equals("xx") || timeParse[2] == date) {
                        if (timeParse[3].equals("xx") || Number(timeParse[3]) == mont + 1) {
                            if (timeParse[4].equals("xx") || timeParse[4] == "20" + year) {
                                TargetScript.push(ASSIGNED_TASK[i]);
                                SessionDat.push(SAVED_SESSION[i]);
                                if (!SCHEDULE_TIME[i].includes("xx")) {
                                    SCHEDULE_TIME.splice(i, 1);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    for(var i = 0; i < TargetScript.length; i++) {
        SessionDat[i].reply("::알림::\n제목: " + TargetScript[i] + "\n일시: 20" + year + "년 " + mont + "월 " + date + "일 " + hour + "시 " + minu + "분");
    }
}

function print(string) {
    SERVER.reply(string);
}