import { Injectable } from '@angular/core';

@Injectable()
export class AlertService {

	constructor() { }

	listAlerts(){
		return [{
			"batchId":"21213",
			"userId":"123322",
			"databaseUrl":"mongodb://192.168.0.1/testbd",
			"collection":"contatos",
			"status":"DONE"
		},{
			"batchId":"111111",
			"userId":"333333333",
			"databaseUrl":"mongodb://10.0.0.1/test",
			"collection":"usuarios",
			"status":"IN_PROGRESS"
		},{
			"batchId":"111111",
			"userId":"333333333",
			"databaseUrl":"mongodb://10.0.0.1/test",
			"collection":"usuarios",
			"status":"ERROR"
		}]
	}

}
