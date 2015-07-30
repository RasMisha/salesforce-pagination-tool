/**
 * Created by RasMisha on 07/29/2015
 */
public with sharing class Paginator {

	public static final Integer DEFAULT_MAXIMUM_RECORDS_NUMBER = 10000;
	public static final Integer DEFAULT_RECORDS_PER_PAGE = 25;
	public static final Integer DEFAULT_ACTIVE_PAGE = 1;

	public static final Integer DOTS_IN_PAGINATION = -1;

	private SObjectType objectType {get;set;}
	private Integer maxRecordsNumber {get;set;}
	public Integer recordsPerPage {
		get;
		set {
			recordsPerPage = value;

			Integer recordsNumber = onlyIds == null ? 0 : onlyIds.size();
			updateActivePageBasedOnStartRecordOnPage(recordsNumber, startIndexOnPage, value);
		}
	}

	private Integer activePage {get; set;}
	private Integer pagesNumber {get;set;}
	private Integer startIndexOnPage {get;set;}
	private Integer lastIndexOnPage {get;set;}

	private SObject[] onlyIds;
	private SObject[] recordsOnPage;

	public Paginator(SObjectType objectTypeForPagination) {
		objectType = objectTypeForPagination;
		initDefaults();
	}

	private void initDefaults() {
		maxRecordsNumber = DEFAULT_MAXIMUM_RECORDS_NUMBER;
		recordsPerPage = DEFAULT_RECORDS_PER_PAGE;
		activePage = DEFAULT_ACTIVE_PAGE;
	}

	public void setMaximumRecordsNumber(Integer newMaxRecordsNumber) {
		maxRecordsNumber = newMaxRecordsNumber;
	}

	public void setActivePage(Integer value) {
		activePage = value;
		updateStartAndLastIndexOnPage();
	}

	public Integer getActivePage() {
		return activePage;
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

		String objectName = objectType.getDescribe().getName();
		String query = 'SELECT Id FROM ' + objectName + ' LIMIT ' + maxRecordsNumber;		

		onlyIds = Database.query(query);

		updatePagesNumber();
	}

	public SObject[] getPageData() {
		return null;
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
		Integer subtractCoef = recordsNumber > 0 ? 1 : 0;
		activePage = (startIndexOnPage - subtractCoef) / recordsPerPage + 1;
	}

	private void updateStartAndLastIndexOnPage() {
		if (onlyIds == null || onlyIds.size() == 0) {
			startIndexOnPage = 0;
			lastIndexOnPage = 0;
		} else {
			startIndexOnPage = recordsPerPage * (activePage - 1) + 1;
			lastIndexOnPage = Math.min(onlyIds.size(), startIndexOnPage + recordsPerPage - 1);
		}
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