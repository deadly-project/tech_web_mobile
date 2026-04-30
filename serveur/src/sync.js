import {spawn} from 'node:child_process'
import {watch} from 'node:fs/promises'
const [node, _, file] = process.argv

function restartServer(){
    const childProcess = spawn(node, [file]);
    childProcess.stdout.on('data', (data) => {
        console.log(data.toString('utf8'));
    });
    childProcess.stderr.on('data', (data) => {
        console.log(data.toString('utf8'));
    });
    //Gestionnaire d'erreur, à decommenter en production
    /*childProcess.on('close', (code) => {
        if (code > 0) {
            throw new Error('Process exited : ' + code)
        }
    })*/
    return childProcess;
}


let server = restartServer();
const watcher = watch('./', {recursive: true});
for await (const event of watcher){
    if(event.filename.endsWith('.js')){
        server.kill();
        server = restartServer();
    }
}