const Storage = require("./Storage.js");

exports.set = function(userName, key, value) {
	Storage.fswrite("users.d/" + userName + "/" + key, value);
}

exports.get = function(userName, key) {
	if(Storage.fsread("users.d/" + userName + "/" + key).equals("File not found.")) {
		return "null";
	}else{
		return Storage.fsread("users.d/" + userName + "/" + key);
	}
}