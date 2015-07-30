/**
 * Created by RasMisha on 07/30/2015
 */
@isTest
private class PaginatorTest {
	
	private static final Integer NUMBER_OF_ACCOUNTS = 205;

	@testSetup
	static void setupData() {
		Account[] accounts = new Account[] {};
		

		Account currentAccount = null;
		for (Integer index = 0; index < NUMBER_OF_ACCOUNTS; index++) {
			currentAccount = new Account();
			currentAccount.Name = 'Account Name ' + index;
			accounts.add(currentAccount);
		}

		Database.insert(accounts);
	}

	@isTest(seeAllData = false)
	static void testPaginatorInit() {
		Paginator testPaginator = new Paginator(Account.SObjectType);
		testPaginator.reloadRecords();
		System.assertEquals(NUMBER_OF_ACCOUNTS, testPaginator.getAllRecordsNumber());
		System.assertEquals(1, testPaginator.getStartIndexOnPage());
		System.assertEquals(25, testPaginator.getEndIndexOnPage());
		System.assertEquals(9, testPaginator.getPagesNumber());
	}
	
	@isTest(seeAllData = false)
	static void testPaginatorNextPage() {
		Paginator testPaginator = new Paginator(Account.SObjectType);
		testPaginator.reloadRecords();

		Test.startTest();
		testPaginator.nextPage();
		Test.stopTest();

		System.assertEquals(NUMBER_OF_ACCOUNTS, testPaginator.getAllRecordsNumber());
		System.assertEquals(26, testPaginator.getStartIndexOnPage());
		System.assertEquals(50, testPaginator.getEndIndexOnPage());
		System.assertEquals(2, testPaginator.getActivePage());

		Integer[] actualPaginationValues = testPaginator.getPaginationValues();
		Integer[] expectedArray = new Integer[] {1,2,3, Paginator.DOTS_IN_PAGINATION, 9};

		System.assertEquals(actualPaginationValues.size(), expectedArray.size());
		for (Integer index = 0; index < actualPaginationValues.size(); index++) {
			System.assertEquals(actualPaginationValues[index], expectedArray[index]);
		}
	}

	@isTest(seeAllData = false) 
	static void testPaginatorLastPage() {
		Paginator testPaginator = new Paginator(Account.SObjectType);
		testPaginator.reloadRecords();

		Test.startTest();
		testPaginator.lastPage();
		Test.stopTest();

		System.assertEquals(201, testPaginator.getStartIndexOnPage());
		System.assertEquals(205, testPaginator.getEndIndexOnPage());
		System.assertEquals(9, testPaginator.getActivePage());

		Integer[] actualPaginationValues = testPaginator.getPaginationValues();
		Integer[] expectedArray = new Integer[] {1, Paginator.DOTS_IN_PAGINATION, 7, 8, 9};

		System.assertEquals(actualPaginationValues.size(), expectedArray.size());
		for (Integer index = 0; index < actualPaginationValues.size(); index++) {
			System.assertEquals(actualPaginationValues[index], expectedArray[index]);
		}
	}

	@isTest(seeAllData = false) 
	static void testPaginatorFirstPage() {
		Paginator testPaginator = new Paginator(Account.SObjectType);
		testPaginator.reloadRecords();
		testPaginator.lastPage();

		Test.startTest();
		testPaginator.firstPage();
		Test.stopTest();

		System.assertEquals(1, testPaginator.getStartIndexOnPage());
		System.assertEquals(25, testPaginator.getEndIndexOnPage());
		System.assertEquals(1, testPaginator.getActivePage());

		Integer[] actualPaginationValues = testPaginator.getPaginationValues();
		Integer[] expectedArray = new Integer[] {1,2,3, Paginator.DOTS_IN_PAGINATION, 9};

		System.assertEquals(actualPaginationValues.size(), expectedArray.size());
		for (Integer index = 0; index < actualPaginationValues.size(); index++) {
			System.assertEquals(actualPaginationValues[index], expectedArray[index]);
		}
	}

	@isTest(seeAllData = false) 
	static void testPaginatorPreviousPage() {
		Paginator testPaginator = new Paginator(Account.SObjectType);
		testPaginator.reloadRecords();
		testPaginator.lastPage();

		Test.startTest();
		testPaginator.previousPage();
		Test.stopTest();

		System.assertEquals(176, testPaginator.getStartIndexOnPage());
		System.assertEquals(200, testPaginator.getEndIndexOnPage());
		System.assertEquals(8, testPaginator.getActivePage());


		Integer[] actualPaginationValues = testPaginator.getPaginationValues();
		Integer[] expectedArray = new Integer[] {1, Paginator.DOTS_IN_PAGINATION, 7, 8, 9};

		System.assertEquals(actualPaginationValues.size(), expectedArray.size());
		for (Integer index = 0; index < actualPaginationValues.size(); index++) {
			System.assertEquals(actualPaginationValues[index], expectedArray[index]);
		}
	}

	@isTest(seeAllData = false) 
	static void testPaginatorGoToPage() {
		Paginator testPaginator = new Paginator(Account.SObjectType);
		testPaginator.reloadRecords();

		Test.startTest();
		testPaginator.goToPage(5);
		Test.stopTest();

		System.assertEquals(101, testPaginator.getStartIndexOnPage());
		System.assertEquals(125, testPaginator.getEndIndexOnPage());
		System.assertEquals(5, testPaginator.getActivePage());


		Integer[] actualPaginationValues = testPaginator.getPaginationValues();
		Integer[] expectedArray = new Integer[] {1, Paginator.DOTS_IN_PAGINATION, 4, 5, 6, Paginator.DOTS_IN_PAGINATION, 9};

		System.assertEquals(actualPaginationValues.size(), expectedArray.size());
		for (Integer index = 0; index < actualPaginationValues.size(); index++) {
			System.assertEquals(actualPaginationValues[index], expectedArray[index]);
		}
	}

	@isTest(seeAllData = false) 
	static void testImmediatlyChangeRecordsPerPageTo50() {
		Paginator testPaginator = new Paginator(Account.SObjectType);
		testPaginator.reloadRecords();

		Test.startTest();
		testPaginator.setRecordsPerPage(50);
		Test.stopTest();

		System.assertEquals(5, testPaginator.getPagesNumber());
		System.assertEquals(1, testPaginator.getStartIndexOnPage());
		System.assertEquals(50, testPaginator.getEndIndexOnPage());

		Integer[] actualPaginationValues = testPaginator.getPaginationValues();
		Integer[] expectedArray = new Integer[] {1, 2, 3, 4, 5};

		System.assertEquals(actualPaginationValues.size(), expectedArray.size());
		for (Integer index = 0; index < actualPaginationValues.size(); index++) {
			System.assertEquals(actualPaginationValues[index], expectedArray[index]);
		}	
	}
}