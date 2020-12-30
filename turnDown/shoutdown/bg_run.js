let Service = require('node-windows').Service;

let svc = new Service({
	name :'shotdown',
	description:'关机',
	script:'./shotdown.js',
	wait:'1',
	grow:'0.25',
	maxRestarts:'40',
});

svc.on('install',()=> {
	svc.start();
	console.log('install complete.');
});

svc.on ('uninstall', ()=> {
	console.log('Uninstall complete.');
	console.log('The service exists:', svc.exists);
});

svc.on('alreadyinstalled', () => {
	console.log('This service is already installed.');
});
if (svc.exists) return svc.uninstall();
svc.install();