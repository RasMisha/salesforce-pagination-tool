/**
 * Created by RasMisha on 07/29/2015
 */
public with sharing class Paginator {

	public static final Integer DEFAULT_MAXIMUM_RECORDS_NUMBER = 10000;
	public static final Integer DEFAULT_RECORDS_PER_PAGE = 25;
	public static final Integer DEFAULT_ACTIVE_PAGE = 1;

	public static final Integer DOTS_IN_PAGINATION = -1;

	private SObjectType objectType;
	private Integer maxRecordsNumber;
	public Integer recordsPerPage;
	private Integer activePage;
	private Integer pagesNumber;

	private SObject[] onlyIds;
	private SObject[] recordsOnPage;

	public Paginator(SObjectType objectTypeForPagination) {
		objectType = objectTypeForPagination;
		initDefaults();
	}

	private void initDefaults() {
		maxRecordsNumber = DEFAULT_MAXIMUM_RECORDS_NUMBER;		
		activePage = DEFAULT_ACTIVE_PAGE;
		recordsPerPage = DEFAULT_RECORDS_PER_PAGE;
	}

	public void setMaximumRecordsNumber(Integer newMaxRecordsNumber) {
		maxRecordsNumber = newMaxRecordsNumber;
	}

	public Integer getActivePage() {
		return activePage;
	}

	private void setActivePage(Integer value) {
		activePage = value;
	}

	public Integer getRecordsPerPage() {
		return recordsPerPage;
	}

	public void setRecordsPerPage(Integer newRecordsPerPage) {
		Integer oldStartIndex = getStartIndexOnPage();
		recordsPerPage = newRecordsPerPage;
	
		updateActivePageBasedOnStartRecordOnPage(
			getAllRecordsNumber(), 
			oldStartIndex, 
			newRecordsPerPage
		);
	}

	public Integer getAllRecordsNumber() {
		return onlyIds.size();
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

	public String getFields() {
		return ' Id, Name ';
	}

	public Boolean nextPage() {
		if (activePage < pagesNumber) {
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

	public void lastPage() {
		setActivePage(pagesNumber);
	}

	public void firstPage() {
		setActivePage(1);
	}

	public void reloadRecords() {
		updateRecords();
		updatePagesNumber();
	}

	public SObject[] getPageData() {
		Integer startIndex = getStartIndexOnPage();
		Integer endIndex = getEndIndexOnPage();

		String[] ids = new String[] {};

		for (Integer index = startIndex; index <= endIndex; index++) {
			ids.add(onlyIds[index].Id);
		}

		String query = 'SELECT ' + getFields() + ' FROM ' + getObjectName() + ' LIMIT ' + maxRecordsNumber;

		recordsOnPage = Database.query(query);

		return recordsOnPage;
	}

	private void updateRecords() {		
		String query = 'SELECT Id FROM ' + getObjectName() + ' LIMIT ' + maxRecordsNumber;

		onlyIds = Database.query(query);
	}

	private void updatePagesNumber() {
		if (onlyIds.size() == 0) {
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
		Integer[] values = new Integer[] {};
		if (pagesNumber <= 6) {
			for (Integer value = 1; value <= pagesNumber; value++) {
				values.add(value);
			}
		} else {
			
			if (activePage > 3) {
				values.add(1);
				values.add(DOTS_IN_PAGINATION);
				if (activePage == pagesNumber) {
					values.add(activePage - 2);
				}
				values.add(activePage - 1);
				values.add(activePage);
			} else {

				for (Integer value = 1; value <= activePage; value++) {
					values.add(value);
				}
			}

			if (activePage < pagesNumber - 3) {
				values.add(activePage+1);
				if (activePage == 1) {
					values.add(activePage+2);
				}
				values.add(DOTS_IN_PAGINATION);
				values.add(pagesNumber);
			} else {
				for (Integer value = activePage + 1; value <= pagesNumber; value++) {
					values.add(value);
				}	
			}

		}
		return values;
	}

}