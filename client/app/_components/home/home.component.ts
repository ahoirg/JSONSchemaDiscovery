import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { User } from '../../_models/user';
import { JsonSchemaService, FeedbackService } from '../../_services/services';
import { BatchDeleteModalComponent } from '../batch-delete-modal/batch-delete-modal.component';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

  currentUser: User;
  batches: any;

  constructor(private dialog: MatDialog, private jsonSchemaService: JsonSchemaService, private feedbackService: FeedbackService) { }

  ngOnInit() {
    this.currentUser = JSON.parse(localStorage.getItem('currentUser'));
    this.jsonSchemaService.listBatches().subscribe((batches) => {
      this.batches = batches;
    });
  }

  delete(batchId) {
    const deleteModal = this.dialog.open(BatchDeleteModalComponent, {
      width: '250px',
      data: { 'batchId': batchId }
    });
    deleteModal.afterClosed().subscribe((result) => {
      if (result) {
        this.jsonSchemaService.deleteBatch(batchId).subscribe(() => {
          this.feedbackService.success('Deleted');
          this.jsonSchemaService.listBatches().subscribe((batches) => {
            this.batches = batches;
          });
        });
      }
    });
  }

  getStatusIcon(batchStatus) {
    switch (batchStatus) {
      case 'ERROR':
        return 'report_problem';
      case 'DONE':
        return 'check_circle';
    }
  }

  getStatusColor(batchStatus) {
    switch (batchStatus) {
      case 'ERROR':
        return 'warn';
      default:
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
        return 'There are no documents in the reported collection. Check it and try again.';
      case 'LOADING_DOCUMENTS_ERROR':
        return 'There was a problem reading the documents. Try again.';
      default:
        return 'Unable to complete extraction. Try again.';
    }
  }

}
