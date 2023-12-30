import { Component, OnInit } from '@angular/core';
import { DataSource } from '@angular/cdk/table';
import { Observable } from 'rxjs';
import { BehaviorSubject } from 'rxjs';
import { AlertService, FeedbackService } from '../../_services/services';

@Component({
  selector: 'app-alert',
  templateUrl: './alert.component.html',
  styleUrls: ['./alert.component.css']
})
export class AlertComponent implements OnInit {

  dataSource: AlertSource | null;
  dataSubject = new BehaviorSubject<any[]>([]);
  displayedColumns = ['status', 'dbUri', 'collectionName', 'date', 'actions'];

  constructor(private alertService: AlertService, private feedbackService: FeedbackService) { }

  ngOnInit() {
    this.loadAlerts();
  }

  loadAlerts() {
    this.alertService.listAlerts().subscribe({
      next: value => this.dataSubject.next(value)
    });
    if (this.dataSubject) {
      this.dataSource = new AlertSource(this.dataSubject);
    }
  }

  getStatusIcon(alertStatus) {
    switch (alertStatus) {
      case 'ERROR':
        return 'report_problem';
      case 'DONE':
        return 'check_circle';
    }
  }

  getStatusColor(alertStatus) {
    switch (alertStatus) {
      case 'ERROR':
        return 'warn';
      case 'DONE':
        return 'primary';
    }
  }

  getTypeTooltip(alertType) {
    switch (alertType) {
      case 'DONE':
        return 'Completed successfully';
      case 'DATABASE_CONNECTION_ERROR':
        return 'Unable to connect to database. Check the address entered and try again.';
      case 'EMPTY_COLLECTION_ERROR':
        return 'There are no documents in the reported collection. Check the reported collection and try again.';
      case 'LOADING_DOCUMENTS_ERROR':
        return 'There was a problem reading the documents. Try again.';
      default:
        return 'Unable to complete extraction. Try again.';
    }
  }

  delete(alertId) {
    this.alertService.deleteAlert(alertId).subscribe(() => {
      this.feedbackService.success('Deleted');
      this.loadAlerts();
    });
  }

}

export class AlertSource extends DataSource<any[]> {

  constructor(private subject: BehaviorSubject<any[]>) {
    super ();
  }

  connect (): Observable<any[]> {
    return this.subject.asObservable();
  }

  disconnect (  ): void {
  }

}
