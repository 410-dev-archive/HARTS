exports.fswrite = function(filePath, contents) {
	DataBase.setDataBase(filePath, contents);
	return require("./Storage.js").fsaccess(filePath);
}

exports.fsread = function(filePath) {
	return DataBase.getDataBase(filePath);
}

exports.fsdelete = function(filePath) {
	if (require("./Storage.js").fsaccess(filePath)) {
		return DataBase.removeDataBase(filePath);
	}else{
		return "File not found.";
	}
}

exports.fsaccess = function(filePath) {
	if (require("./Storage.js").fsread(filePath)) {
		return true
	}else{
		return false
	}
}