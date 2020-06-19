const Storage = require("./Storage.js");
const Users = require("./Users.js");

exports.setPermissionOfUser = function(userName, permissionName) {
	Users.set(userName, "permission", permissionName);
}

exports.getPermissionOfUser = function(userName) {
	if (Users.get(userName, "permission").equals("null")) {
		Users.set(userName, "permission", "user");
		return "user";
	}else{
		return Users.get(userName, "permission");
	}
}

exports.uaccess = function(functionName, userName) {
	if (Users.get(userName, "permission").equals("root") || Users.get(userName, "permission").equals("admin")) {
		return true;
	}else{
		return false;
	}
}

exports.doesEvalCommandMeetsSandboxRequirements = function(command) {
	let pathtosandbox = "security/sandbox-keywords";
	let keywords = null;
	if(Storage.fsaccess(pathtosandbox)) {
		let keywords = Storage.fsread(pathtosandbox).split(", ");
	}else{
		keywords = ["KERNEL_", "java.lang", "Database", "DataBase", "android"];
	}
	let didPass = true;
	for(k in keywords) {
		if (command.includes(k)) {
			didPass = false;
			break;
		}
	}
	return didPass;
}