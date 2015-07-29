/**
 * Created by RasMisa on 06/18/2015
 */
public with sharing class Paginator {

	public static final Integer DEFAULT_MAXIMUM_RECORDS_NUMBER = 10000;
	public static final Integer DEFAULT_RECORDS_PER_PAGE = 25;

	private SObjectType objectType;
	private Integer maxRecordsNumber;
	private Integer recordsPerPage;

	public Paginator(SObjectType objectTypeForPagination) {
		objectType = objectTypeForPagination;
		initDefaults();
	}

	private void initDefaults() {
		maxRecordsNumber = DEFAULT_MAXIMUM_RECORDS_NUMBER;
		recordsPerPage = DEFAULT_RECORDS_PER_PAGE;
	}

	public void setMaximumRecordsNumber(Integer newMaxRecordsNumber) {
		maxRecordsNumber = newMaxRecordsNumber;
	}

	public void setRecordsPerPage(Integer newRecordsPerPage) {
		recordsPerPage = newRecordsPerPage;
	}

}