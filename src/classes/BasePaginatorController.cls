/**
 * Created by RasMisha on 08/03/2015
 */
 public abstract with sharing class BasePaginatorController {

 	/**
 	* Constants for vf-page
 	*/
 	public Integer DOTS_IN_PAGINATION {
 		get {
 			return PaginatorUtils.DOTS_IN_PAGINATION;
 		}
 		private set;
 	}

 	/**
 	* Paginator instance
 	*/ 
 	protected Paginator currentPaginator = null;

 	/**
 	* Properties
 	*/
	public Player__c[] pageRecords { 
		get {
			return (Player__c[])currentPaginator.getPageData();
		}
		private set;
	}
	public Integer[] pageValues {
		get {
			return currentPaginator.getPaginationValues();			
		}
		private set;
	}
	public Integer activePage {
		get {
			return currentPaginator.getActivePage();
		}
		private set;
	}
	public Integer startIndex {
		get {
			return currentPaginator.getStartIndexOnPage();
		}
		private set;
	}
	public Integer endIndex {
		get {
			return currentPaginator.getEndIndexOnPage();
		}
		private set;
	}
	public Integer numberOfRecords {
		get {
			return currentPaginator.getAllRecordsNumber();
		}
		private set;
	}
	public Integer numberOfPages {
		get {
			return currentPaginator.getPagesNumber();
		}
		private set;
	}
	public Integer selectedPage {get;set;}

	/**
	* Constructor
	*/
	public BasePaginatorController() {
		initPaginator();
	}

	/**
	* Abstract methods
	*/
	protected abstract void initPaginator();

	/**
	* Common methods
	*/
	public void previousPage() {
		currentPaginator.previousPage();
	}

	public void nextPage() {
		currentPaginator.nextPage();
	}

	public void goToPage() {
		currentPaginator.goToPage(selectedPage);
	}
}