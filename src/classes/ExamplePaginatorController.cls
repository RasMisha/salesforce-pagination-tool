/**
 * Created by RasMisha on 08/03/2015
 */
public with sharing class ExamplePaginatorController extends BasePaginatorController {

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

	public ExamplePaginatorController() {
		super();
	}

	protected override void initPaginator() {
		currentPaginator = new Paginator(Player__c.SObjectType)
			.setFields(FIELDS)
			.setRecordsPerPage(RECORDS_PER_PAGE)
			.addFilterCondition(ACTIVE_TEAM_CONDITION)
			.addSortItem(new PaginatorSortItem(HEIGHT_FIELD, PaginatorSortType.DESCENDING));
		currentPaginator.reloadRecords();
	}

	
}