var http = require('http');
var url  = require('url');
const { exec } = require('child_process');
var fs = require('fs');

function shutdownWindow() {
	let command = exec('shutdown -s -t 00', function(err, stdout, stderr) {
        if(err || stderr) {
            console.log("shutdown failed" + err + stderr);
        }
    });
    command.stdin.end();
    command.on('close', function(code) {
        console.log("shutdown",  code);
    });
}

function isNumber(value){
	if(isNaN(value)){
		return false;
	}
	else{
		return true;
	}
}

var server = http.createServer(function (req, res) {
  setTimeout(function () { //simulate a long request
    res.writeHead(200, {'Content-Type': 'text/html;charset=utf8'});
	var requset_url = req.url;
        //将字符串格式参数转化为对象使用
    var queryCode  = url.parse(requset_url,true).query.code;
	if (isNumber(queryCode) && queryCode > 0) {
		//如果参数解密，写到这里
	}
	else {
		queryCode = 0;
	}
	var currentDate =  Math.floor(Date.now()/1000);
	var succ = false;
	if (currentDate > 0 && Math.abs(currentDate - queryCode) < 10) {
		res.end('<h1 style=" text-align: center; ">报告老大，我正在关机...</h1>');
		succ = true;
		shutdownWindow();
	}
	else {
		res.end('<h1 style=" text-align: center; ">参数错误，请重试...</h1>');
	}
    //
	var dateString = new Date().toLocaleString();
	fs.appendFile('./ip_list.log', 'time:【'+dateString+'】 -- ip:【' + req.connection.remoteAddress+'】 -- status:【'+(succ?'成功':'失败')+'】\n', function (error) {
		if (error) {
			console.log('写入IP失败')
		} else {
			console.log('写入IP成功')
		}
	});
  }, 100);
}).listen(1203, function (err) {
  console.log('listening http://localhost:1203/');
  console.log('pid is ' + process.pid);
  fs.appendFile('./pid.log', 'pid is ' + process.pid+'\n', function (error) {
		if (error) {
			console.log('写入PID失败')
		} else {
			console.log('写入PID成功')
		}
	});
});

process.on('exit', function () {
  server.close(function () {
	  console.log('关机');
    process.exit(0);
  });
});