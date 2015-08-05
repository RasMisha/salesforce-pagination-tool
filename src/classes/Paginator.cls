/**
 * Created by RasMisha on 07/29/2015
 */
public with sharing class Paginator implements PaginatorSortItemListener {

	private static final String RECORDS_PER_PAGE_ERROR_MESSAGE = 'Records per page must be a positive number';

	public static final Integer DEFAULT_MAXIMUM_RECORDS_NUMBER = 10000;
	public static final Integer DEFAULT_RECORDS_PER_PAGE = 25;
	public static final Integer DEFAULT_ACTIVE_PAGE = 1;
	public static final Boolean DEFAULT_IMMEDIATLY_RELOAD = true;

	private SObjectType objectType;
	private Integer maxRecordsNumber;
	@testVisible
	private Integer recordsPerPage;
	private Integer activePage;
	private Integer pagesNumber;

	private String[] fields;
	private String[] filterConditions;
	private PaginatorSortItem[] sortItems;
	private Boolean immediatlyReload;

	@testVisible
	private SObject[] onlyIds;
	private SObject[] recordsOnPage;

	public Paginator(SObjectType objectTypeForPagination) {
		objectType = objectTypeForPagination;
		initDefaults();
		initFields();
	}	

	private void initDefaults() {
		maxRecordsNumber = DEFAULT_MAXIMUM_RECORDS_NUMBER;
		activePage = DEFAULT_ACTIVE_PAGE;
		recordsPerPage = DEFAULT_RECORDS_PER_PAGE;
		sortItems = new PaginatorSortItem[] {};
		filterConditions = new String[] {};
		immediatlyReload = DEFAULT_IMMEDIATLY_RELOAD;
	}

	private void initFields() {
		Set<String> fieldsApiNames = objectType.getDescribe().fields.getMap().keySet();	
		fields = new String[] {};
		for (String fieldApiName : fieldsApiNames) {		
			fields.add(fieldApiName);
		}
	}

	public Paginator setMaximumRecordsNumber(Integer newMaxRecordsNumber) {
		maxRecordsNumber = newMaxRecordsNumber;
		return this;
	}

	public Integer getActivePage() {
		return activePage;
	}

	private void setActivePage(Integer value) {
		activePage = value;
		updateRecordsOnPage();
	}

	public Integer getRecordsPerPage() {
		return recordsPerPage;
	}

	public Paginator setRecordsPerPage(Integer newRecordsPerPage) {

		if (newRecordsPerPage == null || newRecordsPerPage <= 0) {
			throw new PaginatorException(RECORDS_PER_PAGE_ERROR_MESSAGE);
		}

		Integer oldStartIndex = getStartIndexOnPage();
		recordsPerPage = newRecordsPerPage;
	
		updateActivePageBasedOnStartRecordOnPage(
			getAllRecordsNumber(), 
			oldStartIndex, 
			newRecordsPerPage
		);
		updatePagesNumber();

		return this;
	}

	public Integer getAllRecordsNumber() {
		if (onlyIds == null) {
			return 0;
		}
		return onlyIds.size();
	}

	public Integer getPagesNumber() {
		return pagesNumber;
	}

	public Integer getStartIndexOnPage() {
		if (onlyIds == null || onlyIds.size() == 0) {
			return 0;
		}

		return getRecordsPerPage() * (getActivePage() - 1) + 1;
	}

	public Integer getEndIndexOnPage() {
		return Math.min(getRecordsPerPage() * getActivePage(), getAllRecordsNumber());
	}

	private String getObjectName() {
		return objectType.getDescribe().getName();
	}

	public String[] getFields() {
		return fields;
	}

	public Paginator setFields(String[] newfields) {
		fields = newfields;
		return this;
	}

	public Paginator addFilterCondition(String condition) {
		if (String.isNotBlank(condition)) {
			filterConditions.add(condition);
		}
		return this;
	}

	public void removeFilterCondition(Integer index) {
		if (index >= 0 &&  index < filterConditions.size()) {
			filterConditions.remove(index);
		}
	}

	public String getFilterConditionAt(Integer index) {
		if (index >= 0 &&  index < filterConditions.size()) {
			return filterConditions[index];
		}
		return null;
	}

	public Paginator addSortItem(PaginatorSortItem sortItem) {
		sortItems.add(sortItem);
		sortItem.setListener(this);
		return this;
	}

	public void removeSortItem(Integer index) {
		if (index < sortItems.size() && index >= 0) {
			PaginatorSortItem itemToRemove = sortItems.get(index);
			itemToRemove.removeListener();
			sortItems.remove(index);
		}
	}

	public Integer sortItemsSize() {
		return sortItems.size();
	}

	public Paginator setImmediatlyReloadOnReverseOneOfTheSortItem(Boolean immediatly) {
		immediatlyReload = immediatly;
		return this;
	}

	public PaginatorSortItem getSortItemAt(Integer index) {
		if (index >= sortItems.size() || index < 0) {
			return null;
		}
		return sortItems.get(index);
	}

	public Boolean nextPage() {
		if (activePage < getPagesNumber()) {
			setActivePage(activePage + 1);
			return true;
		}
		return false;
	}

	public Boolean previousPage() {
		if (activePage > 1) {
			setActivePage(activePage - 1);
			return true;
		}
		return false;
	}

	public void firstPage() {
		setActivePage(1);
	}

	public void lastPage() {
		setActivePage(getPagesNumber());
	}

	public void goToPage(Integer page) {
		if (page >= 1 && page <= getPagesNumber()) {
			setActivePage(page);
		}
	}

	public void reloadRecords() {
		updateRecords();
		updatePagesNumber();
		updateRecordsOnPage();
	}

	public SObject[] getPageData() {
		return recordsOnPage;
	}

	private void updateRecords() {		
		String query = 
			'SELECT Id ' 
			+ ' FROM ' + getObjectName() 
			+ (filterConditions.size() > 0 
				? ' WHERE ' +  PaginatorUtils.join(
					filterConditions,
					PaginatorUtils.AND_SEPARATOR,
					PaginatorUtils.LEFT_BRACKET,
					PaginatorUtils.RIGHT_BRACKET
				)
				: ''
			)
			+ (sortItems.size() > 0 
				? ' ORDER BY ' + PaginatorUtils.join(
					sortItems, 
					PaginatorUtils.COMMA_SEPARATOR
				) 
				: ''
			)
			+ ' LIMIT ' + maxRecordsNumber;

		onlyIds = Database.query(query);
	}

	private void updateRecordsOnPage() {

		Integer startIndex = getStartIndexOnPage();
		Integer endIndex = getEndIndexOnPage();

		if (endIndex <= startIndex) {
			recordsOnPage = new SObject[] {};
			return;
		}

		String[] ids = new String[] {};
		
		String currentId;
		for (Integer index = startIndex; index <= endIndex; index++) {
			currentId = onlyIds[index - 1].Id;
			ids.add(currentId);
		}

		String idsString = PaginatorUtils.join(
			ids, 
			PaginatorUtils.COMMA_SEPARATOR, 
			PaginatorUtils.SINGLE_QUOTE,
			PaginatorUtils.SINGLE_QUOTE
		);

		String fieldString = PaginatorUtils.join(
			getFields(), 
			PaginatorUtils.COMMA_SEPARATOR
		);

		String query = 
			'SELECT ' + fieldString
			+ ' FROM ' + getObjectName() 
			+ ' WHERE Id in (' + idsString +')'
			+ ' LIMIT ' + maxRecordsNumber;

		Map<Id, SObject> unsortedRecords = new Map<Id, SObject>(Database.query(query));

		recordsOnPage = new SObject[] {};
		for (String sortedId : ids) {
			recordsOnPage.add(unsortedRecords.get(sortedId));
		}
	}

	private void updatePagesNumber() {
		if (onlyIds == null || onlyIds.size() == 0) {
			pagesNumber = 1;
		} else {
			pagesNumber = ((onlyIds.size() - 1) / recordsPerPage) + 1;
		}

		if (activePage > pagesNumber) {
			firstPage();
		}
	}

	private void updateActivePageBasedOnStartRecordOnPage(Integer recordsNumber, Integer startIndexOnPage, Integer newRecordsPerPage) {
		Integer subtractCoef = getAllRecordsNumber() > 0 ? 1 : 0;
		setActivePage((startIndexOnPage - subtractCoef) / recordsPerPage + 1);
	}

	public Integer[] getPaginationValues() {
		return PaginatorUtils.getPaginationValues(pagesNumber, activePage);
	}

	public void sortDirectionWasChanged() {
		if (immediatlyReload) {
			reloadRecords();
		}
	}

}