/**
 * Created by RasMisha on 07/31/2015
 */
public with sharing class ExamplePaginatorController {

	private static final String[] FIELDS = new String[] {
		'First_Name__c',
		'Last_Name__c',
		'Height__c',
		'Team__c',
		'Team__r.Foundation_Date__c',
		'Team__r.Name',
		'Team__r.President__c',
		'Team__r.Active__c'
	};
	private static final String ACTIVE_TEAM_CONDITION = 'Team__r.Active__c = True';
	private static final String HEIGHT_FIELD = 'Height__c';
	private static final Integer RECORDS_PER_PAGE = 10;

	private Paginator players = null;

	public Player__c[] pageRecords { 
		get {
			return (Player__c[])players.getPageData();
		}
		private set;
	}
	public Integer[] pageValues {
		get {
			return players.getPaginationValues();			
		}
		private set;
	}
	public Integer activePage {
		get {
			return players.getActivePage();
		}
		private set;
	}
	public Integer startIndex {
		get {
			return players.getStartIndexOnPage();
		}
		private set;
	}
	public Integer endIndex {
		get {
			return players.getEndIndexOnPage();
		}
		private set;
	}
	public Integer numberOfRecords {
		get {
			return players.getAllRecordsNumber();
		}
		private set;
	}
	public Integer numberOfPages {
		get {
			return players.getPagesNumber();
		}
		private set;
	}

	public Integer selectedPage {get;set;}

	public ExamplePaginatorController() {
		initPaginator();
	}

	private void initPaginator() {
		players = new Paginator(Player__c.SObjectType)
			.setFields(FIELDS)
			.setRecordsPerPage(RECORDS_PER_PAGE)
			.addFilterCondition(ACTIVE_TEAM_CONDITION)
			.addSortItem(new PaginatorSortItem(HEIGHT_FIELD, PaginatorSortType.DESCENDING));
		players.reloadRecords();
	}

	public void previousPage() {
		players.previousPage();
	}

	public void nextPage() {
		players.nextPage();
	}

	public void goToPage() {
		players.goToPage(selectedPage);
	}
}