import { LightningElement, api, track } from 'lwc';
import getProducts from '@salesforce/apex/ProductController.getProducts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class OrderManagementPage extends LightningElement {
    @api recordId;
    @track products = [];
    @track typeFilter = '';
    @track familyFilter = '';
    @track searchKey = '';
    @track accountName = 'Example Account';
    @track accountNumber = '12345';
    @track showCreateButton = false;
    
    typeOptions = ['Type 1','Type 2','Type 3'];
    familyOptions = ['Family 1','Family 2','Family 3'];
    
    connectedCallback() {
        this.fetchProducts();
        this.checkIfManager();
    }
    
    fetchProducts() {
        getProducts({ searchKey: this.searchKey, typeFilter: this.typeFilter, familyFilter: this.familyFilter })
        .then(result => {
            this.products = result;
        });
    }
    
    checkIfManager() {
        this.showCreateButton = true;
    }
    
    handleSearch(event) {
        this.searchKey = event.target.value;
        this.fetchProducts();
    }
    
    handleTypeFilter(event) {
        this.typeFilter = event.target.label;
        this.fetchProducts();
    }
    
    handleFamilyFilter(event) {
        this.familyFilter = event.target.label;
        this.fetchProducts();
    }
    
    handleDetails(event) {
        const pId = event.target.dataset.id;
        this.dispatchEvent(new ShowToastEvent({ title: 'Details', message: pId, variant: 'info' }));
    }
    
    addToCart(event) {
        const pId = event.target.dataset.id;
        this.dispatchEvent(new ShowToastEvent({ title: 'Added to Cart', message: pId, variant: 'success' }));
    }
    
    openCart() {
        this.dispatchEvent(new ShowToastEvent({ title: 'Cart', message: 'Cart opened', variant: 'info' }));
    }
    
    handleCreateProduct() {
        this.dispatchEvent(new ShowToastEvent({ title: 'Create Product', message: 'Open modal for manager', variant: 'info' }));
    }
}
